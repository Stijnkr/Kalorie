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
  /// **'Maak het product zelf aan, of scan de barcode.'**
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
  /// **'Privacybeleid'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In nl, this message translates to:
  /// **'Je account is nodig om Kalorie te gebruiken. Het logboek staat op dit toestel en wordt gesynchroniseerd met je account. Geen tracking, geen reclame.'**
  String get privacyBody;

  /// No description provided for @privacySub.
  ///
  /// In nl, this message translates to:
  /// **'wat we bewaren en hoe je het wist'**
  String get privacySub;

  /// No description provided for @termsTitle.
  ///
  /// In nl, this message translates to:
  /// **'Voorwaarden'**
  String get termsTitle;

  /// No description provided for @termsSub.
  ///
  /// In nl, this message translates to:
  /// **'gebruik van de app, geen medisch advies'**
  String get termsSub;

  /// No description provided for @legalDisclaimer.
  ///
  /// In nl, this message translates to:
  /// **'Kalorie is geen medisch advies en geen dieetbehandeling. Raadpleeg een arts bij vragen over voeding of gewicht.'**
  String get legalDisclaimer;

  /// No description provided for @supportContact.
  ///
  /// In nl, this message translates to:
  /// **'Vragen of een verzoek over je gegevens: {email}'**
  String supportContact(String email);

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

  /// No description provided for @kcalOver.
  ///
  /// In nl, this message translates to:
  /// **'kcal over'**
  String get kcalOver;

  /// No description provided for @eatenOfGoal.
  ///
  /// In nl, this message translates to:
  /// **'{eaten} van {goal} kcal gegeten'**
  String eatenOfGoal(int eaten, int goal);

  /// No description provided for @showAll.
  ///
  /// In nl, this message translates to:
  /// **'Alles zien'**
  String get showAll;

  /// No description provided for @showLess.
  ///
  /// In nl, this message translates to:
  /// **'Minder'**
  String get showLess;

  /// No description provided for @fiber.
  ///
  /// In nl, this message translates to:
  /// **'Vezels'**
  String get fiber;

  /// No description provided for @sugars.
  ///
  /// In nl, this message translates to:
  /// **'Waarvan suikers'**
  String get sugars;

  /// No description provided for @satFat.
  ///
  /// In nl, this message translates to:
  /// **'Waarvan verzadigd'**
  String get satFat;

  /// No description provided for @salt.
  ///
  /// In nl, this message translates to:
  /// **'Zout'**
  String get salt;

  /// No description provided for @sugarsLower.
  ///
  /// In nl, this message translates to:
  /// **'waarvan suikers'**
  String get sugarsLower;

  /// No description provided for @satFatLower.
  ///
  /// In nl, this message translates to:
  /// **'waarvan verzadigd'**
  String get satFatLower;

  /// No description provided for @water.
  ///
  /// In nl, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @waterProgress.
  ///
  /// In nl, this message translates to:
  /// **'{amount} L van {goal} L'**
  String waterProgress(String amount, String goal);

  /// No description provided for @waterHint.
  ///
  /// In nl, this message translates to:
  /// **'Eén glas is 250 ml · tik om bij te vullen'**
  String get waterHint;

  /// No description provided for @waterDone.
  ///
  /// In nl, this message translates to:
  /// **'Doel gehaald. Tik een glas om te corrigeren.'**
  String get waterDone;

  /// No description provided for @calendar.
  ///
  /// In nl, this message translates to:
  /// **'Kalender'**
  String get calendar;

  /// No description provided for @toToday.
  ///
  /// In nl, this message translates to:
  /// **'Naar vandaag'**
  String get toToday;

  /// No description provided for @previousDay.
  ///
  /// In nl, this message translates to:
  /// **'Vorige dag'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In nl, this message translates to:
  /// **'Volgende dag'**
  String get nextDay;

  /// No description provided for @previousWeek.
  ///
  /// In nl, this message translates to:
  /// **'Vorige week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In nl, this message translates to:
  /// **'Volgende week'**
  String get nextWeek;

  /// No description provided for @logInMeal.
  ///
  /// In nl, this message translates to:
  /// **'Loggen in {meal}'**
  String logInMeal(String meal);

  /// No description provided for @quickAddHint.
  ///
  /// In nl, this message translates to:
  /// **'tik + om direct te boeken'**
  String get quickAddHint;

  /// No description provided for @searchDatabase.
  ///
  /// In nl, this message translates to:
  /// **'Zoeken in database'**
  String get searchDatabase;

  /// No description provided for @createNewProduct.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw product aanmaken'**
  String get createNewProduct;

  /// No description provided for @nothingFound.
  ///
  /// In nl, this message translates to:
  /// **'Niets gevonden'**
  String get nothingFound;

  /// No description provided for @nothingFoundHint.
  ///
  /// In nl, this message translates to:
  /// **'Maak het product zelf aan, of scan de barcode.'**
  String get nothingFoundHint;

  /// No description provided for @editPortion.
  ///
  /// In nl, this message translates to:
  /// **'Portie wijzigen'**
  String get editPortion;

  /// No description provided for @inGrams.
  ///
  /// In nl, this message translates to:
  /// **'in gram'**
  String get inGrams;

  /// No description provided for @gramsUnit.
  ///
  /// In nl, this message translates to:
  /// **'gram'**
  String get gramsUnit;

  /// No description provided for @portionTotal.
  ///
  /// In nl, this message translates to:
  /// **'1 {label} = {grams} g · totaal {total} g'**
  String portionTotal(String label, int grams, int total);

  /// No description provided for @per100Short.
  ///
  /// In nl, this message translates to:
  /// **'{value} /100g'**
  String per100Short(String value);

  /// No description provided for @weekAverage.
  ///
  /// In nl, this message translates to:
  /// **'kcal gemiddeld · doel {goal}'**
  String weekAverage(int goal);

  /// No description provided for @weekLoggedDays.
  ///
  /// In nl, this message translates to:
  /// **'{logged} van {total} dagen gelogd'**
  String weekLoggedDays(int logged, int total);

  /// No description provided for @nothingLoggedTap.
  ///
  /// In nl, this message translates to:
  /// **'niets gelogd — tik om aan te vullen'**
  String get nothingLoggedTap;

  /// No description provided for @notYetHappened.
  ///
  /// In nl, this message translates to:
  /// **'nog niet geweest'**
  String get notYetHappened;

  /// No description provided for @goalsIntro.
  ///
  /// In nl, this message translates to:
  /// **'Je macro’s tellen op tot je kcal-doel. Pas het doel aan, de rest schuift mee.'**
  String get goalsIntro;

  /// No description provided for @dayGoal.
  ///
  /// In nl, this message translates to:
  /// **'Dagdoel'**
  String get dayGoal;

  /// No description provided for @kcalPerDay.
  ///
  /// In nl, this message translates to:
  /// **'kcal per dag'**
  String get kcalPerDay;

  /// No description provided for @goalsMoreSub.
  ///
  /// In nl, this message translates to:
  /// **'kcal en macro-verdeling'**
  String get goalsMoreSub;

  /// No description provided for @weightMoreSub.
  ///
  /// In nl, this message translates to:
  /// **'wekelijks bijhouden'**
  String get weightMoreSub;

  /// No description provided for @ownProducts.
  ///
  /// In nl, this message translates to:
  /// **'Eigen producten'**
  String get ownProducts;

  /// No description provided for @ownProductsSub.
  ///
  /// In nl, this message translates to:
  /// **'zelf ingevoerde voedingswaarden'**
  String get ownProductsSub;

  /// No description provided for @settingsMoreSub.
  ///
  /// In nl, this message translates to:
  /// **'thema, weergave, export'**
  String get settingsMoreSub;

  /// No description provided for @restartOnboarding.
  ///
  /// In nl, this message translates to:
  /// **'Onboarding opnieuw'**
  String get restartOnboarding;

  /// No description provided for @restartOnboardingSub.
  ///
  /// In nl, this message translates to:
  /// **'bekijk de eerste keer'**
  String get restartOnboardingSub;

  /// No description provided for @moreFootnote.
  ///
  /// In nl, this message translates to:
  /// **'Voedingswaarden uit NEVO 2025 en Open Food Facts. Logboek staat op je telefoon en, als je bent ingelogd, op je account.'**
  String get moreFootnote;

  /// No description provided for @weightDeltaIn30.
  ///
  /// In nl, this message translates to:
  /// **'kg · {delta} in 30 dagen'**
  String weightDeltaIn30(String delta);

  /// No description provided for @logWeightToday.
  ///
  /// In nl, this message translates to:
  /// **'Weeg vandaag: {kg} kg'**
  String logWeightToday(String kg);

  /// No description provided for @measurements.
  ///
  /// In nl, this message translates to:
  /// **'Metingen'**
  String get measurements;

  /// No description provided for @displaySection.
  ///
  /// In nl, this message translates to:
  /// **'Weergave'**
  String get displaySection;

  /// No description provided for @dataSection.
  ///
  /// In nl, this message translates to:
  /// **'Gegevens'**
  String get dataSection;

  /// No description provided for @exportDataSub.
  ///
  /// In nl, this message translates to:
  /// **'alles als JSON, blijft op je telefoon'**
  String get exportDataSub;

  /// No description provided for @stepOf.
  ///
  /// In nl, this message translates to:
  /// **'Stap {step} van {total}'**
  String stepOf(int step, int total);

  /// No description provided for @obGoalTitle.
  ///
  /// In nl, this message translates to:
  /// **'Waar wil je naartoe?'**
  String get obGoalTitle;

  /// No description provided for @obGoalBody.
  ///
  /// In nl, this message translates to:
  /// **'Kalorie rekent je dagdoel uit en houdt het daarna simpel: één cijfer op het startscherm, de rest eronder.'**
  String get obGoalBody;

  /// No description provided for @obLose.
  ///
  /// In nl, this message translates to:
  /// **'Afvallen'**
  String get obLose;

  /// No description provided for @obMaintain.
  ///
  /// In nl, this message translates to:
  /// **'Op gewicht blijven'**
  String get obMaintain;

  /// No description provided for @obGain.
  ///
  /// In nl, this message translates to:
  /// **'Aankomen'**
  String get obGain;

  /// No description provided for @obPaceTitle.
  ///
  /// In nl, this message translates to:
  /// **'Hoe snel?'**
  String get obPaceTitle;

  /// No description provided for @obPaceBody.
  ///
  /// In nl, this message translates to:
  /// **'Dit bepaalt je dagdoel. Je kunt het later in Doelen aanpassen zonder alles opnieuw in te vullen.'**
  String get obPaceBody;

  /// No description provided for @obPaceCalm.
  ///
  /// In nl, this message translates to:
  /// **'Rustig · 0,25 kg/week'**
  String get obPaceCalm;

  /// No description provided for @obPaceNormal.
  ///
  /// In nl, this message translates to:
  /// **'Normaal · 0,5 kg/week'**
  String get obPaceNormal;

  /// No description provided for @obPaceFast.
  ///
  /// In nl, this message translates to:
  /// **'Snel · 0,75 kg/week'**
  String get obPaceFast;

  /// No description provided for @obDoneTitle.
  ///
  /// In nl, this message translates to:
  /// **'Klaar. Loggen kost één tik.'**
  String get obDoneTitle;

  /// No description provided for @obDoneBody.
  ///
  /// In nl, this message translates to:
  /// **'Je recente producten staan bovenaan het logvel met de portie die je vorige keer koos. Tik de plus en het staat erin.'**
  String get obDoneBody;

  /// No description provided for @obFootnote.
  ///
  /// In nl, this message translates to:
  /// **'Je account bewaart je logboek. Geen tracking, geen reclame.'**
  String get obFootnote;

  /// No description provided for @next.
  ///
  /// In nl, this message translates to:
  /// **'Verder'**
  String get next;

  /// No description provided for @begin.
  ///
  /// In nl, this message translates to:
  /// **'Beginnen'**
  String get begin;

  /// No description provided for @deleted.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderd'**
  String get deleted;

  /// No description provided for @removeEntry.
  ///
  /// In nl, this message translates to:
  /// **'Regel verwijderen'**
  String get removeEntry;

  /// No description provided for @scanSimulateHint.
  ///
  /// In nl, this message translates to:
  /// **'Houd de barcode in het kader. Het product gaat meteen het logboek in, met de portie die je de vorige keer koos.'**
  String get scanSimulateHint;

  /// No description provided for @account.
  ///
  /// In nl, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSignedOut.
  ///
  /// In nl, this message translates to:
  /// **'Geen account'**
  String get accountSignedOut;

  /// No description provided for @accountSignedOutSub.
  ///
  /// In nl, this message translates to:
  /// **'log in om je logboek veilig te stellen'**
  String get accountSignedOutSub;

  /// No description provided for @accountSince.
  ///
  /// In nl, this message translates to:
  /// **'{email} · sinds {since}'**
  String accountSince(String email, String since);

  /// No description provided for @signIn.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderen wist je account en alle logboeken van de server. Een export blijft op je telefoon staan.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In nl, this message translates to:
  /// **'Weet je het zeker? Dit kan niet ongedaan worden gemaakt.'**
  String get deleteAccountConfirm;

  /// No description provided for @authWelcomeBack.
  ///
  /// In nl, this message translates to:
  /// **'Welkom terug'**
  String get authWelcomeBack;

  /// No description provided for @authCreateAccount.
  ///
  /// In nl, this message translates to:
  /// **'Maak je account'**
  String get authCreateAccount;

  /// No description provided for @authSignInBody.
  ///
  /// In nl, this message translates to:
  /// **'Log in en je logboek, doelen en gewicht worden van de server gehaald.'**
  String get authSignInBody;

  /// No description provided for @authSignUpBody.
  ///
  /// In nl, this message translates to:
  /// **'Met een account staat je logboek veilig en komt het terug op elk toestel waarop je inlogt.'**
  String get authSignUpBody;

  /// No description provided for @email.
  ///
  /// In nl, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In nl, this message translates to:
  /// **'Naam'**
  String get displayName;

  /// No description provided for @emailPlaceholder.
  ///
  /// In nl, this message translates to:
  /// **'jij@voorbeeld.nl'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In nl, this message translates to:
  /// **'minimaal 10 tekens'**
  String get passwordPlaceholder;

  /// No description provided for @namePlaceholder.
  ///
  /// In nl, this message translates to:
  /// **'hoe mogen we je noemen?'**
  String get namePlaceholder;

  /// No description provided for @authLegal.
  ///
  /// In nl, this message translates to:
  /// **'Door verder te gaan ga je akkoord met de voorwaarden en het privacybeleid.'**
  String get authLegal;

  /// No description provided for @forgotPassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord vergeten?'**
  String get forgotPassword;

  /// No description provided for @resetSent.
  ///
  /// In nl, this message translates to:
  /// **'Check je mail voor een link om je wachtwoord te herstellen.'**
  String get resetSent;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In nl, this message translates to:
  /// **'E-mail of wachtwoord klopt niet.'**
  String get errInvalidCredentials;

  /// No description provided for @errEmailTaken.
  ///
  /// In nl, this message translates to:
  /// **'Er bestaat al een account met dit e-mailadres.'**
  String get errEmailTaken;

  /// No description provided for @errWeakPassword.
  ///
  /// In nl, this message translates to:
  /// **'Kies een wachtwoord van minimaal 10 tekens. Niet je e-mail, en niet hetzelfde teken achter elkaar.'**
  String get errWeakPassword;

  /// No description provided for @errLeakedPassword.
  ///
  /// In nl, this message translates to:
  /// **'Dit wachtwoord staat in een bekend datalek. Kies een ander, het liefst uit een wachtwoordmanager.'**
  String get errLeakedPassword;

  /// No description provided for @errInvalidEmail.
  ///
  /// In nl, this message translates to:
  /// **'Dat lijkt geen geldig e-mailadres.'**
  String get errInvalidEmail;

  /// No description provided for @errNeedsConfirmation.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig je e-mailadres via de link die we net stuurden.'**
  String get errNeedsConfirmation;

  /// No description provided for @errNetwork.
  ///
  /// In nl, this message translates to:
  /// **'Geen verbinding. Probeer het zo nog eens.'**
  String get errNetwork;

  /// No description provided for @errRateLimited.
  ///
  /// In nl, this message translates to:
  /// **'Te veel mails achter elkaar. Wacht een paar minuten en probeer het opnieuw, of log in als het account al bestaat.'**
  String get errRateLimited;

  /// No description provided for @errUnknown.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken lukte niet. Probeer het zo nog eens.'**
  String get errUnknown;

  /// No description provided for @errCloudUnavailable.
  ///
  /// In nl, this message translates to:
  /// **'Geen verbinding met de server. Probeer het zo nog eens.'**
  String get errCloudUnavailable;

  /// No description provided for @syncSection.
  ///
  /// In nl, this message translates to:
  /// **'Synchronisatie'**
  String get syncSection;

  /// No description provided for @syncDiary.
  ///
  /// In nl, this message translates to:
  /// **'Logboek synchroniseren'**
  String get syncDiary;

  /// No description provided for @syncDiarySub.
  ///
  /// In nl, this message translates to:
  /// **'maaltijden en water op al je toestellen'**
  String get syncDiarySub;

  /// No description provided for @syncWeight.
  ///
  /// In nl, this message translates to:
  /// **'Gewicht synchroniseren'**
  String get syncWeight;

  /// No description provided for @syncWeightSub.
  ///
  /// In nl, this message translates to:
  /// **'metingen en verloop'**
  String get syncWeightSub;

  /// No description provided for @syncNow.
  ///
  /// In nl, this message translates to:
  /// **'Nu synchroniseren'**
  String get syncNow;

  /// No description provided for @syncRunning.
  ///
  /// In nl, this message translates to:
  /// **'Bezig met synchroniseren…'**
  String get syncRunning;

  /// No description provided for @syncDone.
  ///
  /// In nl, this message translates to:
  /// **'Bijgewerkt om {time}'**
  String syncDone(String time);

  /// No description provided for @syncNever.
  ///
  /// In nl, this message translates to:
  /// **'Nog niet gesynchroniseerd'**
  String get syncNever;

  /// No description provided for @syncOffline.
  ///
  /// In nl, this message translates to:
  /// **'Offline — het wacht tot je weer verbinding hebt.'**
  String get syncOffline;

  /// No description provided for @syncFailed.
  ///
  /// In nl, this message translates to:
  /// **'Synchroniseren lukte niet.'**
  String get syncFailed;

  /// No description provided for @securitySection.
  ///
  /// In nl, this message translates to:
  /// **'Beveiliging en data'**
  String get securitySection;

  /// No description provided for @changePassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord wijzigen'**
  String get changePassword;

  /// No description provided for @changePasswordSub.
  ///
  /// In nl, this message translates to:
  /// **'we sturen je een link per mail'**
  String get changePasswordSub;

  /// No description provided for @obAccountTitleUp.
  ///
  /// In nl, this message translates to:
  /// **'Maak je account'**
  String get obAccountTitleUp;

  /// No description provided for @obAccountTitleIn.
  ///
  /// In nl, this message translates to:
  /// **'Welkom terug'**
  String get obAccountTitleIn;

  /// No description provided for @skipForNow.
  ///
  /// In nl, this message translates to:
  /// **'Zonder account verder'**
  String get skipForNow;

  /// No description provided for @skipForNowSub.
  ///
  /// In nl, this message translates to:
  /// **'alles blijft dan alleen op dit toestel'**
  String get skipForNowSub;

  /// No description provided for @recipes.
  ///
  /// In nl, this message translates to:
  /// **'Mijn recepten'**
  String get recipes;

  /// No description provided for @recipesSub.
  ///
  /// In nl, this message translates to:
  /// **'vaste combinaties in één tik'**
  String get recipesSub;

  /// No description provided for @recipesIntro.
  ///
  /// In nl, this message translates to:
  /// **'Een recept is een vaste combinatie die je in één tik logt. Tik de plus om een portie te boeken, tik de naam om hem aan te passen.'**
  String get recipesIntro;

  /// No description provided for @newRecipe.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw recept'**
  String get newRecipe;

  /// No description provided for @editRecipe.
  ///
  /// In nl, this message translates to:
  /// **'Recept aanpassen'**
  String get editRecipe;

  /// No description provided for @recipeName.
  ///
  /// In nl, this message translates to:
  /// **'Naam'**
  String get recipeName;

  /// No description provided for @recipeNameHint.
  ///
  /// In nl, this message translates to:
  /// **'bijv. Kwark met banaan'**
  String get recipeNameHint;

  /// No description provided for @recipePortions.
  ///
  /// In nl, this message translates to:
  /// **'Aantal porties'**
  String get recipePortions;

  /// No description provided for @recipePortionsSub.
  ///
  /// In nl, this message translates to:
  /// **'bepaalt wat één portie kost'**
  String get recipePortionsSub;

  /// No description provided for @ingredients.
  ///
  /// In nl, this message translates to:
  /// **'Ingrediënten'**
  String get ingredients;

  /// No description provided for @recipeEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen ingrediënten. Kies hieronder een product.'**
  String get recipeEmpty;

  /// No description provided for @addIngredient.
  ///
  /// In nl, this message translates to:
  /// **'Toevoegen'**
  String get addIngredient;

  /// No description provided for @saveRecipe.
  ///
  /// In nl, this message translates to:
  /// **'Recept opslaan'**
  String get saveRecipe;

  /// No description provided for @recipeTotal.
  ///
  /// In nl, this message translates to:
  /// **'Totaal {kcal} kcal · één portie {perPortion} kcal'**
  String recipeTotal(int kcal, int perPortion);

  /// No description provided for @recipePerPortion.
  ///
  /// In nl, this message translates to:
  /// **'{kcal} kcal per portie · {grams} g'**
  String recipePerPortion(int kcal, int grams);

  /// No description provided for @deleteRecipe.
  ///
  /// In nl, this message translates to:
  /// **'Recept verwijderen'**
  String get deleteRecipe;

  /// No description provided for @deleteRecipeConfirm.
  ///
  /// In nl, this message translates to:
  /// **'Dit recept verdwijnt uit je lijst. Gelogde porties blijven in je dagboek.'**
  String get deleteRecipeConfirm;

  /// No description provided for @deleteProduct.
  ///
  /// In nl, this message translates to:
  /// **'Product verwijderen'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In nl, this message translates to:
  /// **'{name} verdwijnt uit je eigen producten. Gelogde dagen blijven staan.'**
  String deleteProductConfirm(String name);

  /// No description provided for @reminders.
  ///
  /// In nl, this message translates to:
  /// **'Herinneringen'**
  String get reminders;

  /// No description provided for @remindersSub.
  ///
  /// In nl, this message translates to:
  /// **'melding als je iets niet logt'**
  String get remindersSub;

  /// No description provided for @remindersIntro.
  ///
  /// In nl, this message translates to:
  /// **'Alleen een zetje als je iets niet gelogd hebt. Heb je de maaltijd al gelogd, dan komt de melding niet.'**
  String get remindersIntro;

  /// No description provided for @remindersFootnote.
  ///
  /// In nl, this message translates to:
  /// **'Tik op de tijd om hem te verschuiven. Meldingen werken alleen als je ze op je telefoon hebt toegestaan.'**
  String get remindersFootnote;

  /// No description provided for @remindersEnabledCount.
  ///
  /// In nl, this message translates to:
  /// **'{count} aan'**
  String remindersEnabledCount(int count);

  /// No description provided for @reminderWeighIn.
  ///
  /// In nl, this message translates to:
  /// **'Wegen'**
  String get reminderWeighIn;

  /// No description provided for @reminderBreakfastSub.
  ///
  /// In nl, this message translates to:
  /// **'als het ontbijt nog leeg is'**
  String get reminderBreakfastSub;

  /// No description provided for @reminderLunchSub.
  ///
  /// In nl, this message translates to:
  /// **'als de lunch nog leeg is'**
  String get reminderLunchSub;

  /// No description provided for @reminderDinnerSub.
  ///
  /// In nl, this message translates to:
  /// **'als het diner nog leeg is'**
  String get reminderDinnerSub;

  /// No description provided for @reminderSnackSub.
  ///
  /// In nl, this message translates to:
  /// **'als de dag nog niet rond is'**
  String get reminderSnackSub;

  /// No description provided for @reminderWeighInSub.
  ///
  /// In nl, this message translates to:
  /// **'wekelijks op je weegmoment'**
  String get reminderWeighInSub;

  /// No description provided for @reminderBody.
  ///
  /// In nl, this message translates to:
  /// **'Nog niets gelogd voor {meal}.'**
  String reminderBody(String meal);

  /// No description provided for @reminderWeighBody.
  ///
  /// In nl, this message translates to:
  /// **'Even op de weegschaal?'**
  String get reminderWeighBody;

  /// No description provided for @notificationsDenied.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen staan uit. Zet ze aan bij Instellingen › Kalorie.'**
  String get notificationsDenied;

  /// No description provided for @accountSwitchTitle.
  ///
  /// In nl, this message translates to:
  /// **'Ander account'**
  String get accountSwitchTitle;

  /// No description provided for @accountSwitchBody.
  ///
  /// In nl, this message translates to:
  /// **'Op dit toestel staan gegevens van een ander account. Wisselen haalt het logboek van dit account op en vervangt wat hier staat. Het andere account blijft in de cloud.'**
  String get accountSwitchBody;

  /// No description provided for @accountSwitchConfirm.
  ///
  /// In nl, this message translates to:
  /// **'Wisselen'**
  String get accountSwitchConfirm;

  /// No description provided for @signOutStaysLocal.
  ///
  /// In nl, this message translates to:
  /// **'Je logboek blijft op dit toestel. Log opnieuw in om te synchroniseren.'**
  String get signOutStaysLocal;

  /// No description provided for @recoverTitle.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw wachtwoord'**
  String get recoverTitle;

  /// No description provided for @recoverBody.
  ///
  /// In nl, this message translates to:
  /// **'Kies een wachtwoord van minimaal 10 tekens. Daarna kun je weer inloggen op al je toestellen.'**
  String get recoverBody;

  /// No description provided for @newPassword.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw wachtwoord'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig wachtwoord'**
  String get confirmPassword;

  /// No description provided for @savePassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord opslaan'**
  String get savePassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In nl, this message translates to:
  /// **'Je wachtwoord is gewijzigd.'**
  String get passwordUpdated;

  /// No description provided for @errPasswordMismatch.
  ///
  /// In nl, this message translates to:
  /// **'Die twee wachtwoorden zijn niet hetzelfde.'**
  String get errPasswordMismatch;

  /// No description provided for @recipeListEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen recepten. Maak er een en je logt hem in één tik.'**
  String get recipeListEmpty;

  /// No description provided for @ownProductsIntro.
  ///
  /// In nl, this message translates to:
  /// **'Producten die je zelf hebt ingevoerd. Tik erop om ze aan te passen.'**
  String get ownProductsIntro;

  /// No description provided for @newOwnProduct.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw product'**
  String get newOwnProduct;

  /// No description provided for @ownProductsEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen eigen producten.'**
  String get ownProductsEmpty;

  /// No description provided for @moreSectionDay.
  ///
  /// In nl, this message translates to:
  /// **'Dag'**
  String get moreSectionDay;

  /// No description provided for @moreSectionFood.
  ///
  /// In nl, this message translates to:
  /// **'Voeding'**
  String get moreSectionFood;

  /// No description provided for @moreSectionApp.
  ///
  /// In nl, this message translates to:
  /// **'App'**
  String get moreSectionApp;

  /// No description provided for @obFootnoteSignedIn.
  ///
  /// In nl, this message translates to:
  /// **'Je doelen staan op dit toestel en gaan mee naar de cloud.'**
  String get obFootnoteSignedIn;

  /// No description provided for @weekdayMonday.
  ///
  /// In nl, this message translates to:
  /// **'ma'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In nl, this message translates to:
  /// **'di'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In nl, this message translates to:
  /// **'wo'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In nl, this message translates to:
  /// **'do'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In nl, this message translates to:
  /// **'vr'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In nl, this message translates to:
  /// **'za'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In nl, this message translates to:
  /// **'zo'**
  String get weekdaySunday;

  /// No description provided for @feedback.
  ///
  /// In nl, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackSub.
  ///
  /// In nl, this message translates to:
  /// **'een idee, een fout, of iets dat wringt'**
  String get feedbackSub;

  /// No description provided for @feedbackIntro.
  ///
  /// In nl, this message translates to:
  /// **'Ik lees alles. Hoe korter hoe beter, maar schrijf gerust wat je nodig hebt. Versie en toestel gaan automatisch mee.'**
  String get feedbackIntro;

  /// No description provided for @feedbackIdea.
  ///
  /// In nl, this message translates to:
  /// **'Idee'**
  String get feedbackIdea;

  /// No description provided for @feedbackProblem.
  ///
  /// In nl, this message translates to:
  /// **'Probleem'**
  String get feedbackProblem;

  /// No description provided for @feedbackOther.
  ///
  /// In nl, this message translates to:
  /// **'Anders'**
  String get feedbackOther;

  /// No description provided for @feedbackHint.
  ///
  /// In nl, this message translates to:
  /// **'Wat zou Kalorie beter maken?'**
  String get feedbackHint;

  /// No description provided for @feedbackSend.
  ///
  /// In nl, this message translates to:
  /// **'Versturen'**
  String get feedbackSend;

  /// No description provided for @feedbackSent.
  ///
  /// In nl, this message translates to:
  /// **'Binnen. Dank je.'**
  String get feedbackSent;

  /// No description provided for @feedbackFailed.
  ///
  /// In nl, this message translates to:
  /// **'Kon het niet versturen. Check je verbinding en probeer het zo nog eens.'**
  String get feedbackFailed;

  /// No description provided for @updates.
  ///
  /// In nl, this message translates to:
  /// **'Wat is nieuw'**
  String get updates;

  /// No description provided for @updatesSub.
  ///
  /// In nl, this message translates to:
  /// **'wat er in de app is veranderd'**
  String get updatesSub;

  /// No description provided for @updatesIntro.
  ///
  /// In nl, this message translates to:
  /// **'Elke versie komt hier te staan. Na een update zie je de punten meteen.'**
  String get updatesIntro;

  /// No description provided for @updatesAll.
  ///
  /// In nl, this message translates to:
  /// **'Alle versies'**
  String get updatesAll;

  /// No description provided for @whatsNewVersion.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw in {version}'**
  String whatsNewVersion(String version);

  /// No description provided for @whatsNewIntro.
  ///
  /// In nl, this message translates to:
  /// **'Kort wat er anders is sinds je hier voor het laatst was.'**
  String get whatsNewIntro;

  /// No description provided for @whatsNewOk.
  ///
  /// In nl, this message translates to:
  /// **'Oké'**
  String get whatsNewOk;

  /// No description provided for @newBadge.
  ///
  /// In nl, this message translates to:
  /// **'nieuw'**
  String get newBadge;

  /// No description provided for @appLock.
  ///
  /// In nl, this message translates to:
  /// **'Vergrendelen'**
  String get appLock;

  /// No description provided for @appLockSub.
  ///
  /// In nl, this message translates to:
  /// **'Face ID of toegangscode als je terugkomt'**
  String get appLockSub;

  /// No description provided for @appLockReason.
  ///
  /// In nl, this message translates to:
  /// **'Ontgrendel Kalorie om je logboek te zien.'**
  String get appLockReason;

  /// No description provided for @appLockBody.
  ///
  /// In nl, this message translates to:
  /// **'Je logboek is vergrendeld.'**
  String get appLockBody;

  /// No description provided for @appLockUnlock.
  ///
  /// In nl, this message translates to:
  /// **'Ontgrendelen'**
  String get appLockUnlock;

  /// No description provided for @appLockUnavailable.
  ///
  /// In nl, this message translates to:
  /// **'Dit toestel heeft geen Face ID of toegangscode, of je hebt geannuleerd.'**
  String get appLockUnavailable;
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
