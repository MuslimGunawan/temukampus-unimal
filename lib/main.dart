import 'package:flutter/material.dart';
import 'models/report_item.dart';
import 'data/sample_data.dart';
import 'services/storage_service.dart';
import 'pages/home_page.dart';
import 'pages/my_reports_page.dart';
import 'pages/add_report_page.dart';
import 'pages/about_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TemuKampusApp());
}

class TemuKampusApp extends StatefulWidget {
  const TemuKampusApp({super.key});

  @override
  State<TemuKampusApp> createState() => _TemuKampusAppState();
}

class _TemuKampusAppState extends State<TemuKampusApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeSetting();
  }

  Future<void> _loadThemeSetting() async {
    final isDark = await StorageService.loadDarkMode();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    StorageService.saveDarkMode(isDark);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A8A); // Royal Navy UNIMAL
    const secondaryColor = Color(0xFF0D9488); // Modern Emerald Teal

    return MaterialApp(
      title: 'TemuKampus UNIMAL',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // Light Theme Modern & Clean
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50 ultra clean
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 4,
          height: 68,
          indicatorColor: primaryColor.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),

      // Dark Theme Modern Slate
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Slate
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: const Color(0xFF60A5FA),
          secondary: const Color(0xFF2DD4BF),
          surface: const Color(0xFF1E293B),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF334155), width: 1),
          ),
          color: const Color(0xFF1E293B),
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          elevation: 4,
          height: 68,
          indicatorColor: const Color(0xFF60A5FA).withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF60A5FA),
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            );
          }),
        ),
      ),

      home: MainNavigationScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleDarkMode: _toggleTheme,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const MainNavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  List<ReportItem> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  // Memuat data dari memori lokal HP (SharedPreferences)
  Future<void> _loadStoredData() async {
    final loaded = await StorageService.loadReports();
    setState(() {
      _reports = loaded.isNotEmpty ? loaded : List.from(initialReportData);
      _isLoading = false;
    });
  }

  void _saveToStorage() {
    StorageService.saveReports(_reports);
  }

  void _addNewReport(ReportItem newItem) {
    setState(() {
      _reports.insert(0, newItem);
      _currentIndex = 0; // Kembali ke feed beranda
    });
    _saveToStorage();
  }

  void _updateReportStatus(ReportItem updatedItem) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == updatedItem.id);
      if (index != -1) {
        _reports[index] = updatedItem;
      }
    });
    _saveToStorage();
  }

  void _toggleBookmark(ReportItem item) {
    setState(() {
      final index = _reports.indexWhere((r) => r.id == item.id);
      if (index != -1) {
        _reports[index].isBookmarked = !_reports[index].isBookmarked;
      }
    });
    _saveToStorage();
  }

  void _deleteReport(String id) {
    setState(() {
      _reports.removeWhere((r) => r.id == id);
    });
    _saveToStorage();
  }

  void _resetData() async {
    final resetList = await StorageService.resetReports();
    setState(() {
      _reports = resetList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> pages = [
      HomePage(
        reports: _reports,
        onAddReport: _addNewReport,
        onStatusChanged: _updateReportStatus,
        onToggleBookmark: _toggleBookmark,
        onDelete: _deleteReport,
      ),
      MyReportsPage(
        reports: _reports,
        onStatusChanged: _updateReportStatus,
        onToggleBookmark: _toggleBookmark,
        onDelete: _deleteReport,
        onNavigateToAdd: () {
          setState(() {
            _currentIndex = 2; // Pindah ke tab Buat Laporan
          });
        },
      ),
      AddReportPage(
        onAddReport: _addNewReport,
      ),
      AboutPage(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
        onResetData: _resetData,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_shared_outlined),
            selectedIcon: Icon(Icons.folder_shared_rounded),
            label: 'Laporan Saya',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Lapor',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}
