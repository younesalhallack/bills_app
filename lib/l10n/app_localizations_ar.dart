// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get reports => 'التقارير';

  @override
  String get transactions => 'المعاملات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get generalPreferences => 'التفضيلات العامة';

  @override
  String get baseCurrency => 'العملة الأساسية';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get notifications => 'التنبيهات والإشعارات';

  @override
  String get securityAndData => 'الأمان والبيانات';

  @override
  String get backup => 'النسخ الاحتياطي';

  @override
  String get appLock => 'قفل التطبيق (بصمة الوجه/الإصبع)';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation =>
      'هل أنت تأكد من أنك تريد تسجيل الخروج من التطبيق؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get enabled => 'مفعل';

  @override
  String get disabled => 'معطل';

  @override
  String get totalBalance => 'الرصيد الكلي';

  @override
  String get recentTransactions => 'أحدث المعاملات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noRecentTransactions => 'لا توجد معاملات حديثة';

  @override
  String get transaction => 'معاملة';

  @override
  String get income => 'إيراد';

  @override
  String get expenses => 'المصروفات';

  @override
  String get appName => 'فواتيري';

  @override
  String welcomeUser(Object userName) {
    return 'أهلاً وسهلاً، $userName!';
  }

  @override
  String get errorLoadingData => 'حدث خطأ في تحميل البيانات';

  @override
  String get noCategory => 'بدون فئة';

  @override
  String get categoryDistribution => 'توزيع الفئات';

  @override
  String get monthlyComparison => 'مقارنة شهرية';

  @override
  String get expensesCategoryDistribution => 'توزيع المصاريف حسب الفئة';

  @override
  String get incomeCategoryDistribution => 'توزيع الإيرادات حسب الفئة';

  @override
  String get noDataForThisMonth => 'لا توجد بيانات لهذا الشهر';

  @override
  String get monthlyIncomeAndExpenses => 'الإيرادات والمصاريف شهرياً';

  @override
  String get expenseDetails => 'تفاصيل المصاريف';

  @override
  String get incomeDetails => 'تفاصيل الإيرادات';

  @override
  String get noDetailsAvailable => 'لا توجد تفاصيل متاحة';

  @override
  String percentageRate(Object percent) {
    return 'نسبة التحصيل/الاستهلاك: $percent';
  }

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get searchTransactionOrNote => 'البحث عن معاملة أو ملاحظة...';

  @override
  String get all => 'الكل';

  @override
  String get noMatchingResults => 'لا توجد نتائج تطابق التصفية';

  @override
  String get noTransactionsYet => 'لا توجد معاملات مسجلة حتى الآن';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'الأمس';

  @override
  String get securityAndPrivacy => 'الأمان والخصوصية';

  @override
  String get biometrics => 'بصمة الوجه / الإصبع';

  @override
  String get biometricsSubtitle => 'تأمين التطبيق بالبصمة الحيوية';

  @override
  String get pinProtection => 'رمز PIN للحماية';

  @override
  String get pinProtectionSubtitle => 'طلب رمز مرور عند فتح التطبيق';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get fullName => 'الاسم كامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get expense => 'مصروف';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get backupSettings => 'النسخ الاحتياطي';

  @override
  String get backupSuccessMessage => 'تم اكتمال النسخ الاحتياطي بنجاح!';

  @override
  String get googleDriveCloud => 'سحابة Google Drive';

  @override
  String get lastSyncStatus => 'آخر مزامنة: اليوم، 09:00 صباحاً';

  @override
  String get autoBackup => 'النسخ الاحتياطي التلقائي';

  @override
  String get autoBackupSubtitle => 'حفظ البيانات تلقائياً يومياً';

  @override
  String get backingUp => 'جاري النسخ...';

  @override
  String get createBackupNow => 'إنشاء نسخة احتياطية الآن';

  @override
  String get restoreData => 'استعادة البيانات';

  @override
  String get mainCurrency => 'العملة الأساسية';

  @override
  String get currencySar => 'ريال سعودي';

  @override
  String get symbolSar => 'ر.س';

  @override
  String get currencyAed => 'درهم إماراتي';

  @override
  String get symbolAed => 'د.إ';

  @override
  String get currencyUsd => 'دولار أمريكي';

  @override
  String get currencyEur => 'يورو';

  @override
  String get currencySyr => 'ليرة سورية';

  @override
  String get symbolEgp => 'ج.م';

  @override
  String get currencyKwd => 'دينار كويتي';

  @override
  String get symbolKwd => 'د.ك';

  @override
  String get currencyQar => 'ريال قطري';

  @override
  String get symbolQar => 'ر.ق';

  @override
  String get addNewTransaction => 'إضافة معاملة جديدة';

  @override
  String get amount => 'المبلغ';

  @override
  String get amountHint => '0.00 ل.س';

  @override
  String get category => 'الفئة';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get notesHint => 'أضف ملاحظة أو وصف (اختياري)...';

  @override
  String get addTransaction => 'إضافة المعاملة';

  @override
  String get pleaseEnterAmount => 'الرجاء إدخال المبلغ';

  @override
  String get pleaseEnterValidAmount => 'الرجاء إدخال مبلغ صحيح';

  @override
  String get pleaseSelectCategory => 'الرجاء اختيار فئة';

  @override
  String insufficientBalanceError(Object balance) {
    return 'عذراً، رصيدك الحالي ($balance ل.س) لا يكفي لإتمام هذه العملية!';
  }

  @override
  String get transactionAddedSuccess => 'تمت إضافة المعاملة بنجاح!';

  @override
  String get addNewCategory => 'إضافة فئة جديدة';

  @override
  String get categoryNameHint => 'اسم الفئة (مثال: هدايا، تعليم)...';

  @override
  String get chooseIcon => 'اختر أيقونة:';

  @override
  String get add => 'إضافة';

  @override
  String get errorPrefix => 'خطأ';
}
