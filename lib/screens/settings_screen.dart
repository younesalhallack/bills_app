import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('الإعدادات', style: AppTextStyles.h1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. بطاقة الملف الشخصي
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppDecorations.cardDecoration,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const HeroIcon(
                        HeroIcons.user,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('أحمد محمد', style: AppTextStyles.h2),
                          Text(
                            'ahmed@example.com',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const HeroIcon(
                        HeroIcons.pencilSquare,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 2. إعدادات الحساب والتطبيق
              const Text('التفضيلات العامة', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.sm),

              _buildSettingsGroup([
                _buildSettingTile(
                  icon: HeroIcons.currencyDollar,
                  title: 'العملة الأساسية',
                  subtitle: 'ريال سعودي (ر.س)',
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: HeroIcons.language,
                  title: 'اللغة',
                  subtitle: 'العربية',
                  onTap: () {},
                ),
                _buildSwitchTile(
                  icon: HeroIcons.bell,
                  title: 'التنبيهات والإشعارات',
                  value: _notificationsEnabled,
                  onChanged: (val) =>
                      setState(() => _notificationsEnabled = val),
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // 3. الأمان والبيانات
              const Text('الأمان والبيانات', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.sm),

              _buildSettingsGroup([
                _buildSettingTile(
                  icon: HeroIcons.cloudArrowUp,
                  title: 'النسخ الاحتياطي',
                  subtitle: 'آخر مزامنة: اليوم 09:00 ص',
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: HeroIcons.lockClosed,
                  title: 'قفل التطبيق (بصمة الوجه/الإصبع)',
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // 4. تسجيل الخروج
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const HeroIcon(
                    HeroIcons.arrowLeftStartOnRectangle,
                    color: AppColors.danger,
                  ),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: Column(children: tiles),
    );
  }

  Widget _buildSettingTile({
    required HeroIcons icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: HeroIcon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodySmall)
          : null,
      trailing: const HeroIcon(
        HeroIcons.chevronLeft,
        size: 18,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildSwitchTile({
    required HeroIcons icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      secondary: HeroIcon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
    );
  }
}
