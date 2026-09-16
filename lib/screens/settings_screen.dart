import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:bills_app/core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import '../providers/isar_providers.dart';

import 'edit_profile_screen.dart';
import 'currency_selection_screen.dart';
import 'language_selection_screen.dart';
import 'backup_settings_screen.dart';
import 'security_settings_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.cardBackground,
        title: Text(l10n.logout, style: AppTextStyles.h2),
        content: Text(l10n.logoutConfirmation, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // منطق تسجيل الخروج هنا
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsStreamProvider);
    final currencySettingsAsync = ref.watch(currencySettingsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.settingsTitle, style: AppTextStyles.h1),
      ),
      body: settingsAsync.when(
        data: (settings) {
          final isArabic = settings.languageCode == 'ar';

          // جلب تفاصيل العملة الأساسية الحالية ديناميكياً
          final baseCurrencyText = currencySettingsAsync.when(
            data: (currencySettings) {
              if (currencySettings == null) return '';
              final name = l10n.baseCurrency;
              //final symbol = currencySettings.baseCurrencySymbol;
              final code = currencySettings.baseCurrencyCode;

              return '$name ( $code)';
            },
            loading: () => '...',
            error: (_, __) => '',
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة الملف الشخصي
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
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // التفضيلات العامة
                  Text(l10n.generalPreferences, style: AppTextStyles.h3),
                  const SizedBox(height: AppSpacing.sm),

                  _buildSettingsGroup([
                    _buildSettingTile(
                      icon: HeroIcons.currencyDollar,
                      title: l10n.baseCurrency,
                      subtitle: baseCurrencyText.isNotEmpty
                          ? baseCurrencyText
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CurrencySettingsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingTile(
                      icon: HeroIcons.language,
                      title: l10n.language,
                      subtitle: isArabic ? l10n.arabic : l10n.english,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSwitchTile(
                      icon: HeroIcons.bell,
                      title: l10n.notifications,
                      value: settings.notificationsEnabled,
                      onChanged: (val) {
                        final controller = ref.read(settingsControllerProvider);
                        controller?.toggleNotifications(val);
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // الأمان والبيانات
                  Text(l10n.securityAndData, style: AppTextStyles.h3),
                  const SizedBox(height: AppSpacing.sm),

                  _buildSettingsGroup([
                    _buildSettingTile(
                      icon: HeroIcons.cloudArrowUp,
                      title: l10n.backup,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BackupSettingsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingTile(
                      icon: HeroIcons.lockClosed,
                      title: l10n.appLock,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SecuritySettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  // زر تسجيل الخروج
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _showLogoutDialog(context, l10n),
                      icon: const HeroIcon(
                        HeroIcons.arrowLeftStartOnRectangle,
                        color: AppColors.danger,
                      ),
                      label: Text(
                        l10n.logout,
                        style: const TextStyle(
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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
      activeColor: AppColors.primary,
      secondary: HeroIcon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
    );
  }
}
