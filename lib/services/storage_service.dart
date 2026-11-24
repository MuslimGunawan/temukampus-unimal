import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_item.dart';
import '../data/sample_data.dart';

class StorageService {
  static const String _reportsKey = 'temukampus_reports_v1';
  static const String _darkModeKey = 'temukampus_dark_mode_v1';

  // Memuat data laporan dari penyimpanan lokal HP / Web
  static Future<List<ReportItem>> loadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_reportsKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((item) => ReportItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback jika SharedPreferences belum terpasang atau saat hot restart web
    }
    // Jika belum ada data lokal atau fallback, gunakan data awal UNIMAL
    return List.from(initialReportData);
  }

  // Menyimpan seluruh daftar laporan ke memori HP / Web
  static Future<void> saveReports(List<ReportItem> reports) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(reports.map((r) => r.toJson()).toList());
      await prefs.setString(_reportsKey, encoded);
    } catch (_) {
      // Tangani exception jika browser memblokir storage
    }
  }

  // Reset data ke kondisi sampel bawaan kampus
  static Future<List<ReportItem>> resetReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_reportsKey);
    } catch (_) {}
    return List.from(initialReportData);
  }

  // Pengaturan Dark Mode
  static Future<bool> loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_darkModeKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDark);
    } catch (_) {}
  }
}
