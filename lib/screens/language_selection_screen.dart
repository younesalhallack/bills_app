import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import 'package:bills_app/core/constants/app_constants.dart';
import '../providers/settings_provider.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  final List<Map<String, String>> _languages = const [
    {'code': 'ar', 'name': 'العربية', 'native': 'العربية (RTL)'},
    {'code': 'en', 'name': 'English', 'native': 'English (LTR)'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.language, style: AppTextStyles.h2),
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.chevronRight,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) {
          final currentLangCode = settings.languageCode;

          return SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: _languages.map((lang) {
                  final String code = lang['code']!;
                  final bool isSelected = currentLangCode == code;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: AppDecorations.cardDecoration,
                    child: ListTile(
                      onTap: () async {
                        if (!isSelected) {
                          final controller = ref.read(
                            settingsControllerProvider,
                          );
                          await controller?.updateLanguageCode(code);
                        }
                      },
                      title: Text(
                        lang['name']!,
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        lang['native']!,
                        style: AppTextStyles.bodySmall,
                      ),
                      trailing: isSelected
                          ? const HeroIcon(
                              HeroIcons.checkCircle,
                              color: AppColors.primary,
                            )
                          : const HeroIcon(
                              HeroIcons.xCircle,
                              color: AppColors.border,
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
