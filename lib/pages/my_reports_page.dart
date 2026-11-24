import 'package:flutter/material.dart';
import '../models/report_item.dart';
import '../widgets/report_card.dart';
import 'detail_page.dart';

class MyReportsPage extends StatelessWidget {
  final List<ReportItem> reports;
  final Function(ReportItem) onStatusChanged;
  final Function(ReportItem) onToggleBookmark;
  final Function(String id) onDelete;
  final VoidCallback onNavigateToAdd;

  const MyReportsPage({
    super.key,
    required this.reports,
    required this.onStatusChanged,
    required this.onToggleBookmark,
    required this.onDelete,
    required this.onNavigateToAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final myReports = reports.where((item) => item.isMyReport).toList();
    final activeCount = myReports.where((item) => !item.isResolved).length;
    final resolvedCount = myReports.where((item) => item.isResolved).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          // Banner Profil Pelapor
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFF8FAFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF1E3A8A),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pusat Kendali Laporan Anda',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pantau proses pencarian & konfirmasi pengembalian barang',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mini Statistik 2 Kolom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$activeCount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Masih Aktif',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$resolvedCount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Sudah Selesai',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // List Laporan Saya
          Expanded(
            child: myReports.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.folder_open_rounded,
                              size: 54,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum Ada Laporan yang Dibuat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Barang hilang atau ditemukan yang Anda laporkan akan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                            ),
                            onPressed: onNavigateToAdd,
                            icon: const Icon(Icons.add_circle_rounded),
                            label: const Text('Buat Laporan Sekarang'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                    itemCount: myReports.length,
                    itemBuilder: (context, index) {
                      final item = myReports[index];
                      return ReportCard(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DetailPage(
                                item: item,
                                onStatusChanged: onStatusChanged,
                                onToggleBookmark: onToggleBookmark,
                                onDelete: onDelete,
                              ),
                            ),
                          );
                        },
                        onToggleBookmark: () => onToggleBookmark(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
