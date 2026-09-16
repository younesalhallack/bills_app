import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = true;
  bool _pinEnabled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.securityAndPrivacy, style: AppTextStyles.h2),
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.chevronRight,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Container(
                decoration: AppDecorations.cardDecoration,
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _biometricEnabled,
                      onChanged: (val) =>
                          setState(() => _biometricEnabled = val),
                      activeThumbColor: AppColors.primary,
                      secondary: const HeroIcon(
                        HeroIcons.fingerPrint,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        l10n.biometrics,
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        l10n.biometricsSubtitle,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    SwitchListTile(
                      value: _pinEnabled,
                      onChanged: (val) => setState(() => _pinEnabled = val),
                      activeThumbColor: AppColors.primary,
                      secondary: const HeroIcon(
                        HeroIcons.lockClosed,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        l10n.pinProtection,
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        l10n.pinProtectionSubtitle,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              if (_pinEnabled) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  decoration: AppDecorations.cardDecoration,
                  child: ListTile(
                    onTap: () {},
                    leading: const HeroIcon(
                      HeroIcons.key,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      l10n.changePin,
                      style: AppTextStyles.bodyMedium,
                    ),
                    trailing: const HeroIcon(
                      HeroIcons.chevronLeft,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
