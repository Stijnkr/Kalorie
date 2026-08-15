import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('nl'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In nl, this message translates to:
  /// **'Kalorie'**
  String get appName;

  /// No description provided for @tabToday.
  ///
  /// In nl, this message translates to:
  /// **'Vandaag'**
  String get tabToday;

  /// No description provided for @tabHistory.
  ///
  /// In nl, this message translates to:
  /// **'Geschiedenis'**
  String get tabHistory;

  /// No description provided for @tabMore.
  ///
  /// In nl, this message translates to:
  /// **'Meer'**
  String get tabMore;

  /// No description provided for @add.
  ///
  /// In nl, this message translates to:
  /// **'Toevoegen'**
  String get add;

  /// No description provided for @save.
  ///
  /// In nl, this message translates to:
  /// **'Opslaan'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderen'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In nl, this message translates to:
  /// **'Bewerken'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In nl, this message translates to:
  /// **'Zoeken'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoek een product'**
  String get searchHint;

  /// No description provided for @scanBarcode.
  ///
  /// In nl, this message translates to:
  /// **'Barcode scannen'**
  String get scanBarcode;

  /// No description provided for @newProduct.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw product'**
  String get newProduct;

  /// No description provided for @recents.
  ///
  /// In nl, this message translates to:
  /// **'Recent'**
  String get recents;

  /// No description provided for @favorites.
  ///
  /// In nl, this message translates to:
  /// **'Favorieten'**
  String get favorites;

  /// No description provided for @allFoods.
  ///
  /// In nl, this message translates to:
  /// **'Alles'**
  String get allFoods;

  /// No description provided for @searchOnline.
  ///
  /// In nl, this message translates to:
  /// **'Zoek online'**
  String get searchOnline;

  /// No description provided for @searchingOnline.
  ///
  /// In nl, this message translates to:
  /// **'Online zoeken…'**
  String get searchingOnline;

  /// No description provided for @noResults.
  ///
  /// In nl, this message translates to:
  /// **'Geen producten gevonden'**
  String get noResults;

  /// No description provided for @noResultsHint.
  ///
  /// In nl, this message translates to:
  /// **'Voeg zelf een product toe of zoek online.'**
  String get noResultsHint;

  /// No description provided for @offline.
  ///
  /// In nl, this message translates to:
  /// **'Je bent offline. Alleen lokale producten.'**
  String get offline;

  /// No description provided for @kcal.
  ///
  /// In nl, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @protein.
  ///
  /// In nl, this message translates to:
  /// **'Eiwit'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In nl, this message translates to:
  /// **'Koolhydraten'**
  String get carbs;

  /// No description provided for @carbsMid.
  ///
  /// In nl, this message translates to:
  /// **'Koolh.'**
  String get carbsMid;

  /// No description provided for @fat.
  ///
  /// In nl, this message translates to:
  /// **'Vet'**
  String get fat;

  /// No description provided for @gram.
  ///
  /// In nl, this message translates to:
  /// **'g'**
  String get gram;

  /// No description provided for @per100g.
  ///
  /// In nl, this message translates to:
  /// **'per 100 g'**
  String get per100g;

  /// No description provided for @amount.
  ///
  /// In nl, this message translates to:
  /// **'Hoeveelheid'**
  String get amount;

  /// No description provided for @meal.
  ///
  /// In nl, this message translates to:
  /// **'Maaltijd'**
  String get meal;

  /// No description provided for @breakfast.
  ///
  /// In nl, this message translates to:
  /// **'Ontbijt'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In nl, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In nl, this message translates to:
  /// **'Diner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In nl, this message translates to:
  /// **'Snacks'**
  String get snack;

  /// No description provided for @addToMeal.
  ///
  /// In nl, this message translates to:
  /// **'Toevoegen aan {meal}'**
  String addToMeal(String meal);

  /// No description provided for @todayEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Nog niets gelogd'**
  String get todayEmpty;

  /// No description provided for @todayEmptyHint.
  ///
  /// In nl, this message translates to:
  /// **'Voeg je eerste product toe.'**
  String get todayEmptyHint;

  /// No description provided for @addToSection.
  ///
  /// In nl, this message translates to:
  /// **'Toevoegen'**
  String get addToSection;

  /// No description provided for @onboardingTitle.
  ///
  /// In nl, this message translates to:
  /// **'Stel je doelen in'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Je kunt dit later altijd aanpassen. Geen account nodig.'**
  String get onboardingSubtitle;

  /// No description provided for @kcalGoal.
  ///
  /// In nl, this message translates to:
  /// **'Calorieën per dag'**
  String get kcalGoal;

  /// No description provided for @start.
  ///
  /// In nl, this message translates to:
  /// **'Aan de slag'**
  String get start;

  /// No description provided for @goals.
  ///
  /// In nl, this message translates to:
  /// **'Doelen'**
  String get goals;

  /// No description provided for @goalsSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Dagelijkse richtwaarden'**
  String get goalsSubtitle;

  /// No description provided for @weight.
  ///
  /// In nl, this message translates to:
  /// **'Gewicht'**
  String get weight;

  /// No description provided for @weightSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Optioneel, alleen op dit apparaat'**
  String get weightSubtitle;

  /// No description provided for @addWeight.
  ///
  /// In nl, this message translates to:
  /// **'Gewicht loggen'**
  String get addWeight;

  /// No description provided for @kg.
  ///
  /// In nl, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @noWeight.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen gewicht gelogd'**
  String get noWeight;

  /// No description provided for @settings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In nl, this message translates to:
  /// **'Weergave'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In nl, this message translates to:
  /// **'Systeem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In nl, this message translates to:
  /// **'Licht'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In nl, this message translates to:
  /// **'Donker'**
  String get themeDark;

  /// No description provided for @data.
  ///
  /// In nl, this message translates to:
  /// **'Gegevens'**
  String get data;

  /// No description provided for @exportData.
  ///
  /// In nl, this message translates to:
  /// **'Exporteer gegevens'**
  String get exportData;

  /// No description provided for @exportDone.
  ///
  /// In nl, this message translates to:
  /// **'Export klaar'**
  String get exportDone;

  /// No description provided for @privacyTitle.
  ///
  /// In nl, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In nl, this message translates to:
  /// **'Alles staat op dit apparaat. Geen account, geen tracking, geen reclame.'**
  String get privacyBody;

  /// No description provided for @about.
  ///
  /// In nl, this message translates to:
  /// **'Over'**
  String get about;

  /// No description provided for @sources.
  ///
  /// In nl, this message translates to:
  /// **'Bronnen'**
  String get sources;

  /// No description provided for @nevoAttribution.
  ///
  /// In nl, this message translates to:
  /// **'Based on data from NEVO online version 2025/9.0, RIVM, Bilthoven and other data sources.'**
  String get nevoAttribution;

  /// No description provided for @offAttribution.
  ///
  /// In nl, this message translates to:
  /// **'Merkproducten via Open Food Facts (ODbL).'**
  String get offAttribution;

  /// No description provided for @version.
  ///
  /// In nl, this message translates to:
  /// **'Versie {version}'**
  String version(String version);

  /// No description provided for @name.
  ///
  /// In nl, this message translates to:
  /// **'Naam'**
  String get name;

  /// No description provided for @brand.
  ///
  /// In nl, this message translates to:
  /// **'Merk'**
  String get brand;

  /// No description provided for @barcode.
  ///
  /// In nl, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @serving.
  ///
  /// In nl, this message translates to:
  /// **'Portie'**
  String get serving;

  /// No description provided for @servingOptional.
  ///
  /// In nl, this message translates to:
  /// **'Portie (optioneel, gram)'**
  String get servingOptional;

  /// No description provided for @foodNameHint.
  ///
  /// In nl, this message translates to:
  /// **'Bijv. havermout'**
  String get foodNameHint;

  /// No description provided for @incompleteProduct.
  ///
  /// In nl, this message translates to:
  /// **'Onvolledige voedingswaarden. Vul ze zelf aan.'**
  String get incompleteProduct;

  /// No description provided for @productNotFound.
  ///
  /// In nl, this message translates to:
  /// **'Product niet gevonden'**
  String get productNotFound;

  /// No description provided for @productNotFoundHint.
  ///
  /// In nl, this message translates to:
  /// **'Voeg het zelf toe. De barcode is al ingevuld.'**
  String get productNotFoundHint;

  /// No description provided for @scanHint.
  ///
  /// In nl, this message translates to:
  /// **'Richt de camera op de barcode'**
  String get scanHint;

  /// No description provided for @enterBarcode.
  ///
  /// In nl, this message translates to:
  /// **'Of vul een barcode in'**
  String get enterBarcode;

  /// No description provided for @favorite.
  ///
  /// In nl, this message translates to:
  /// **'Favoriet'**
  String get favorite;

  /// No description provided for @sourceOff.
  ///
  /// In nl, this message translates to:
  /// **'OFF'**
  String get sourceOff;

  /// No description provided for @sourceNevo.
  ///
  /// In nl, this message translates to:
  /// **'NEVO'**
  String get sourceNevo;

  /// No description provided for @sourceCustom.
  ///
  /// In nl, this message translates to:
  /// **'Eigen'**
  String get sourceCustom;

  /// No description provided for @overGoal.
  ///
  /// In nl, this message translates to:
  /// **'boven doel'**
  String get overGoal;

  /// No description provided for @remaining.
  ///
  /// In nl, this message translates to:
  /// **'resterend'**
  String get remaining;

  /// No description provided for @ofGoal.
  ///
  /// In nl, this message translates to:
  /// **'van {goal} kcal'**
  String ofGoal(int goal);

  /// No description provided for @historyEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen dagen gelogd'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In nl, this message translates to:
  /// **'Log een paar dagen om je week te zien.'**
  String get historyEmptyHint;

  /// No description provided for @thisWeek.
  ///
  /// In nl, this message translates to:
  /// **'Deze week'**
  String get thisWeek;

  /// No description provided for @month.
  ///
  /// In nl, this message translates to:
  /// **'Maand'**
  String get month;

  /// No description provided for @today.
  ///
  /// In nl, this message translates to:
  /// **'Vandaag'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In nl, this message translates to:
  /// **'Gisteren'**
  String get yesterday;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderen?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryBody.
  ///
  /// In nl, this message translates to:
  /// **'{name} wordt uit deze dag gehaald.'**
  String deleteEntryBody(String name);

  /// No description provided for @copied.
  ///
  /// In nl, this message translates to:
  /// **'Aangepast'**
  String get copied;

  /// No description provided for @rateLimited.
  ///
  /// In nl, this message translates to:
  /// **'Even wachten — te veel online-zoekopdrachten.'**
  String get rateLimited;

  /// No description provided for @networkError.
  ///
  /// In nl, this message translates to:
  /// **'Kon online niet zoeken.'**
  String get networkError;

  /// No description provided for @more.
  ///
  /// In nl, this message translates to:
  /// **'Meer'**
  String get more;

  /// No description provided for @moreSection.
  ///
  /// In nl, this message translates to:
  /// **'App'**
  String get moreSection;

  /// No description provided for @customFood.
  ///
  /// In nl, this message translates to:
  /// **'Eigen product'**
  String get customFood;

  /// No description provided for @kcalShort.
  ///
  /// In nl, this message translates to:
  /// **'kcal'**
  String get kcalShort;

  /// No description provided for @proteinShort.
  ///
  /// In nl, this message translates to:
  /// **'E'**
  String get proteinShort;

  /// No description provided for @carbsShort.
  ///
  /// In nl, this message translates to:
  /// **'K'**
  String get carbsShort;

  /// No description provided for @fatShort.
  ///
  /// In nl, this message translates to:
  /// **'V'**
  String get fatShort;

  /// No description provided for @saveProduct.
  ///
  /// In nl, this message translates to:
  /// **'Product opslaan'**
  String get saveProduct;

  /// No description provided for @log.
  ///
  /// In nl, this message translates to:
  /// **'Loggen'**
  String get log;

  /// No description provided for @portie.
  ///
  /// In nl, this message translates to:
  /// **'1 portie'**
  String get portie;

  /// No description provided for @cameraDenied.
  ///
  /// In nl, this message translates to:
  /// **'Camera-toegang is nodig om te scannen.'**
  String get cameraDenied;

  /// No description provided for @openSettings.
  ///
  /// In nl, this message translates to:
  /// **'Open instellingen'**
  String get openSettings;

  /// No description provided for @unitPortion.
  ///
  /// In nl, this message translates to:
  /// **'Portie'**
  String get unitPortion;

  /// No description provided for @unitGrams.
  ///
  /// In nl, this message translates to:
  /// **'Gram'**
  String get unitGrams;

  /// No description provided for @portions.
  ///
  /// In nl, this message translates to:
  /// **'Aantal'**
  String get portions;

  /// No description provided for @defineServing.
  ///
  /// In nl, this message translates to:
  /// **'Stel een portie in'**
  String get defineServing;

  /// No description provided for @editServing.
  ///
  /// In nl, this message translates to:
  /// **'Portie aanpassen'**
  String get editServing;

  /// No description provided for @servingName.
  ///
  /// In nl, this message translates to:
  /// **'Wat is één portie?'**
  String get servingName;

  /// No description provided for @servingGrams.
  ///
  /// In nl, this message translates to:
  /// **'Hoeveel gram is dat?'**
  String get servingGrams;

  /// No description provided for @servingSheetHint.
  ///
  /// In nl, this message translates to:
  /// **'Bijv. 1 snee brood = 35 g. Daarna log je in sneeën.'**
  String get servingSheetHint;

  /// No description provided for @fixFood.
  ///
  /// In nl, this message translates to:
  /// **'Kloppen de waarden niet?'**
  String get fixFood;

  /// No description provided for @fixFoodHint.
  ///
  /// In nl, this message translates to:
  /// **'Pas naam, portie of voedingswaarden aan. Alleen voor jou, op dit apparaat.'**
  String get fixFoodHint;

  /// No description provided for @editDoesNotRewrite.
  ///
  /// In nl, this message translates to:
  /// **'Eerder gelogde dagen blijven hetzelfde. Nieuwe logs gebruiken de nieuwe waarden.'**
  String get editDoesNotRewrite;

  /// No description provided for @per100gHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoals op het etiket: calorieën en macro’s per 100 gram.'**
  String get per100gHint;

  /// No description provided for @editAmount.
  ///
  /// In nl, this message translates to:
  /// **'Hoeveelheid aanpassen'**
  String get editAmount;

  /// No description provided for @undo.
  ///
  /// In nl, this message translates to:
  /// **'Ongedaan'**
  String get undo;

  /// No description provided for @loggedSnack.
  ///
  /// In nl, this message translates to:
  /// **'{name} · {amount}'**
  String loggedSnack(String name, String amount);

  /// No description provided for @adjust.
  ///
  /// In nl, this message translates to:
  /// **'Aanpassen'**
  String get adjust;

  /// No description provided for @servingEquals.
  ///
  /// In nl, this message translates to:
  /// **'1 portie = {grams} g'**
  String servingEquals(int grams);

  /// No description provided for @logKcal.
  ///
  /// In nl, this message translates to:
  /// **'Log {kcal} kcal'**
  String logKcal(int kcal);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
