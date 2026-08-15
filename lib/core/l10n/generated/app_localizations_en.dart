// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kalorie';

  @override
  String get tabToday => 'Today';

  @override
  String get tabHistory => 'History';

  @override
  String get tabMore => 'More';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search a food';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get newProduct => 'New food';

  @override
  String get recents => 'Recent';

  @override
  String get favorites => 'Favorites';

  @override
  String get allFoods => 'All';

  @override
  String get searchOnline => 'Search online';

  @override
  String get searchingOnline => 'Searching online…';

  @override
  String get noResults => 'No foods found';

  @override
  String get noResultsHint => 'Add a custom food or search online.';

  @override
  String get offline => 'You\'re offline. Local foods only.';

  @override
  String get kcal => 'kcal';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get carbsMid => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get gram => 'g';

  @override
  String get per100g => 'per 100 g';

  @override
  String get amount => 'Amount';

  @override
  String get meal => 'Meal';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snacks';

  @override
  String addToMeal(String meal) {
    return 'Add to $meal';
  }

  @override
  String get todayEmpty => 'Nothing logged yet';

  @override
  String get todayEmptyHint => 'Add your first food.';

  @override
  String get addToSection => 'Add';

  @override
  String get onboardingTitle => 'Set your goals';

  @override
  String get onboardingSubtitle =>
      'You can change this later. No account needed.';

  @override
  String get kcalGoal => 'Calories per day';

  @override
  String get start => 'Get started';

  @override
  String get goals => 'Goals';

  @override
  String get goalsSubtitle => 'Daily targets';

  @override
  String get weight => 'Weight';

  @override
  String get weightSubtitle => 'Optional, stored on this device only';

  @override
  String get addWeight => 'Log weight';

  @override
  String get kg => 'kg';

  @override
  String get noWeight => 'No weight logged yet';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get data => 'Data';

  @override
  String get exportData => 'Export data';

  @override
  String get exportDone => 'Export ready';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'Everything stays on this device. No account, no tracking, no ads.';

  @override
  String get about => 'About';

  @override
  String get sources => 'Sources';

  @override
  String get nevoAttribution =>
      'Based on data from NEVO online version 2025/9.0, RIVM, Bilthoven and other data sources.';

  @override
  String get offAttribution => 'Branded products via Open Food Facts (ODbL).';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get name => 'Name';

  @override
  String get brand => 'Brand';

  @override
  String get barcode => 'Barcode';

  @override
  String get serving => 'Serving';

  @override
  String get servingOptional => 'Serving (optional, grams)';

  @override
  String get foodNameHint => 'e.g. oats';

  @override
  String get incompleteProduct => 'Incomplete nutrition. Fill in the values.';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get productNotFoundHint =>
      'Add it yourself. The barcode is already filled in.';

  @override
  String get scanHint => 'Point the camera at the barcode';

  @override
  String get enterBarcode => 'Or enter a barcode';

  @override
  String get favorite => 'Favorite';

  @override
  String get sourceOff => 'OFF';

  @override
  String get sourceNevo => 'NEVO';

  @override
  String get sourceCustom => 'Custom';

  @override
  String get overGoal => 'over goal';

  @override
  String get remaining => 'remaining';

  @override
  String ofGoal(int goal) {
    return 'of $goal kcal';
  }

  @override
  String get historyEmpty => 'No days logged yet';

  @override
  String get historyEmptyHint => 'Log a few days to see your week.';

  @override
  String get thisWeek => 'This week';

  @override
  String get month => 'Month';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get deleteEntryTitle => 'Delete?';

  @override
  String deleteEntryBody(String name) {
    return '$name will be removed from this day.';
  }

  @override
  String get copied => 'Updated';

  @override
  String get rateLimited => 'Please wait — too many online searches.';

  @override
  String get networkError => 'Couldn\'t search online.';

  @override
  String get more => 'More';

  @override
  String get moreSection => 'App';

  @override
  String get customFood => 'Custom food';

  @override
  String get kcalShort => 'kcal';

  @override
  String get proteinShort => 'P';

  @override
  String get carbsShort => 'C';

  @override
  String get fatShort => 'F';

  @override
  String get saveProduct => 'Save food';

  @override
  String get log => 'Log';

  @override
  String get portie => '1 serving';

  @override
  String get cameraDenied => 'Camera access is needed to scan.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get unitPortion => 'Serving';

  @override
  String get unitGrams => 'Grams';

  @override
  String get portions => 'Count';

  @override
  String get defineServing => 'Set a serving';

  @override
  String get editServing => 'Edit serving';

  @override
  String get servingName => 'What is one serving?';

  @override
  String get servingGrams => 'How many grams is that?';

  @override
  String get servingSheetHint =>
      'E.g. 1 slice of bread = 35 g. Then you log in slices.';

  @override
  String get fixFood => 'Values look wrong?';

  @override
  String get fixFoodHint =>
      'Edit name, serving or nutrition. Only for you, on this device.';

  @override
  String get editDoesNotRewrite =>
      'Earlier logged days stay the same. New logs use the new values.';

  @override
  String get per100gHint =>
      'As on the label: calories and macros per 100 grams.';

  @override
  String get editAmount => 'Edit amount';

  @override
  String get undo => 'Undo';

  @override
  String loggedSnack(String name, String amount) {
    return '$name · $amount';
  }

  @override
  String get adjust => 'Adjust';

  @override
  String servingEquals(int grams) {
    return '1 serving = $grams g';
  }

  @override
  String logKcal(int kcal) {
    return 'Log $kcal kcal';
  }
}
