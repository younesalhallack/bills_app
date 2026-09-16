import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  bool _autoBackup = true;
  bool _isBackingUp = false;

  void _runBackup(AppLocalizations l10n) async {
    setState(() => _isBackingUp = true);
    await Future.delayed(const Duration(seconds: 2)); // save simulation
    if (mounted) {
      setState(() => _isBackingUp = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.backupSuccessMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.backupSettings, style: AppTextStyles.h2),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // sync status card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppDecorations.cardDecoration,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const HeroIcon(
                        HeroIcons.cloud,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.googleDriveCloud,
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            l10n.lastSyncStatus,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // options
              Container(
                decoration: AppDecorations.cardDecoration,
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _autoBackup,
                      onChanged: (val) => setState(() => _autoBackup = val),
                      activeThumbColor: AppColors.primary,
                      secondary: const HeroIcon(
                        HeroIcons.arrowPath,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        l10n.autoBackup,
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        l10n.autoBackupSubtitle,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isBackingUp ? null : () => _runBackup(l10n),
                  icon: _isBackingUp
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const HeroIcon(
                          HeroIcons.cloudArrowUp,
                          color: Colors.white,
                        ),
                  label: Text(
                    _isBackingUp ? l10n.backingUp : l10n.createBackupNow,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  icon: const HeroIcon(
                    HeroIcons.cloudArrowDown,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    l10n.restoreData,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
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
}
