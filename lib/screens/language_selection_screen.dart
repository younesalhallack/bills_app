import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:bills_app/core/constants/app_constants.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguageCode = 'ar';

  final List<Map<String, String>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'native': 'العربية (RTL)'},
    {'code': 'en', 'name': 'English', 'native': 'English (LTR)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('لغة التطبيق', style: AppTextStyles.h2),
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.chevronRight,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context, _selectedLanguageCode),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: _languages.map((lang) {
              final bool isSelected = _selectedLanguageCode == lang['code'];
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: AppDecorations.cardDecoration,
                child: ListTile(
                  onTap: () {
                    setState(() => _selectedLanguageCode = lang['code']!);
                  },
                  title: Text(lang['name']!, style: AppTextStyles.bodyMedium),
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
      ),
    );
  }
}
