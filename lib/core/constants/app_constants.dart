import 'package:flutter/material.dart';

/// ==========================================
///  1. App Colors Palette (لوحة الألوان)
/// ==========================================
class AppColors {
  AppColors._();

  // Primary & Accent Colors
  static const Color primary = Color(0xFF2563EB); // أزرق ملكي
  static const Color accent = Color(0xFF60A5FA); // أزرق فاتح

  // Status Colors
  static const Color success = Color(0xFF10B981); // أخضر للإيرادات
  static const Color danger = Color(0xFFEF4444); // أحمر للمصاريف
  static const Color warning = Color(0xFFF59E0B); // برتقالي للتنبيهات

  // Backgrounds
  static const Color background = Color(0xFFF9FAFB); // خلفية التطبيق العامة
  static const Color cardBackground = Color(
    0xFFFFFFFF,
  ); // خلفية البطاقات والحقول

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // النصوص الرئيسية
  static const Color textSecondary = Color(0xFF6B7280); // النصوص الفرعية
  static const Color textLight = Color(
    0xFF9CA3AF,
  ); // النصوص الخفيفة / Placeholder

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Category Icon Backgrounds (خلفيات ناعمة للأيقونات)
  static const Color bgSalary = Color(0xFFD1FAE5); // أخضر فاتح للراتب
  static const Color bgElectricity = Color(0xFFDBEAFE); // أزرق فاتح للكهرباء
  static const Color bgGroceries = Color(0xFFFEF3C7); // أصفر فاتح للبقالة
  static const Color bgHousing = Color(0xFFE0E7FF); // بنفسجي فاتح للسكن
}

/// ==========================================
///  2. App Dimensions & Spacing (الأبعاد والمسافات)
/// ==========================================
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // Card Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
}

/// ==========================================
///  3. Typography Styles (أنماط الخطوط)
/// ==========================================
class AppTextStyles {
  AppTextStyles._();

  // اسم الخط المفترض تثبيته في pubspec.yaml
  static const String fontFamily = 'Cairo';

  // Headlines
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Texts
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Financial Amounts / Highlights
  static const TextStyle amountLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle amountMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}

/// ==========================================
///  4. Box Shadows & Card Decorations (الظلال والتنسيقات)
/// ==========================================
class AppDecorations {
  AppDecorations._();

  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: AppSpacing.borderRadiusLg,
    boxShadow: softShadow,
    border: Border.all(color: AppColors.border, width: 1),
  );

  static final BoxDecoration primaryCardDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, Color(0xFF1D4ED8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: AppSpacing.borderRadiusLg,
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
