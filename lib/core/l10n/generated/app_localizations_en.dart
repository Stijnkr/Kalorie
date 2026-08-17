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
  String get noResultsHint => 'Add the food yourself, or scan the barcode.';

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
  String get cm => 'cm';

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
  String get privacyTitle => 'Privacy policy';

  @override
  String get privacyBody =>
      'An account is required to use Kalorie. Your log stays on this device and syncs to your account. No tracking, no ads.';

  @override
  String get privacySub => 'what we store and how you delete it';

  @override
  String get termsTitle => 'Terms';

  @override
  String get termsSub => 'using the app, not medical advice';

  @override
  String get legalDisclaimer =>
      'Kalorie is not medical advice and not a diet treatment. See a doctor if you have questions about food or weight.';

  @override
  String supportContact(String email) {
    return 'Questions or a request about your data: $email';
  }

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
  String get rateLimited => 'Please wait. Too many online searches.';

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

  @override
  String get kcalOver => 'kcal left';

  @override
  String eatenOfGoal(int eaten, int goal) {
    return '$eaten of $goal kcal eaten';
  }

  @override
  String get showAll => 'Show all';

  @override
  String get showLess => 'Less';

  @override
  String get fiber => 'Fibre';

  @override
  String get sugars => 'Of which sugars';

  @override
  String get satFat => 'Of which saturated';

  @override
  String get salt => 'Salt';

  @override
  String get sugarsLower => 'of which sugars';

  @override
  String get satFatLower => 'of which saturated';

  @override
  String get water => 'Water';

  @override
  String waterProgress(String amount, String goal) {
    return '$amount L of $goal L';
  }

  @override
  String get waterHint => 'One glass is 250 ml · tap to top up';

  @override
  String get waterDone => 'Goal reached. Tap a glass to correct.';

  @override
  String get calendar => 'Calendar';

  @override
  String get toToday => 'Go to today';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String logInMeal(String meal) {
    return 'Log in $meal';
  }

  @override
  String get quickAddHint => 'tap + to log straight away';

  @override
  String get searchDatabase => 'Search the database';

  @override
  String get createNewProduct => 'Create a new food';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get nothingFoundHint => 'Add the food yourself, or scan the barcode.';

  @override
  String get editPortion => 'Edit serving';

  @override
  String get inGrams => 'in grams';

  @override
  String get gramsUnit => 'grams';

  @override
  String portionTotal(String label, int grams, int total) {
    return '1 $label = $grams g · $total g total';
  }

  @override
  String per100Short(String value) {
    return '$value /100g';
  }

  @override
  String weekAverage(int goal) {
    return 'kcal average · goal $goal';
  }

  @override
  String weekLoggedDays(int logged, int total) {
    return '$logged of $total days logged';
  }

  @override
  String get nothingLoggedTap => 'nothing logged, tap to fill in';

  @override
  String get notYetHappened => 'not yet';

  @override
  String get goalsIntro =>
      'Your macros add up to your kcal goal. Change the goal and the rest follows.';

  @override
  String get dayGoal => 'Daily goal';

  @override
  String get kcalPerDay => 'kcal per day';

  @override
  String get goalsMoreSub => 'kcal and macro split';

  @override
  String get weightMoreSub => 'track it weekly';

  @override
  String get ownProducts => 'Custom foods';

  @override
  String get ownProductsSub => 'nutrition you entered yourself';

  @override
  String get settingsMoreSub => 'theme, display, export';

  @override
  String get restartOnboarding => 'Onboarding again';

  @override
  String get restartOnboardingSub => 'see the first run';

  @override
  String get moreFootnote =>
      'Nutrition from NEVO 2025 and Open Food Facts. Your log stays on your phone and, when signed in, on your account.';

  @override
  String weightDeltaIn30(String delta) {
    return 'kg · $delta in 30 days';
  }

  @override
  String logWeightToday(String kg) {
    return 'Weigh in today: $kg kg';
  }

  @override
  String get measurements => 'Measurements';

  @override
  String get displaySection => 'Appearance';

  @override
  String get dataSection => 'Data';

  @override
  String get exportDataSub => 'everything as JSON, stays on your phone';

  @override
  String stepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get obGoalTitle => 'Where are you heading?';

  @override
  String get obGoalBody =>
      'Direction and pace set the estimate. You still pick the number yourself on the next screen.';

  @override
  String get obLose => 'Lose weight';

  @override
  String get obMaintain => 'Stay the same';

  @override
  String get obGain => 'Gain weight';

  @override
  String get obPaceTitle => 'How fast?';

  @override
  String get obPaceBody =>
      'This sets your daily goal. You can change it later in Goals without filling everything in again.';

  @override
  String get obPaceCalm => 'Easy · 0.25 kg/week';

  @override
  String get obPaceNormal => 'Normal · 0.5 kg/week';

  @override
  String get obPaceFast => 'Fast · 0.75 kg/week';

  @override
  String get obBodyTitle => 'About you';

  @override
  String get obBodyBody =>
      'Age, height and weight. Only to work out a starting number. Nothing is shared with a scale.';

  @override
  String get obSexFemale => 'Woman';

  @override
  String get obSexMale => 'Man';

  @override
  String get obAge => 'Age';

  @override
  String get obYears => 'years';

  @override
  String get obHeight => 'Height';

  @override
  String get obWeight => 'Weight';

  @override
  String get obMoveTitle => 'How do you move?';

  @override
  String get obMoveBody =>
      'No sport counts too. Pick what a normal week looks like.';

  @override
  String get obMoveNone => 'Little movement';

  @override
  String get obMoveNoneSub => 'desk work, almost no sport';

  @override
  String get obMoveLight => 'Lightly active';

  @override
  String get obMoveLightSub => 'walking, cycling, sport 1–2 times';

  @override
  String get obMoveSport => 'Regular sport';

  @override
  String get obMoveSportSub => '3–5 sessions a week';

  @override
  String get obMoveMuch => 'A lot of sport';

  @override
  String get obMoveMuchSub => 'almost daily, or a physical job';

  @override
  String get obDoneTitle => 'Your daily goal';

  @override
  String get obDoneBody =>
      'This is an estimate. Set it to a number you can keep. You can change it later in Goals.';

  @override
  String get obAdjustHint =>
      'Plus and minus in steps of 50. The estimate stays next to it.';

  @override
  String obEstimateLine(int target, int maintain) {
    return 'Estimate $target · maintain $maintain';
  }

  @override
  String get obFootnote => 'Your account keeps your log. No tracking, no ads.';

  @override
  String get next => 'Next';

  @override
  String get begin => 'Start';

  @override
  String get deleted => 'Deleted';

  @override
  String get removeEntry => 'Remove row';

  @override
  String get scanSimulateHint =>
      'Hold the barcode inside the frame. The food goes straight into your log, with the serving you used last.';

  @override
  String get account => 'Account';

  @override
  String get accountSignedOut => 'No account';

  @override
  String get accountSignedOutSub => 'sign in to keep your log safe';

  @override
  String accountSince(String email, String since) {
    return '$email · since $since';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Create account';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountBody =>
      'Deleting wipes your account and every log from the server. An export stays on your phone.';

  @override
  String get deleteAccountConfirm => 'Are you sure? This cannot be undone.';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authCreateAccount => 'Create your account';

  @override
  String get authSignInBody =>
      'Sign in and your log, goals and weight come back from the server.';

  @override
  String get authSignUpBody =>
      'With an account your log is safe and comes back on every device you sign in on.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Name';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get passwordPlaceholder => 'at least 10 characters';

  @override
  String get namePlaceholder => 'what should we call you?';

  @override
  String get authLegal =>
      'By continuing you agree to the terms and the privacy policy.';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get resetSent => 'Check your mail for a link to reset your password.';

  @override
  String get errInvalidCredentials => 'That email or password isn\'t right.';

  @override
  String get errEmailTaken => 'An account with this email already exists.';

  @override
  String get errWeakPassword =>
      'Choose a password of at least 10 characters. Not your email, and not the same character over and over.';

  @override
  String get errLeakedPassword =>
      'This password appears in a known leak. Choose another, preferably from a password manager.';

  @override
  String get errInvalidEmail =>
      'That doesn\'t look like a valid email address.';

  @override
  String get errNeedsConfirmation =>
      'Confirm your email via the link we just sent.';

  @override
  String get errNetwork => 'No connection. Try again in a moment.';

  @override
  String get errRateLimited =>
      'Too many emails in a row. Wait a few minutes and try again, or sign in if the account already exists.';

  @override
  String get errUnknown =>
      'Creating the account didn\'t work. Try again in a moment.';

  @override
  String get errCloudUnavailable =>
      'No connection to the server. Try again in a moment.';

  @override
  String get syncSection => 'Sync';

  @override
  String get syncDiary => 'Sync the log';

  @override
  String get syncDiarySub => 'meals and water on all your devices';

  @override
  String get syncWeight => 'Sync weight';

  @override
  String get syncWeightSub => 'measurements and trend';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncRunning => 'Syncing…';

  @override
  String syncDone(String time) {
    return 'Updated at $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String get syncOffline => 'Offline. It will wait until you are back online.';

  @override
  String get syncFailed => 'Syncing didn\'t work.';

  @override
  String get securitySection => 'Security and data';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordSub => 'we\'ll email you a link';

  @override
  String get obAccountTitleUp => 'Create your account';

  @override
  String get obAccountTitleIn => 'Welcome back';

  @override
  String get skipForNow => 'Continue without an account';

  @override
  String get skipForNowSub => 'everything then stays on this device only';

  @override
  String get recipes => 'My recipes';

  @override
  String get recipesSub => 'fixed combinations in one tap';

  @override
  String get recipesIntro =>
      'A recipe is a fixed combination you log in one tap. Tap the plus to log a portion, tap the name to edit it.';

  @override
  String get newRecipe => 'New recipe';

  @override
  String get editRecipe => 'Edit recipe';

  @override
  String get recipeName => 'Name';

  @override
  String get recipeNameHint => 'e.g. Quark with banana';

  @override
  String get recipePortions => 'Number of portions';

  @override
  String get recipePortionsSub => 'sets what one portion costs';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get recipeEmpty => 'No ingredients yet. Pick a food below.';

  @override
  String get addIngredient => 'Add';

  @override
  String get saveRecipe => 'Save recipe';

  @override
  String recipeTotal(int kcal, int perPortion) {
    return 'Total $kcal kcal · one portion $perPortion kcal';
  }

  @override
  String recipePerPortion(int kcal, int grams) {
    return '$kcal kcal per portion · $grams g';
  }

  @override
  String get deleteRecipe => 'Delete recipe';

  @override
  String get deleteRecipeConfirm =>
      'This recipe leaves your list. Logged portions stay in your diary.';

  @override
  String get deleteProduct => 'Delete product';

  @override
  String deleteProductConfirm(String name) {
    return '$name leaves your custom foods. Logged days stay as they are.';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersSub => 'a nudge when you don\'t log';

  @override
  String get remindersIntro =>
      'Only a nudge when you haven\'t logged. If the meal is already logged, no notification arrives.';

  @override
  String get remindersFootnote =>
      'Tap the time to move it. Notifications only work if you allowed them on your phone.';

  @override
  String remindersEnabledCount(int count) {
    return '$count on';
  }

  @override
  String get reminderWeighIn => 'Weigh-in';

  @override
  String get reminderBreakfastSub => 'when breakfast is still empty';

  @override
  String get reminderLunchSub => 'when lunch is still empty';

  @override
  String get reminderDinnerSub => 'when dinner is still empty';

  @override
  String get reminderSnackSub => 'when the day isn\'t wrapped up';

  @override
  String get reminderWeighInSub => 'weekly at your weigh-in moment';

  @override
  String reminderBody(String meal) {
    return 'Nothing logged for $meal yet.';
  }

  @override
  String get reminderWeighBody => 'Time to step on the scale?';

  @override
  String get notificationsDenied =>
      'Notifications are off. Turn them on in Settings › Kalorie.';

  @override
  String get accountSwitchTitle => 'Different account';

  @override
  String get accountSwitchBody =>
      'This device still has data from another account. Switching loads this account\'s log and replaces what\'s here. The other account stays in the cloud.';

  @override
  String get accountSwitchConfirm => 'Switch';

  @override
  String get signOutStaysLocal =>
      'Your log stays on this device. Sign in again to sync.';

  @override
  String get recoverTitle => 'New password';

  @override
  String get recoverBody =>
      'Pick a password of at least 10 characters. After that you can sign in on all your devices again.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get savePassword => 'Save password';

  @override
  String get passwordUpdated => 'Your password has been changed.';

  @override
  String get errPasswordMismatch => 'Those two passwords don\'t match.';

  @override
  String get recipeListEmpty =>
      'No recipes yet. Make one and you log it in a single tap.';

  @override
  String get ownProductsIntro =>
      'Foods you added yourself. Tap one to edit it.';

  @override
  String get newOwnProduct => 'New food';

  @override
  String get ownProductsEmpty => 'No custom foods yet.';

  @override
  String get moreSectionDay => 'Day';

  @override
  String get moreSectionFood => 'Food';

  @override
  String get moreSectionApp => 'App';

  @override
  String get obFootnoteSignedIn =>
      'Your goals stay on this device and also go to the cloud.';

  @override
  String get weekdayMonday => 'Mon';

  @override
  String get weekdayTuesday => 'Tue';

  @override
  String get weekdayWednesday => 'Wed';

  @override
  String get weekdayThursday => 'Thu';

  @override
  String get weekdayFriday => 'Fri';

  @override
  String get weekdaySaturday => 'Sat';

  @override
  String get weekdaySunday => 'Sun';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackSub => 'an idea, a bug, or something that feels off';

  @override
  String get feedbackIntro =>
      'I read everything. Short is fine. Version and device go with it automatically.';

  @override
  String get feedbackIdea => 'Idea';

  @override
  String get feedbackProblem => 'Problem';

  @override
  String get feedbackOther => 'Other';

  @override
  String get feedbackHint => 'What would make Kalorie better?';

  @override
  String get feedbackSend => 'Send';

  @override
  String get feedbackSent => 'Got it. Thank you.';

  @override
  String get feedbackFailed =>
      'Couldn\'t send. Check your connection and try again.';

  @override
  String get updates => 'What\'s new';

  @override
  String get updatesSub => 'what changed in the app';

  @override
  String get updatesIntro =>
      'Every version lands here. After an update you see the notes right away.';

  @override
  String get updatesAll => 'All versions';

  @override
  String whatsNewVersion(String version) {
    return 'New in $version';
  }

  @override
  String get whatsNewIntro =>
      'A short look at what changed since you were last here.';

  @override
  String get whatsNewOk => 'OK';

  @override
  String get newBadge => 'new';

  @override
  String get appLock => 'Lock';

  @override
  String get appLockSub => 'Face ID or passcode when you come back';

  @override
  String get appLockReason => 'Unlock Kalorie to see your log.';

  @override
  String get appLockBody => 'Your log is locked.';

  @override
  String get appLockUnlock => 'Unlock';

  @override
  String get appLockUnavailable =>
      'This device has no Face ID or passcode, or you cancelled.';
}
