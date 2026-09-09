import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/screens/add_transaction_bottom_sheet.dart';
import 'package:bills_app/screens/home_screen.dart';
import 'package:bills_app/screens/reports_screen.dart';
import 'package:bills_app/screens/settings_screen.dart';
import 'package:bills_app/screens/transactions_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heroicons/heroicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', ''),
      supportedLocales: const [
        Locale('ar', ''), //  (RTL)
        Locale('en', ''), //  (LTR)
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        //textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainScreen(),
    );
  }
}

//
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = const [
    HomeScreen(), // صفحة الرئيسية
    ReportsScreen(), // صفحة التقارير
    TransactionsHistoryScreen(), // صفحة المعاملات
    SettingsScreen(), // صفحة الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // استخدام IndexedStack للحفاظ على حالة الصفحات عند التنقل
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // شريط التنقل السفلي
  Widget _buildBottomNavigationBar() {
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
            _navItem(HeroIcons.home, 'الرئيسية', 0),
            _navItem(HeroIcons.chartBar, 'التقارير', 1),
            const SizedBox(width: 40), // مسافة مخصصة للزر العائم في المنتصف
            _navItem(HeroIcons.documentText, 'المعاملات', 2),
            _navItem(HeroIcons.cog6Tooth, 'الإعدادات', 3),
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
