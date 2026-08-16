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
  String get noResultsHint => 'Maak het product zelf aan, of scan de barcode.';

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
  String get cm => 'cm';

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
  String get privacyTitle => 'Privacybeleid';

  @override
  String get privacyBody =>
      'Je account is nodig om Kalorie te gebruiken. Het logboek staat op dit toestel en wordt gesynchroniseerd met je account. Geen tracking, geen reclame.';

  @override
  String get privacySub => 'wat we bewaren en hoe je het wist';

  @override
  String get termsTitle => 'Voorwaarden';

  @override
  String get termsSub => 'gebruik van de app, geen medisch advies';

  @override
  String get legalDisclaimer =>
      'Kalorie is geen medisch advies en geen dieetbehandeling. Raadpleeg een arts bij vragen over voeding of gewicht.';

  @override
  String supportContact(String email) {
    return 'Vragen of een verzoek over je gegevens: $email';
  }

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
  String get nothingFoundHint =>
      'Maak het product zelf aan, of scan de barcode.';

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
      'Voedingswaarden uit NEVO 2025 en Open Food Facts. Logboek staat op je telefoon en, als je bent ingelogd, op je account.';

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
      'Richting en tempo bepalen de schatting. Het getal zelf stel je daarna nog bij.';

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
  String get obBodyTitle => 'Over jou';

  @override
  String get obBodyBody =>
      'Leeftijd, lengte en gewicht. Alleen om een startgetal te rekenen, niets wordt met een weegschaal gedeeld.';

  @override
  String get obSexFemale => 'Vrouw';

  @override
  String get obSexMale => 'Man';

  @override
  String get obAge => 'Leeftijd';

  @override
  String get obYears => 'jaar';

  @override
  String get obHeight => 'Lengte';

  @override
  String get obWeight => 'Gewicht';

  @override
  String get obMoveTitle => 'Hoe beweeg je?';

  @override
  String get obMoveBody =>
      'Geen sport telt ook. Kies wat het dichtst bij een gewone week komt.';

  @override
  String get obMoveNone => 'Weinig beweging';

  @override
  String get obMoveNoneSub => 'zittend werk, bijna geen sport';

  @override
  String get obMoveLight => 'Licht actief';

  @override
  String get obMoveLightSub => 'wandelen, fietsen, 1–2 keer sporten';

  @override
  String get obMoveSport => 'Regelmatig sport';

  @override
  String get obMoveSportSub => '3–5 keer per week een training';

  @override
  String get obMoveMuch => 'Veel sport';

  @override
  String get obMoveMuchSub => 'bijna elke dag, of een zwaar beroep';

  @override
  String get obDoneTitle => 'Je dagdoel';

  @override
  String get obDoneBody =>
      'Dit is een schatting. Zet het op een getal dat je volhoudt. Later pas je het in Doelen bij.';

  @override
  String get obAdjustHint =>
      'Plus en min in stappen van 50. De schatting blijft ernaast staan.';

  @override
  String obEstimateLine(int target, int maintain) {
    return 'Schatting $target · onderhoud $maintain';
  }

  @override
  String get obFootnote =>
      'Je account bewaart je logboek. Geen tracking, geen reclame.';

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
      'Houd de barcode in het kader. Het product gaat meteen het logboek in, met de portie die je de vorige keer koos.';

  @override
  String get account => 'Account';

  @override
  String get accountSignedOut => 'Geen account';

  @override
  String get accountSignedOutSub => 'log in om je logboek veilig te stellen';

  @override
  String accountSince(String email, String since) {
    return '$email · sinds $since';
  }

  @override
  String get signIn => 'Inloggen';

  @override
  String get signUp => 'Account aanmaken';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountBody =>
      'Verwijderen wist je account en alle logboeken van de server. Een export blijft op je telefoon staan.';

  @override
  String get deleteAccountConfirm =>
      'Weet je het zeker? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get authWelcomeBack => 'Welkom terug';

  @override
  String get authCreateAccount => 'Maak je account';

  @override
  String get authSignInBody =>
      'Log in en je logboek, doelen en gewicht worden van de server gehaald.';

  @override
  String get authSignUpBody =>
      'Met een account staat je logboek veilig en komt het terug op elk toestel waarop je inlogt.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get displayName => 'Naam';

  @override
  String get emailPlaceholder => 'jij@voorbeeld.nl';

  @override
  String get passwordPlaceholder => 'minimaal 10 tekens';

  @override
  String get namePlaceholder => 'hoe mogen we je noemen?';

  @override
  String get authLegal =>
      'Door verder te gaan ga je akkoord met de voorwaarden en het privacybeleid.';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get resetSent =>
      'Check je mail voor een link om je wachtwoord te herstellen.';

  @override
  String get errInvalidCredentials => 'E-mail of wachtwoord klopt niet.';

  @override
  String get errEmailTaken => 'Er bestaat al een account met dit e-mailadres.';

  @override
  String get errWeakPassword =>
      'Kies een wachtwoord van minimaal 10 tekens. Niet je e-mail, en niet hetzelfde teken achter elkaar.';

  @override
  String get errLeakedPassword =>
      'Dit wachtwoord staat in een bekend datalek. Kies een ander, het liefst uit een wachtwoordmanager.';

  @override
  String get errInvalidEmail => 'Dat lijkt geen geldig e-mailadres.';

  @override
  String get errNeedsConfirmation =>
      'Bevestig je e-mailadres via de link die we net stuurden.';

  @override
  String get errNetwork => 'Geen verbinding. Probeer het zo nog eens.';

  @override
  String get errRateLimited =>
      'Te veel mails achter elkaar. Wacht een paar minuten en probeer het opnieuw, of log in als het account al bestaat.';

  @override
  String get errUnknown =>
      'Account aanmaken lukte niet. Probeer het zo nog eens.';

  @override
  String get errCloudUnavailable =>
      'Geen verbinding met de server. Probeer het zo nog eens.';

  @override
  String get syncSection => 'Synchronisatie';

  @override
  String get syncDiary => 'Logboek synchroniseren';

  @override
  String get syncDiarySub => 'maaltijden en water op al je toestellen';

  @override
  String get syncWeight => 'Gewicht synchroniseren';

  @override
  String get syncWeightSub => 'metingen en verloop';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get syncRunning => 'Bezig met synchroniseren…';

  @override
  String syncDone(String time) {
    return 'Bijgewerkt om $time';
  }

  @override
  String get syncNever => 'Nog niet gesynchroniseerd';

  @override
  String get syncOffline => 'Offline — het wacht tot je weer verbinding hebt.';

  @override
  String get syncFailed => 'Synchroniseren lukte niet.';

  @override
  String get securitySection => 'Beveiliging en data';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get changePasswordSub => 'we sturen je een link per mail';

  @override
  String get obAccountTitleUp => 'Maak je account';

  @override
  String get obAccountTitleIn => 'Welkom terug';

  @override
  String get skipForNow => 'Zonder account verder';

  @override
  String get skipForNowSub => 'alles blijft dan alleen op dit toestel';

  @override
  String get recipes => 'Mijn recepten';

  @override
  String get recipesSub => 'vaste combinaties in één tik';

  @override
  String get recipesIntro =>
      'Een recept is een vaste combinatie die je in één tik logt. Tik de plus om een portie te boeken, tik de naam om hem aan te passen.';

  @override
  String get newRecipe => 'Nieuw recept';

  @override
  String get editRecipe => 'Recept aanpassen';

  @override
  String get recipeName => 'Naam';

  @override
  String get recipeNameHint => 'bijv. Kwark met banaan';

  @override
  String get recipePortions => 'Aantal porties';

  @override
  String get recipePortionsSub => 'bepaalt wat één portie kost';

  @override
  String get ingredients => 'Ingrediënten';

  @override
  String get recipeEmpty =>
      'Nog geen ingrediënten. Kies hieronder een product.';

  @override
  String get addIngredient => 'Toevoegen';

  @override
  String get saveRecipe => 'Recept opslaan';

  @override
  String recipeTotal(int kcal, int perPortion) {
    return 'Totaal $kcal kcal · één portie $perPortion kcal';
  }

  @override
  String recipePerPortion(int kcal, int grams) {
    return '$kcal kcal per portie · $grams g';
  }

  @override
  String get deleteRecipe => 'Recept verwijderen';

  @override
  String get deleteRecipeConfirm =>
      'Dit recept verdwijnt uit je lijst. Gelogde porties blijven in je dagboek.';

  @override
  String get deleteProduct => 'Product verwijderen';

  @override
  String deleteProductConfirm(String name) {
    return '$name verdwijnt uit je eigen producten. Gelogde dagen blijven staan.';
  }

  @override
  String get reminders => 'Herinneringen';

  @override
  String get remindersSub => 'melding als je iets niet logt';

  @override
  String get remindersIntro =>
      'Alleen een zetje als je iets niet gelogd hebt. Heb je de maaltijd al gelogd, dan komt de melding niet.';

  @override
  String get remindersFootnote =>
      'Tik op de tijd om hem te verschuiven. Meldingen werken alleen als je ze op je telefoon hebt toegestaan.';

  @override
  String remindersEnabledCount(int count) {
    return '$count aan';
  }

  @override
  String get reminderWeighIn => 'Wegen';

  @override
  String get reminderBreakfastSub => 'als het ontbijt nog leeg is';

  @override
  String get reminderLunchSub => 'als de lunch nog leeg is';

  @override
  String get reminderDinnerSub => 'als het diner nog leeg is';

  @override
  String get reminderSnackSub => 'als de dag nog niet rond is';

  @override
  String get reminderWeighInSub => 'wekelijks op je weegmoment';

  @override
  String reminderBody(String meal) {
    return 'Nog niets gelogd voor $meal.';
  }

  @override
  String get reminderWeighBody => 'Even op de weegschaal?';

  @override
  String get notificationsDenied =>
      'Meldingen staan uit. Zet ze aan bij Instellingen › Kalorie.';

  @override
  String get accountSwitchTitle => 'Ander account';

  @override
  String get accountSwitchBody =>
      'Op dit toestel staan gegevens van een ander account. Wisselen haalt het logboek van dit account op en vervangt wat hier staat. Het andere account blijft in de cloud.';

  @override
  String get accountSwitchConfirm => 'Wisselen';

  @override
  String get signOutStaysLocal =>
      'Je logboek blijft op dit toestel. Log opnieuw in om te synchroniseren.';

  @override
  String get recoverTitle => 'Nieuw wachtwoord';

  @override
  String get recoverBody =>
      'Kies een wachtwoord van minimaal 10 tekens. Daarna kun je weer inloggen op al je toestellen.';

  @override
  String get newPassword => 'Nieuw wachtwoord';

  @override
  String get confirmPassword => 'Bevestig wachtwoord';

  @override
  String get savePassword => 'Wachtwoord opslaan';

  @override
  String get passwordUpdated => 'Je wachtwoord is gewijzigd.';

  @override
  String get errPasswordMismatch =>
      'Die twee wachtwoorden zijn niet hetzelfde.';

  @override
  String get recipeListEmpty =>
      'Nog geen recepten. Maak er een en je logt hem in één tik.';

  @override
  String get ownProductsIntro =>
      'Producten die je zelf hebt ingevoerd. Tik erop om ze aan te passen.';

  @override
  String get newOwnProduct => 'Nieuw product';

  @override
  String get ownProductsEmpty => 'Nog geen eigen producten.';

  @override
  String get moreSectionDay => 'Dag';

  @override
  String get moreSectionFood => 'Voeding';

  @override
  String get moreSectionApp => 'App';

  @override
  String get obFootnoteSignedIn =>
      'Je doelen staan op dit toestel en gaan mee naar de cloud.';

  @override
  String get weekdayMonday => 'ma';

  @override
  String get weekdayTuesday => 'di';

  @override
  String get weekdayWednesday => 'wo';

  @override
  String get weekdayThursday => 'do';

  @override
  String get weekdayFriday => 'vr';

  @override
  String get weekdaySaturday => 'za';

  @override
  String get weekdaySunday => 'zo';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackSub => 'een idee, een fout, of iets dat wringt';

  @override
  String get feedbackIntro =>
      'Ik lees alles. Hoe korter hoe beter, maar schrijf gerust wat je nodig hebt. Versie en toestel gaan automatisch mee.';

  @override
  String get feedbackIdea => 'Idee';

  @override
  String get feedbackProblem => 'Probleem';

  @override
  String get feedbackOther => 'Anders';

  @override
  String get feedbackHint => 'Wat zou Kalorie beter maken?';

  @override
  String get feedbackSend => 'Versturen';

  @override
  String get feedbackSent => 'Binnen. Dank je.';

  @override
  String get feedbackFailed =>
      'Kon het niet versturen. Check je verbinding en probeer het zo nog eens.';

  @override
  String get updates => 'Wat is nieuw';

  @override
  String get updatesSub => 'wat er in de app is veranderd';

  @override
  String get updatesIntro =>
      'Elke versie komt hier te staan. Na een update zie je de punten meteen.';

  @override
  String get updatesAll => 'Alle versies';

  @override
  String whatsNewVersion(String version) {
    return 'Nieuw in $version';
  }

  @override
  String get whatsNewIntro =>
      'Kort wat er anders is sinds je hier voor het laatst was.';

  @override
  String get whatsNewOk => 'Oké';

  @override
  String get newBadge => 'nieuw';

  @override
  String get appLock => 'Vergrendelen';

  @override
  String get appLockSub => 'Face ID of toegangscode als je terugkomt';

  @override
  String get appLockReason => 'Ontgrendel Kalorie om je logboek te zien.';

  @override
  String get appLockBody => 'Je logboek is vergrendeld.';

  @override
  String get appLockUnlock => 'Ontgrendelen';

  @override
  String get appLockUnavailable =>
      'Dit toestel heeft geen Face ID of toegangscode, of je hebt geannuleerd.';
}
