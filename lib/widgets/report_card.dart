import 'package:flutter/material.dart';
import '../models/report_item.dart';

class ReportCard extends StatelessWidget {
  final ReportItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  const ReportCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleBookmark,
  });

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isResolved = item.isResolved;

    final typeColor = item.type == ReportType.lost
        ? const Color(0xFFEF4444) // Coral Red Neon
        : const Color(0xFF10B981); // Emerald Green Neon

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        // ===================================================================
        // 1. EFEK GLOW (MENYALA UNTUK AKTIF, MATI UNTUK SELESAI)
        // ===================================================================
        boxShadow: isResolved
            ? [] // Barang selesai tidak menyala (redup/padam)
            : [
                // Outer Ambient Glow
                BoxShadow(
                  color: typeColor.withValues(alpha: isDark ? 0.38 : 0.22),
                  blurRadius: 18,
                  spreadRadius: 1.5,
                  offset: const Offset(0, 4),
                ),
                // Inner Core Glow
                BoxShadow(
                  color: typeColor.withValues(alpha: isDark ? 0.22 : 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          // =================================================================
          // 2. OUTLINE TEGAS: MENYALA BERWARNA JIKA AKTIF, ABU-ABU JIKA SELESAI
          // =================================================================
          border: Border.all(
            color: isResolved
                ? (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1))
                : typeColor.withValues(alpha: isDark ? 0.85 : 0.70),
            width: isResolved ? 1.0 : 2.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: isResolved
                ? (isDark ? const Color(0xFF182234) : const Color(0xFFF1F5F9))
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            child: InkWell(
              onTap: onTap,
              child: Opacity(
                opacity: isResolved ? 0.82 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =======================================================
                    // HEADER STATUS BANNER
                    // =======================================================
                    if (isResolved)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '✓ SELESAI • SUDAH KEMBALI KE PEMILIK',
                              style: TextStyle(
                                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Glowing Accent Line Top untuk Laporan Aktif
                      Container(
                        height: 3.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              typeColor.withValues(alpha: 0.3),
                              typeColor,
                              typeColor.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),

                    // =======================================================
                    // FOTO / ILUSTRASI DENGAN FLOATING BADGE
                    // =======================================================
                    Stack(
                      children: [
                        SizedBox(
                          height: 145,
                          width: double.infinity,
                          child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                              ? ColorFiltered(
                                  colorFilter: isResolved
                                      ? const ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        )
                                      : const ColorFilter.mode(
                                          Colors.transparent,
                                          BlendMode.multiply,
                                        ),
                                  child: Image.network(
                                    item.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        _buildPlaceholder(typeColor, isDark, isResolved),
                                  ),
                                )
                              : _buildPlaceholder(typeColor, isDark, isResolved),
                        ),

                        // Overlay Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.40),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Floating Badge Kiri: Status Menyala
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isResolved ? Colors.grey.shade700 : typeColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isResolved
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: typeColor.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isResolved
                                      ? Icons.done_all_rounded
                                      : (item.type == ReportType.lost
                                          ? Icons.search_rounded
                                          : Icons.pan_tool_rounded),
                                  size: 13,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isResolved
                                      ? 'ARSIP SELESAI'
                                      : '● ${item.typeLabel.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Floating Badge Kanan: Bookmark
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onToggleBookmark,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Icon(
                                  item.isBookmarked
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  size: 18,
                                  color: item.isBookmarked
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Floating Badge Bawah: Kampus UNIMAL
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.school_rounded, size: 12, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  item.campus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // =======================================================
                    // BODY KARTU: DETAIL INFORMASI
                    // =======================================================
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kategori & Badge Laporan Anda
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.icon,
                                      size: 12,
                                      color: isDark
                                          ? const Color(0xFF93C5FD)
                                          : const Color(0xFF2563EB),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? const Color(0xFF93C5FD)
                                            : const Color(0xFF1D4ED8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item.isFlagged) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.warning_amber_rounded, size: 11, color: Color(0xFFDC2626)),
                                      SizedBox(width: 3),
                                      Text(
                                        'Dicurigai',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB91C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (item.isMyReport) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Laporan Anda',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Judul Barang
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: isResolved
                                  ? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))
                                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
                              decoration: isResolved ? TextDecoration.lineThrough : null,
                              decorationColor: isDark ? Colors.white54 : Colors.black54,
                              decorationThickness: 2,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Titik Lokasi
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.place_rounded,
                                size: 15,
                                color: isResolved
                                    ? Colors.grey
                                    : const Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.specificLocation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          const Divider(height: 1, thickness: 0.8),
                          const SizedBox(height: 10),

                          // Footer: Pelapor & Tanggal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                    child: Text(
                                      item.reporterName.isNotEmpty
                                          ? item.reporterName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    item.isMyReport ? 'Anda' : item.reporterName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 13,
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(item.date),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Color accentColor, bool isDark, bool isResolved) {
    final effectiveColor = isResolved ? Colors.grey : accentColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [effectiveColor.withValues(alpha: 0.12), effectiveColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon,
            size: 38,
            color: effectiveColor,
          ),
        ),
      ),
    );
  }
}
