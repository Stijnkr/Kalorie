import 'dart:async';
import 'dart:io' show SocketException;

import 'package:isar_community/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants.dart';
import '../local/collections/app_settings.dart';
import '../local/collections/diary_entry.dart';
import '../local/collections/enums.dart';
import '../local/collections/food.dart';
import '../local/collections/recipe.dart';
import '../local/collections/reminder.dart';
import '../local/collections/sync_cursor.dart';
import '../local/collections/water_entry.dart';
import '../local/collections/weight_entry.dart';
import 'local_identity.dart';
import 'sync_stamp.dart';

enum SyncPhase { idle, running, done, failed, offline }

enum CloudAdoptResult { uploaded, synced, needsSwitch, switched }

class SyncStatus {
  const SyncStatus({
    this.phase = SyncPhase.idle,
    this.lastSuccess,
    this.message,
  });

  final SyncPhase phase;
  final DateTime? lastSuccess;
  final String? message;

  bool get busy => phase == SyncPhase.running;
}

/// Synchroniseert het logboek, gewicht, water, eigen producten, recepten,
/// herinneringen en doelen met Supabase.
///
/// Het model is bewust simpel: elke rij draagt `updatedAt`, en bij een botsing
/// wint de nieuwste. Verwijderen gaat via tombstones, zodat een regel die je op
/// je telefoon weghaalt niet terugkomt vanaf je iPad. De client onthoudt per
/// tabel tot welk moment hij heeft opgehaald.
class SyncEngine {
  SyncEngine(this._isar);

  final Isar _isar;

  final _controller = StreamController<SyncStatus>.broadcast();
  SyncStatus _status = const SyncStatus();
  bool _running = false;

  Stream<SyncStatus> get statusStream => _controller.stream;
  SyncStatus get status => _status;

  SupabaseClient get _db => Supabase.instance.client;
  String? get _userId => _db.auth.currentUser?.id;

  void dispose() => _controller.close();

  void _emit(SyncStatus next) {
    _status = next;
    if (!_controller.isClosed) _controller.add(next);
  }

  /// Draait één volledige ronde: eerst alles wat lokaal openstaat naar boven,
  /// daarna wat er sinds de vorige keer op de server is veranderd naar beneden.
  Future<void> run() async {
    final userId = _userId;
    if (userId == null || _running) return;
    _running = true;
    _emit(SyncStatus(phase: SyncPhase.running, lastSuccess: _status.lastSuccess));
    try {
      await ensureLocalIdentity(_isar);
      await _resetCursorsIfUserChanged(userId);
      final settings = await _isar.settings.get(1) ?? AppSettings.defaults();

      await _pushSettings(userId, settings);
      await _pushCustomFoods(userId);
      await _pushRecipes(userId);
      await _pushReminders(userId);
      if (settings.syncDiary) {
        await _pushDiary(userId);
        await _pushWater(userId);
      }
      if (settings.syncWeight) await _pushWeight(userId);

      await _pullSettings(userId);
      await _seedDisplayName();
      await _pullCustomFoods(userId);
      await _pullRecipes(userId);
      await _pullReminders(userId);
      if (settings.syncDiary) {
        await _pullDiary(userId);
        await _pullWater(userId);
      }
      if (settings.syncWeight) await _pullWeight(userId);

      _emit(SyncStatus(phase: SyncPhase.done, lastSuccess: DateTime.now()));
    } on SocketException {
      _emit(SyncStatus(phase: SyncPhase.offline, lastSuccess: _status.lastSuccess));
    } catch (e) {
      _emit(
        SyncStatus(
          phase: SyncPhase.failed,
          lastSuccess: _status.lastSuccess,
          message: '$e',
        ),
      );
    } finally {
      _running = false;
    }
  }

  /// Alles wat lokaal staat als nieuw aanbieden. Draait na het aanmaken van een
  /// account, zodat wat je offline had opgebouwd meegaat naar de cloud.
  Future<void> uploadEverything() async {
    await ensureLocalIdentity(_isar);
    await _isar.writeTxn(() async {
      final entries = await _isar.diaryEntries.where().findAll();
      for (final e in entries) {
        e.dirty = true;
      }
      await _isar.diaryEntries.putAll(entries);

      final weights = await _isar.weightEntries.where().findAll();
      for (final w in weights) {
        w.dirty = true;
      }
      await _isar.weightEntries.putAll(weights);

      final water = await _isar.waterEntries.where().findAll();
      for (final w in water) {
        w.dirty = true;
      }
      await _isar.waterEntries.putAll(water);

      final recipes = await _isar.recipes.where().findAll();
      for (final r in recipes) {
        r.dirty = true;
      }
      await _isar.recipes.putAll(recipes);

      final reminders = await _isar.reminders.where().findAll();
      for (final r in reminders) {
        r.dirty = true;
      }
      await _isar.reminders.putAll(reminders);

      final customs = await _isar.foods
          .filter()
          .sourceEqualTo(FoodSource.custom)
          .findAll();
      for (final f in customs) {
        f.clientId ??= newClientId();
        f
          ..dirty = true
          ..updatedAt ??= DateTime.now();
      }
      await _isar.foods.putAll(customs);

      final settings = await _isar.settings.get(1);
      if (settings != null) {
        settings
          ..dirty = true
          ..updatedAt = DateTime.now();
        await _isar.settings.put(settings);
      }
    });
    await run();
  }

  /// Na inloggen: lokale data claimen, bij dezelfde user syncen, of vragen
  /// of we van account wisselen.
  Future<CloudAdoptResult> adoptOrSync({required bool switchConfirmed}) async {
    final userId = _userId;
    if (userId == null) return CloudAdoptResult.synced;
    final settings = await _isar.settings.get(1) ?? AppSettings.defaults();
    final owner = settings.cloudUserId;
    if (owner == null || owner.isEmpty) {
      await _setCloudUserId(userId);
      await _seedDisplayName();
      await uploadEverything();
      return CloudAdoptResult.uploaded;
    }
    if (owner == userId) {
      await _seedDisplayName();
      await run();
      return CloudAdoptResult.synced;
    }
    if (!switchConfirmed) return CloudAdoptResult.needsSwitch;
    await replaceLocalWithAccount(userId);
    return CloudAdoptResult.switched;
  }

  /// Gooit lokale gebruikersdata weg en haalt die van [userId] op.
  Future<void> replaceLocalWithAccount(String userId) async {
    await _isar.writeTxn(() async {
      await _isar.diaryEntries.clear();
      await _isar.weightEntries.clear();
      await _isar.waterEntries.clear();
      await _isar.recipes.clear();
      await _isar.syncCursors.clear();
      final customs = await _isar.foods
          .filter()
          .sourceEqualTo(FoodSource.custom)
          .findAll();
      if (customs.isNotEmpty) {
        await _isar.foods.deleteAll(customs.map((f) => f.id).toList());
      }
      await _isar.reminders.clear();
      await _isar.reminders.putAll([
        for (final (kind, hour, minute) in Reminder.defaults)
          Reminder.seed(kind, hour, minute)
            ..updatedAt = DateTime.fromMillisecondsSinceEpoch(0),
      ]);
      final settings = await _isar.settings.get(1) ?? AppSettings.defaults();
      settings
        ..id = 1
        ..cloudUserId = userId
        ..displayName = null
        ..dirty = false;
      await _isar.settings.put(settings);
    });
    await run();
  }

  /// Na account verwijderen: de cloud-eigenaar loskoppelen. Lokale rijen blijven.
  Future<void> releaseCloudOwner() {
    return _isar.writeTxn(() async {
      await _isar.syncCursors.clear();
      final settings = await _isar.settings.get(1);
      if (settings == null) return;
      settings.cloudUserId = null;
      await _isar.settings.put(settings);
    });
  }

  /// Na uitloggen blijft alles lokaal staan, maar de cursors kloppen niet meer.
  Future<void> forgetCursors() {
    return _isar.writeTxn(() => _isar.syncCursors.clear());
  }

  // --------------------------------------------------------------- cursors

  Future<void> _setCloudUserId(String userId) {
    return _isar.writeTxn(() async {
      final settings = await _isar.settings.get(1) ?? AppSettings.defaults();
      settings
        ..id = 1
        ..cloudUserId = userId;
      await _isar.settings.put(settings);
    });
  }

  Future<void> _seedDisplayName() async {
    final user = _db.auth.currentUser;
    if (user == null) return;
    final settings = await _isar.settings.get(1);
    if (settings == null) return;
    if (settings.displayName != null && settings.displayName!.trim().isNotEmpty) {
      return;
    }
    String? name = user.userMetadata?['display_name'] as String?;
    if (name == null || name.trim().isEmpty) {
      try {
        final row = await _db
            .from('profiles')
            .select('display_name')
            .eq('id', user.id)
            .maybeSingle();
        name = row?['display_name'] as String?;
      } catch (_) {
        // Profiel is optioneel; de e-mail blijft dan de zichtbare naam.
      }
    }
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return;
    await _isar.writeTxn(() async {
      final fresh = await _isar.settings.get(1);
      if (fresh == null) return;
      if (fresh.displayName != null && fresh.displayName!.trim().isNotEmpty) {
        return;
      }
      fresh.displayName = trimmed;
      await _isar.settings.put(fresh);
    });
  }

  Future<void> _resetCursorsIfUserChanged(String userId) async {
    final cursors = await _isar.syncCursors.where().findAll();
    final stale = cursors.where((c) => c.userId != userId).toList();
    if (stale.isEmpty) return;
    await _isar.writeTxn(
      () => _isar.syncCursors.deleteAll(stale.map((c) => c.id).toList()),
    );
  }

  Future<DateTime?> _cursor(String table) async {
    final row =
        await _isar.syncCursors.filter().tableEqualTo(table).findFirst();
    return row?.pulledUpTo;
  }

  Future<void> _setCursor(String table, String userId, DateTime? value) {
    return _isar.writeTxn(() async {
      final row =
          await _isar.syncCursors.filter().tableEqualTo(table).findFirst() ??
              SyncCursor();
      row
        ..table = table
        ..userId = userId
        ..pulledUpTo = value;
      await _isar.syncCursors.put(row);
    });
  }

  /// Nieuwste `updated_at` uit een serverantwoord, zodat de volgende pull daar
  /// verdergaat.
  DateTime? _newest(List<Map<String, dynamic>> rows) {
    DateTime? newest;
    for (final row in rows) {
      final raw = row['updated_at'];
      if (raw is! String) continue;
      final parsed = DateTime.tryParse(raw)?.toUtc();
      if (parsed == null) continue;
      if (newest == null || parsed.isAfter(newest)) newest = parsed;
    }
    return newest;
  }

  Future<List<Map<String, dynamic>>> _fetchSince(
    String table,
    String userId,
  ) async {
    final since = await _cursor(table);
    final all = <Map<String, dynamic>>[];
    var offset = 0;
    const page = 2000;
    while (true) {
      var query = _db.from(table).select().eq('user_id', userId);
      if (since != null) {
        query = query.gte('updated_at', since.toIso8601String());
      }
      final rows = await query
          .order('updated_at')
          .range(offset, offset + page - 1);
      final pageRows = rows.cast<Map<String, dynamic>>();
      if (pageRows.isEmpty) break;
      all.addAll(pageRows);
      if (pageRows.length < page) break;
      offset += pageRows.length;
    }
    return all;
  }

  // ------------------------------------------------------------- instellingen

  Future<void> _pushSettings(String userId, AppSettings settings) async {
    if (!settings.dirty) return;
    final pushedAt = settings.updatedAt;
    await _db.from('user_settings').upsert({
      'user_id': userId,
      'kcal_goal': settings.kcalGoal,
      'protein_goal': settings.proteinGoal,
      'carbs_goal': settings.carbsGoal,
      'fat_goal': settings.fatGoal,
      'theme': settings.theme.name,
      'sync_diary': settings.syncDiary,
      'sync_weight': settings.syncWeight,
      'updated_at': (settings.updatedAt ?? DateTime.now()).toUtc().toIso8601String(),
    });
    await _isar.writeTxn(() async {
      final fresh = await _isar.settings.get(1);
      if (fresh == null) return;
      if (pushedAt != null &&
          fresh.updatedAt != null &&
          fresh.updatedAt!.isAfter(pushedAt)) {
        return;
      }
      fresh.dirty = false;
      await _isar.settings.put(fresh);
    });
  }

  Future<void> _pullSettings(String userId) async {
    final rows = await _fetchSince('user_settings', userId);
    if (rows.isEmpty) return;
    final row = rows.last;
    final remoteUpdated = DateTime.tryParse('${row['updated_at']}')?.toUtc();
    await _isar.writeTxn(() async {
      final local = await _isar.settings.get(1) ?? AppSettings.defaults();
      final localUpdated = local.updatedAt?.toUtc();
      if (remoteUpdated != null &&
          localUpdated != null &&
          localUpdated.isAfter(remoteUpdated)) {
        return; // lokaal is nieuwer
      }
      local
        ..id = 1
        ..kcalGoal = (row['kcal_goal'] as num?)?.toInt() ?? local.kcalGoal
        ..proteinGoal =
            (row['protein_goal'] as num?)?.toDouble() ?? local.proteinGoal
        ..carbsGoal = (row['carbs_goal'] as num?)?.toDouble() ?? local.carbsGoal
        ..fatGoal = (row['fat_goal'] as num?)?.toDouble() ?? local.fatGoal
        ..theme = ThemeModeSetting.values.firstWhere(
          (t) => t.name == row['theme'],
          orElse: () => local.theme,
        )
        ..syncDiary = row['sync_diary'] as bool? ?? local.syncDiary
        ..syncWeight = row['sync_weight'] as bool? ?? local.syncWeight
        ..updatedAt = remoteUpdated
        ..dirty = false;
      await _isar.settings.put(local);
    });
    await _setCursor('user_settings', userId, _newest(rows));
  }

  // ----------------------------------------------------------------- logboek

  Future<void> _pushDiary(String userId) async {
    final pending =
        await _isar.diaryEntries.filter().dirtyEqualTo(true).findAll();
    if (pending.isEmpty) return;
    final payload = pending
        .map(
          (e) => {
            'user_id': userId,
            'client_id': e.clientId,
            'date_key': e.dateKey,
            'meal': e.meal.name,
            'food_name': e.foodName,
            'brand': e.brand,
            'source': e.source.name,
            'amount_g': e.amountG,
            'serving_label': e.servingLabel,
            'kcal': e.kcal,
            'protein': e.protein,
            'carbs': e.carbs,
            'fat': e.fat,
            'fiber': e.fiber,
            'sugars': e.sugars,
            'sat_fat': e.satFat,
            'salt': e.salt,
            'logged_at': e.createdAt.toUtc().toIso8601String(),
            'updated_at': e.updatedAt.toUtc().toIso8601String(),
            'deleted_at': e.deleted ? e.updatedAt.toUtc().toIso8601String() : null,
          },
        )
        .toList();
    await _db.from('diary_entries').upsert(payload, onConflict: 'user_id,client_id');
    await _clearDirtyDiary(pending);
  }

  Future<void> _clearDirtyDiary(List<DiaryEntry> pushed) {
    return _isar.writeTxn(() async {
      for (final e in pushed) {
        final fresh = await _isar.diaryEntries.get(e.id);
        if (fresh == null) continue;
        if (!fresh.updatedAt.isAtSameMomentAs(e.updatedAt)) continue;
        fresh.dirty = false;
        await _isar.diaryEntries.put(fresh);
      }
    });
  }

  Future<void> _pullDiary(String userId) async {
    final rows = await _fetchSince('diary_entries', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final clientId = row['client_id'] as String?;
        if (clientId == null) continue;
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing = await _isar.diaryEntries
            .filter()
            .clientIdEqualTo(clientId)
            .findFirst();
        if (existing != null && existing.updatedAt.toUtc().isAfter(remoteUpdated)) {
          continue;
        }
        final entry = existing ?? DiaryEntry();
        entry
          ..clientId = clientId
          ..dateKey = (row['date_key'] as num?)?.toInt() ?? 0
          ..meal = MealType.values.firstWhere(
            (m) => m.name == row['meal'],
            orElse: () => MealType.snack,
          )
          ..foodId = existing?.foodId ?? 0
          ..foodName = row['food_name'] as String? ?? ''
          ..brand = row['brand'] as String?
          ..source = FoodSource.values.firstWhere(
            (s) => s.name == row['source'],
            orElse: () => FoodSource.custom,
          )
          ..amountG = (row['amount_g'] as num?)?.toDouble() ?? 0
          ..servingLabel = row['serving_label'] as String?
          ..kcal = (row['kcal'] as num?)?.toDouble() ?? 0
          ..protein = (row['protein'] as num?)?.toDouble() ?? 0
          ..carbs = (row['carbs'] as num?)?.toDouble() ?? 0
          ..fat = (row['fat'] as num?)?.toDouble() ?? 0
          ..fiber = (row['fiber'] as num?)?.toDouble()
          ..sugars = (row['sugars'] as num?)?.toDouble()
          ..satFat = (row['sat_fat'] as num?)?.toDouble()
          ..salt = (row['salt'] as num?)?.toDouble()
          ..createdAt = DateTime.tryParse('${row['logged_at']}')?.toLocal() ??
              existing?.createdAt ??
              DateTime.now()
          ..updatedAt = remoteUpdated
          ..deleted = row['deleted_at'] != null
          ..dirty = false;
        await _isar.diaryEntries.put(entry);
      }
    });
    await _setCursor('diary_entries', userId, _newest(rows));
  }

  // ------------------------------------------------------------------ gewicht

  Future<void> _pushWeight(String userId) async {
    final pending =
        await _isar.weightEntries.filter().dirtyEqualTo(true).findAll();
    if (pending.isEmpty) return;
    await _db.from('weight_entries').upsert(
          pending
              .map(
                (w) => {
                  'user_id': userId,
                  'date_key': w.dateKey,
                  'kg': w.kg,
                  'updated_at': w.updatedAt.toUtc().toIso8601String(),
                  'deleted_at':
                      w.deleted ? w.updatedAt.toUtc().toIso8601String() : null,
                },
              )
              .toList(),
          onConflict: 'user_id,date_key',
        );
    await _isar.writeTxn(() async {
      for (final w in pending) {
        final fresh = await _isar.weightEntries.get(w.id);
        if (fresh == null) continue;
        if (!fresh.updatedAt.isAtSameMomentAs(w.updatedAt)) continue;
        fresh.dirty = false;
        await _isar.weightEntries.put(fresh);
      }
    });
  }

  Future<void> _pullWeight(String userId) async {
    final rows = await _fetchSince('weight_entries', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final dateKey = (row['date_key'] as num?)?.toInt();
        if (dateKey == null) continue;
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing = await _isar.weightEntries
            .filter()
            .dateKeyEqualTo(dateKey)
            .findFirst();
        if (existing != null && existing.updatedAt.toUtc().isAfter(remoteUpdated)) {
          continue;
        }
        final entry = existing ?? WeightEntry();
        entry
          ..dateKey = dateKey
          ..kg = (row['kg'] as num?)?.toDouble() ?? 0
          ..updatedAt = remoteUpdated
          ..deleted = row['deleted_at'] != null
          ..dirty = false;
        await _isar.weightEntries.put(entry);
      }
    });
    await _setCursor('weight_entries', userId, _newest(rows));
  }

  // -------------------------------------------------------------------- water

  Future<void> _pushWater(String userId) async {
    final pending =
        await _isar.waterEntries.filter().dirtyEqualTo(true).findAll();
    if (pending.isEmpty) return;
    await _db.from('water_entries').upsert(
          pending
              .map(
                (w) => {
                  'user_id': userId,
                  'date_key': w.dateKey,
                  'glasses': w.glasses,
                  'updated_at': w.updatedAt.toUtc().toIso8601String(),
                  'deleted_at':
                      w.deleted ? w.updatedAt.toUtc().toIso8601String() : null,
                },
              )
              .toList(),
          onConflict: 'user_id,date_key',
        );
    await _isar.writeTxn(() async {
      for (final w in pending) {
        final fresh = await _isar.waterEntries.get(w.id);
        if (fresh == null) continue;
        if (!fresh.updatedAt.isAtSameMomentAs(w.updatedAt)) continue;
        fresh.dirty = false;
        await _isar.waterEntries.put(fresh);
      }
    });
  }

  Future<void> _pullWater(String userId) async {
    final rows = await _fetchSince('water_entries', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final dateKey = (row['date_key'] as num?)?.toInt();
        if (dateKey == null) continue;
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing = await _isar.waterEntries
            .filter()
            .dateKeyEqualTo(dateKey)
            .findFirst();
        if (existing != null && existing.updatedAt.toUtc().isAfter(remoteUpdated)) {
          continue;
        }
        final entry = existing ?? WaterEntry();
        entry
          ..dateKey = dateKey
          ..glasses = (row['glasses'] as num?)?.toInt() ?? 0
          ..updatedAt = remoteUpdated
          ..deleted = row['deleted_at'] != null
          ..dirty = false;
        await _isar.waterEntries.put(entry);
      }
    });
    await _setCursor('water_entries', userId, _newest(rows));
  }

  // -------------------------------------------------------- eigen producten

  Future<void> _pushCustomFoods(String userId) async {
    final pending = await _isar.foods
        .filter()
        .sourceEqualTo(FoodSource.custom)
        .and()
        .dirtyEqualTo(true)
        .findAll();
    if (pending.isEmpty) return;
    var assigned = false;
    for (final f in pending) {
      if (f.clientId != null && f.clientId!.isNotEmpty) continue;
      f.clientId = newClientId();
      f.updatedAt ??= DateTime.now();
      assigned = true;
    }
    if (assigned) {
      await _isar.writeTxn(() => _isar.foods.putAll(pending));
    }
    await _db.from('custom_foods').upsert(
          pending
              .map(
                (f) => {
                  'user_id': userId,
                  'client_id': f.clientId,
                  'name': f.name,
                  'brand': f.brand,
                  'barcode': f.barcode,
                  'kcal_100g': f.kcal100g,
                  'protein_100g': f.protein100g,
                  'carbs_100g': f.carbs100g,
                  'fat_100g': f.fat100g,
                  'fiber_100g': f.fiber100g,
                  'sugars_100g': f.sugars100g,
                  'sat_fat_100g': f.satFat100g,
                  'salt_100g': f.salt100g,
                  'serving_g': f.servingG,
                  'serving_label': f.servingLabel,
                  'is_favorite': f.isFavorite,
                  'updated_at':
                      (f.updatedAt ?? DateTime.now()).toUtc().toIso8601String(),
                  'deleted_at': f.deleted
                      ? (f.updatedAt ?? DateTime.now()).toUtc().toIso8601String()
                      : null,
                },
              )
              .toList(),
          onConflict: 'user_id,client_id',
        );
    await _isar.writeTxn(() async {
      for (final f in pending) {
        final fresh = await _isar.foods.get(f.id);
        if (fresh == null) continue;
        final pushed = f.updatedAt;
        final current = fresh.updatedAt;
        if (pushed != null &&
            current != null &&
            current.isAfter(pushed)) {
          continue;
        }
        fresh.dirty = false;
        await _isar.foods.put(fresh);
      }
    });
  }

  Future<void> _pullCustomFoods(String userId) async {
    final rows = await _fetchSince('custom_foods', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final clientId = row['client_id'] as String?;
        if (clientId == null) continue;
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing =
            await _isar.foods.filter().clientIdEqualTo(clientId).findFirst();
        final localUpdated = existing?.updatedAt?.toUtc();
        if (localUpdated != null && localUpdated.isAfter(remoteUpdated)) continue;

        final food = existing ?? Food();
        final name = row['name'] as String? ?? '';
        food
          ..clientId = clientId
          ..source = FoodSource.custom
          ..kind = (row['brand'] != null || row['barcode'] != null)
              ? FoodKind.branded
              : FoodKind.generic
          ..name = name
          ..nameNormalized = normalizeName(name)
          ..brand = row['brand'] as String?
          ..barcode = row['barcode'] as String?
          ..kcal100g = (row['kcal_100g'] as num?)?.toDouble() ?? 0
          ..protein100g = (row['protein_100g'] as num?)?.toDouble() ?? 0
          ..carbs100g = (row['carbs_100g'] as num?)?.toDouble() ?? 0
          ..fat100g = (row['fat_100g'] as num?)?.toDouble() ?? 0
          ..fiber100g = (row['fiber_100g'] as num?)?.toDouble()
          ..sugars100g = (row['sugars_100g'] as num?)?.toDouble()
          ..satFat100g = (row['sat_fat_100g'] as num?)?.toDouble()
          ..salt100g = (row['salt_100g'] as num?)?.toDouble()
          ..servingG = (row['serving_g'] as num?)?.toDouble()
          ..servingLabel = row['serving_label'] as String?
          ..isFavorite = row['is_favorite'] as bool? ?? false
          ..updatedAt = remoteUpdated
          ..deleted = row['deleted_at'] != null
          ..dirty = false;
        await _isar.foods.put(food);
      }
    });
    await _setCursor('custom_foods', userId, _newest(rows));
  }

  // ----------------------------------------------------------------- recepten

  Future<void> _pushRecipes(String userId) async {
    final pending = await _isar.recipes.filter().dirtyEqualTo(true).findAll();
    if (pending.isEmpty) return;
    await _db.from('recipes').upsert(
          pending
              .map(
                (r) => {
                  'user_id': userId,
                  'client_id': r.clientId,
                  'name': r.name,
                  'portions': r.portions,
                  'items': r.items.map((i) => i.toJson()).toList(),
                  'updated_at': r.updatedAt.toUtc().toIso8601String(),
                  'deleted_at':
                      r.deleted ? r.updatedAt.toUtc().toIso8601String() : null,
                },
              )
              .toList(),
          onConflict: 'user_id,client_id',
        );
    await _isar.writeTxn(() async {
      for (final r in pending) {
        final fresh = await _isar.recipes.get(r.id);
        if (fresh == null) continue;
        if (!fresh.updatedAt.isAtSameMomentAs(r.updatedAt)) continue;
        fresh.dirty = false;
        await _isar.recipes.put(fresh);
      }
    });
  }

  Future<void> _pullRecipes(String userId) async {
    final rows = await _fetchSince('recipes', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final clientId = row['client_id'] as String?;
        if (clientId == null) continue;
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing =
            await _isar.recipes.filter().clientIdEqualTo(clientId).findFirst();
        if (existing != null && existing.updatedAt.toUtc().isAfter(remoteUpdated)) {
          continue;
        }
        final recipe = existing ?? Recipe();
        recipe
          ..clientId = clientId
          ..name = row['name'] as String? ?? ''
          ..portions = (row['portions'] as num?)?.toInt() ?? 1
          ..items = (row['items'] as List? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(RecipeItem.fromJson)
              .toList()
          ..updatedAt = remoteUpdated
          ..deleted = row['deleted_at'] != null
          ..dirty = false;
        await _isar.recipes.put(recipe);
      }
    });
    await _setCursor('recipes', userId, _newest(rows));
  }

  // ------------------------------------------------------------ herinneringen

  Future<void> _pushReminders(String userId) async {
    final pending = await _isar.reminders.filter().dirtyEqualTo(true).findAll();
    if (pending.isEmpty) return;
    await _db.from('reminders').upsert(
          pending
              .map(
                (r) => {
                  'user_id': userId,
                  'meal': r.kind.key,
                  'hour': r.hour,
                  'minute': r.minute,
                  'enabled': r.enabled,
                  'weekday': r.weekday,
                  'updated_at': r.updatedAt.toUtc().toIso8601String(),
                },
              )
              .toList(),
          onConflict: 'user_id,meal',
        );
    await _isar.writeTxn(() async {
      for (final r in pending) {
        final fresh = await _isar.reminders.get(r.id);
        if (fresh == null) continue;
        if (!fresh.updatedAt.isAtSameMomentAs(r.updatedAt)) continue;
        fresh.dirty = false;
        await _isar.reminders.put(fresh);
      }
    });
  }

  Future<void> _pullReminders(String userId) async {
    final rows = await _fetchSince('reminders', userId);
    if (rows.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final row in rows) {
        final key = row['meal'] as String?;
        if (key == null) continue;
        final kind = ReminderKindKey.fromKey(key);
        final remoteUpdated =
            DateTime.tryParse('${row['updated_at']}')?.toUtc() ?? DateTime.now();
        final existing =
            await _isar.reminders.filter().kindEqualTo(kind).findFirst();
        if (existing != null && existing.updatedAt.toUtc().isAfter(remoteUpdated)) {
          continue;
        }
        final reminder = existing ?? Reminder();
        reminder
          ..kind = kind
          ..hour = (row['hour'] as num?)?.toInt() ?? 8
          ..minute = (row['minute'] as num?)?.toInt() ?? 0
          ..enabled = row['enabled'] as bool? ?? false
          ..weekday = (row['weekday'] as num?)?.toInt() ?? DateTime.monday
          ..updatedAt = remoteUpdated
          ..dirty = false;
        await _isar.reminders.put(reminder);
      }
    });
    await _setCursor('reminders', userId, _newest(rows));
  }
}
