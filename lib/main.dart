import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:bills_app/providers/settings_provider.dart';
import 'package:bills_app/screens/add_transaction_bottom_sheet.dart';
import 'package:bills_app/screens/home_screen.dart';
import 'package:bills_app/screens/reports_screen.dart';
import 'package:bills_app/screens/settings_screen.dart';
import 'package:bills_app/screens/transactions_history_screen.dart';
import 'package:bills_app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:isar_community/isar.dart';

final isarProvider = Provider<Isar>((ref) {
  final instance = Isar.getInstance();
  if (instance == null) {
    throw Exception('Isar has not been initialized yet.');
  }
  return instance;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DB initialization
  await IsarService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStreamProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bills App',

      // default language based on settings
      locale: settingsAsync.when(
        data: (settings) => Locale(settings.languageCode),
        loading: () => const Locale('ar'),
        error: (_, __) => const Locale('ar'),
      ),
      supportedLocales: AppLocalizations.supportedLocales,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),

      // error/load managment for home page
      home: settingsAsync.when(
        data: (_) => const MainScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ReportsScreen(),
    TransactionsHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddTransactionBottomSheet.show(context);
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const HeroIcon(HeroIcons.plus, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppColors.cardBackground,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(HeroIcons.home, l10n.home, 0),
            _navItem(HeroIcons.chartBar, l10n.reports, 1),
            const SizedBox(width: 40),
            _navItem(HeroIcons.documentText, l10n.transactions, 2),
            _navItem(HeroIcons.cog6Tooth, l10n.settingsTitle, 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(HeroIcons icon, String label, int index) {
    final bool isActive = _selectedIndex == index;
    final color = isActive ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
