// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get reports => 'Reports';

  @override
  String get transactions => 'Transactions';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get generalPreferences => 'General Preferences';

  @override
  String get baseCurrency => 'Base Currency';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get notifications => 'Notifications & Alerts';

  @override
  String get securityAndData => 'Security & Data';

  @override
  String get backup => 'Backup';

  @override
  String get appLock => 'App Lock (FaceID/Fingerprint)';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation =>
      'Are you sure you want to log out of the application?';

  @override
  String get cancel => 'Cancel';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get seeAll => 'See All';

  @override
  String get noRecentTransactions => 'No recent transactions';

  @override
  String get transaction => 'Transaction';

  @override
  String get income => 'Income';

  @override
  String get expenses => 'Outcome';

  @override
  String get appName => 'Bills App';

  @override
  String welcomeUser(Object userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get errorLoadingData => 'An error occurred while loading data';

  @override
  String get noCategory => 'Uncategorized';

  @override
  String get categoryDistribution => 'Category Breakdown';

  @override
  String get monthlyComparison => 'Monthly Comparison';

  @override
  String get expensesCategoryDistribution =>
      'Expenses Distribution by Category';

  @override
  String get incomeCategoryDistribution => 'Income Distribution by Category';

  @override
  String get noDataForThisMonth => 'No data available for this month';

  @override
  String get monthlyIncomeAndExpenses => 'Monthly Income & Expenses';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get incomeDetails => 'Income Details';

  @override
  String get noDetailsAvailable => 'No details available';

  @override
  String percentageRate(Object percent) {
    return 'Collection/Consumption Rate: $percent';
  }

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get searchTransactionOrNote => 'Search for transaction or note...';

  @override
  String get all => 'All';

  @override
  String get noMatchingResults => 'No results match the filter';

  @override
  String get noTransactionsYet => 'No transactions recorded yet';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get securityAndPrivacy => 'Security & Privacy';

  @override
  String get biometrics => 'Face ID / Fingerprint';

  @override
  String get biometricsSubtitle => 'Secure app with biometrics';

  @override
  String get pinProtection => 'PIN Code Protection';

  @override
  String get pinProtectionSubtitle => 'Require passcode on app launch';

  @override
  String get changePin => 'Change PIN Code';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email Address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get expense => 'Outcome';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get backupSettings => 'Backup & Restore';

  @override
  String get backupSuccessMessage => 'Backup completed successfully!';

  @override
  String get googleDriveCloud => 'Google Drive Cloud';

  @override
  String get lastSyncStatus => 'Last sync: Today, 09:00 AM';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get autoBackupSubtitle => 'Automatically backup data daily';

  @override
  String get backingUp => 'Backing up...';

  @override
  String get createBackupNow => 'Create Backup Now';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get mainCurrency => 'Primary Currency';

  @override
  String get currencySar => 'Saudi Riyal';

  @override
  String get symbolSar => 'SAR';

  @override
  String get currencyAed => 'UAE Dirham';

  @override
  String get symbolAed => 'AED';

  @override
  String get currencyUsd => 'US Dollar';

  @override
  String get currencyEur => 'Euro';

  @override
  String get currencySyr => 'SYRIAN Pound';

  @override
  String get symbolEgp => 'EGP';

  @override
  String get currencyKwd => 'Kuwaiti Dinar';

  @override
  String get symbolKwd => 'KWD';

  @override
  String get currencyQar => 'Qatari Riyal';

  @override
  String get symbolQar => 'QAR';

  @override
  String get addNewTransaction => 'Add New Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get amountHint => '0.00 SYP';

  @override
  String get category => 'Category';

  @override
  String get addCategory => 'Add Category';

  @override
  String get notesHint => 'Add note or description (optional)...';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String insufficientBalanceError(Object balance) {
    return 'Sorry, your current balance ($balance SYP) is not enough to complete this operation!';
  }

  @override
  String get transactionAddedSuccess => 'Transaction added successfully!';

  @override
  String get addNewCategory => 'Add New Category';

  @override
  String get categoryNameHint => 'Category name (e.g., Gifts, Education)...';

  @override
  String get chooseIcon => 'Choose Icon:';

  @override
  String get add => 'Add';

  @override
  String get errorPrefix => 'Error';
}
