import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/widgets/balance_card.dart';
import 'package:bills_app/widgets/recent_transactions_list.dart';
import 'package:bills_app/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isTablet)
                        _buildTabletLayout()
                      else
                        _buildMobileLayout(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // AppBar الخاص بالرئيسية
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('فواتيري', style: AppTextStyles.bodySmall),
          SizedBox(height: 2),
          Text('أهلاً وسهلاً، أحمد!', style: AppTextStyles.h1),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            icon: const HeroIcon(HeroIcons.bell, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        const BalanceCard(),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                title: 'المصاريف',
                amount: '4,100 ر.س',
                isIncome: false,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: SummaryCard(
                title: 'الإيرادات',
                amount: '6,800 ر.س',
                isIncome: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        const RecentTransactionsList(),
      ],
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              const BalanceCard(),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: const [
                  Expanded(
                    child: SummaryCard(
                      title: 'المصاريف',
                      amount: '4,100 ر.س',
                      isIncome: false,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SummaryCard(
                      title: 'الإيرادات',
                      amount: '6,800 ر.س',
                      isIncome: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        const Expanded(flex: 6, child: RecentTransactionsList()),
      ],
    );
  }
}
