// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Kalorie';

  @override
  String get tabToday => 'Vandaag';

  @override
  String get tabHistory => 'Geschiedenis';

  @override
  String get tabMore => 'Meer';

  @override
  String get add => 'Toevoegen';

  @override
  String get save => 'Opslaan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get edit => 'Bewerken';

  @override
  String get search => 'Zoeken';

  @override
  String get searchHint => 'Zoek een product';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get newProduct => 'Nieuw product';

  @override
  String get recents => 'Recent';

  @override
  String get favorites => 'Favorieten';

  @override
  String get allFoods => 'Alles';

  @override
  String get searchOnline => 'Zoek online';

  @override
  String get searchingOnline => 'Online zoeken…';

  @override
  String get noResults => 'Geen producten gevonden';

  @override
  String get noResultsHint => 'Voeg zelf een product toe of zoek online.';

  @override
  String get offline => 'Je bent offline. Alleen lokale producten.';

  @override
  String get kcal => 'kcal';

  @override
  String get protein => 'Eiwit';

  @override
  String get carbs => 'Koolhydraten';

  @override
  String get carbsMid => 'Koolh.';

  @override
  String get fat => 'Vet';

  @override
  String get gram => 'g';

  @override
  String get per100g => 'per 100 g';

  @override
  String get amount => 'Hoeveelheid';

  @override
  String get meal => 'Maaltijd';

  @override
  String get breakfast => 'Ontbijt';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Diner';

  @override
  String get snack => 'Snacks';

  @override
  String addToMeal(String meal) {
    return 'Toevoegen aan $meal';
  }

  @override
  String get todayEmpty => 'Nog niets gelogd';

  @override
  String get todayEmptyHint => 'Voeg je eerste product toe.';

  @override
  String get addToSection => 'Toevoegen';

  @override
  String get onboardingTitle => 'Stel je doelen in';

  @override
  String get onboardingSubtitle =>
      'Je kunt dit later altijd aanpassen. Geen account nodig.';

  @override
  String get kcalGoal => 'Calorieën per dag';

  @override
  String get start => 'Aan de slag';

  @override
  String get goals => 'Doelen';

  @override
  String get goalsSubtitle => 'Dagelijkse richtwaarden';

  @override
  String get weight => 'Gewicht';

  @override
  String get weightSubtitle => 'Optioneel, alleen op dit apparaat';

  @override
  String get addWeight => 'Gewicht loggen';

  @override
  String get kg => 'kg';

  @override
  String get noWeight => 'Nog geen gewicht gelogd';

  @override
  String get settings => 'Instellingen';

  @override
  String get appearance => 'Weergave';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get data => 'Gegevens';

  @override
  String get exportData => 'Exporteer gegevens';

  @override
  String get exportDone => 'Export klaar';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'Alles staat op dit apparaat. Geen account, geen tracking, geen reclame.';

  @override
  String get about => 'Over';

  @override
  String get sources => 'Bronnen';

  @override
  String get nevoAttribution =>
      'Based on data from NEVO online version 2025/9.0, RIVM, Bilthoven and other data sources.';

  @override
  String get offAttribution => 'Merkproducten via Open Food Facts (ODbL).';

  @override
  String version(String version) {
    return 'Versie $version';
  }

  @override
  String get name => 'Naam';

  @override
  String get brand => 'Merk';

  @override
  String get barcode => 'Barcode';

  @override
  String get serving => 'Portie';

  @override
  String get servingOptional => 'Portie (optioneel, gram)';

  @override
  String get foodNameHint => 'Bijv. havermout';

  @override
  String get incompleteProduct =>
      'Onvolledige voedingswaarden. Vul ze zelf aan.';

  @override
  String get productNotFound => 'Product niet gevonden';

  @override
  String get productNotFoundHint =>
      'Voeg het zelf toe. De barcode is al ingevuld.';

  @override
  String get scanHint => 'Richt de camera op de barcode';

  @override
  String get enterBarcode => 'Of vul een barcode in';

  @override
  String get favorite => 'Favoriet';

  @override
  String get sourceOff => 'OFF';

  @override
  String get sourceNevo => 'NEVO';

  @override
  String get sourceCustom => 'Eigen';

  @override
  String get overGoal => 'boven doel';

  @override
  String get remaining => 'resterend';

  @override
  String ofGoal(int goal) {
    return 'van $goal kcal';
  }

  @override
  String get historyEmpty => 'Nog geen dagen gelogd';

  @override
  String get historyEmptyHint => 'Log een paar dagen om je week te zien.';

  @override
  String get thisWeek => 'Deze week';

  @override
  String get month => 'Maand';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get deleteEntryTitle => 'Verwijderen?';

  @override
  String deleteEntryBody(String name) {
    return '$name wordt uit deze dag gehaald.';
  }

  @override
  String get copied => 'Aangepast';

  @override
  String get rateLimited => 'Even wachten — te veel online-zoekopdrachten.';

  @override
  String get networkError => 'Kon online niet zoeken.';

  @override
  String get more => 'Meer';

  @override
  String get moreSection => 'App';

  @override
  String get customFood => 'Eigen product';

  @override
  String get kcalShort => 'kcal';

  @override
  String get proteinShort => 'E';

  @override
  String get carbsShort => 'K';

  @override
  String get fatShort => 'V';

  @override
  String get saveProduct => 'Product opslaan';

  @override
  String get log => 'Loggen';

  @override
  String get portie => '1 portie';

  @override
  String get cameraDenied => 'Camera-toegang is nodig om te scannen.';

  @override
  String get openSettings => 'Open instellingen';

  @override
  String get unitPortion => 'Portie';

  @override
  String get unitGrams => 'Gram';

  @override
  String get portions => 'Aantal';

  @override
  String get defineServing => 'Stel een portie in';

  @override
  String get editServing => 'Portie aanpassen';

  @override
  String get servingName => 'Wat is één portie?';

  @override
  String get servingGrams => 'Hoeveel gram is dat?';

  @override
  String get servingSheetHint =>
      'Bijv. 1 snee brood = 35 g. Daarna log je in sneeën.';

  @override
  String get fixFood => 'Kloppen de waarden niet?';

  @override
  String get fixFoodHint =>
      'Pas naam, portie of voedingswaarden aan. Alleen voor jou, op dit apparaat.';

  @override
  String get editDoesNotRewrite =>
      'Eerder gelogde dagen blijven hetzelfde. Nieuwe logs gebruiken de nieuwe waarden.';

  @override
  String get per100gHint =>
      'Zoals op het etiket: calorieën en macro’s per 100 gram.';

  @override
  String get editAmount => 'Hoeveelheid aanpassen';

  @override
  String get undo => 'Ongedaan';

  @override
  String loggedSnack(String name, String amount) {
    return '$name · $amount';
  }

  @override
  String get adjust => 'Aanpassen';

  @override
  String servingEquals(int grams) {
    return '1 portie = $grams g';
  }

  @override
  String logKcal(int kcal) {
    return 'Log $kcal kcal';
  }

  @override
  String get kcalOver => 'kcal over';

  @override
  String eatenOfGoal(int eaten, int goal) {
    return '$eaten van $goal kcal gegeten';
  }

  @override
  String get showAll => 'Alles zien';

  @override
  String get showLess => 'Minder';

  @override
  String get fiber => 'Vezels';

  @override
  String get sugars => 'Waarvan suikers';

  @override
  String get satFat => 'Waarvan verzadigd';

  @override
  String get salt => 'Zout';

  @override
  String get sugarsLower => 'waarvan suikers';

  @override
  String get satFatLower => 'waarvan verzadigd';

  @override
  String get water => 'Water';

  @override
  String waterProgress(String amount, String goal) {
    return '$amount L van $goal L';
  }

  @override
  String get waterHint => 'Eén glas is 250 ml · tik om bij te vullen';

  @override
  String get waterDone => 'Doel gehaald. Tik een glas om te corrigeren.';

  @override
  String get calendar => 'Kalender';

  @override
  String get toToday => 'Naar vandaag';

  @override
  String get previousDay => 'Vorige dag';

  @override
  String get nextDay => 'Volgende dag';

  @override
  String get previousWeek => 'Vorige week';

  @override
  String get nextWeek => 'Volgende week';

  @override
  String logInMeal(String meal) {
    return 'Loggen in $meal';
  }

  @override
  String get quickAddHint => 'tik + om direct te boeken';

  @override
  String get searchDatabase => 'Zoeken in database';

  @override
  String get createNewProduct => 'Nieuw product aanmaken';

  @override
  String get nothingFound => 'Niets gevonden';

  @override
  String get nothingFoundHint => 'Zoek online of maak het product zelf aan.';

  @override
  String get editPortion => 'Portie wijzigen';

  @override
  String get inGrams => 'in gram';

  @override
  String get gramsUnit => 'gram';

  @override
  String portionTotal(String label, int grams, int total) {
    return '1 $label = $grams g · totaal $total g';
  }

  @override
  String per100Short(String value) {
    return '$value /100g';
  }

  @override
  String weekAverage(int goal) {
    return 'kcal gemiddeld · doel $goal';
  }

  @override
  String weekLoggedDays(int logged, int total) {
    return '$logged van $total dagen gelogd';
  }

  @override
  String get nothingLoggedTap => 'niets gelogd — tik om aan te vullen';

  @override
  String get notYetHappened => 'nog niet geweest';

  @override
  String get goalsIntro =>
      'Je macro’s tellen op tot je kcal-doel. Pas het doel aan, de rest schuift mee.';

  @override
  String get dayGoal => 'Dagdoel';

  @override
  String get kcalPerDay => 'kcal per dag';

  @override
  String get goalsMoreSub => 'kcal en macro-verdeling';

  @override
  String get weightMoreSub => 'wekelijks bijhouden';

  @override
  String get ownProducts => 'Eigen producten';

  @override
  String get ownProductsSub => 'zelf ingevoerde voedingswaarden';

  @override
  String get settingsMoreSub => 'thema, weergave, export';

  @override
  String get restartOnboarding => 'Onboarding opnieuw';

  @override
  String get restartOnboardingSub => 'bekijk de eerste keer';

  @override
  String get moreFootnote =>
      'Voedingswaarden uit NEVO 2025 en Open Food Facts. Alles staat op je telefoon; export via Instellingen.';

  @override
  String weightDeltaIn30(String delta) {
    return 'kg · $delta in 30 dagen';
  }

  @override
  String logWeightToday(String kg) {
    return 'Weeg vandaag: $kg kg';
  }

  @override
  String get measurements => 'Metingen';

  @override
  String get displaySection => 'Weergave';

  @override
  String get dataSection => 'Gegevens';

  @override
  String get exportDataSub => 'alles als JSON, blijft op je telefoon';

  @override
  String stepOf(int step, int total) {
    return 'Stap $step van $total';
  }

  @override
  String get obGoalTitle => 'Waar wil je naartoe?';

  @override
  String get obGoalBody =>
      'Kalorie rekent je dagdoel uit en houdt het daarna simpel: één cijfer op het startscherm, de rest eronder.';

  @override
  String get obLose => 'Afvallen';

  @override
  String get obMaintain => 'Op gewicht blijven';

  @override
  String get obGain => 'Aankomen';

  @override
  String get obPaceTitle => 'Hoe snel?';

  @override
  String get obPaceBody =>
      'Dit bepaalt je dagdoel. Je kunt het later in Doelen aanpassen zonder alles opnieuw in te vullen.';

  @override
  String get obPaceCalm => 'Rustig · 0,25 kg/week';

  @override
  String get obPaceNormal => 'Normaal · 0,5 kg/week';

  @override
  String get obPaceFast => 'Snel · 0,75 kg/week';

  @override
  String get obDoneTitle => 'Klaar. Loggen kost één tik.';

  @override
  String get obDoneBody =>
      'Je recente producten staan bovenaan het logvel met de portie die je vorige keer koos. Tik de plus en het staat erin.';

  @override
  String get obFootnote =>
      'Alles blijft op je telefoon. Geen account, geen tracking.';

  @override
  String get next => 'Verder';

  @override
  String get begin => 'Beginnen';

  @override
  String get deleted => 'Verwijderd';

  @override
  String get removeEntry => 'Regel verwijderen';

  @override
  String get scanSimulateHint =>
      'Houd de barcode in het kader. Gevonden producten worden direct geopend met de laatst gebruikte portie.';
}
