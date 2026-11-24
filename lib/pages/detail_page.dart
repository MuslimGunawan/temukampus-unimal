import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/report_item.dart';

class DetailPage extends StatefulWidget {
  final ReportItem item;
  final Function(ReportItem) onStatusChanged;
  final Function(ReportItem) onToggleBookmark;
  final Function(String id)? onDelete;

  const DetailPage({
    super.key,
    required this.item,
    required this.onStatusChanged,
    required this.onToggleBookmark,
    this.onDelete,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ReportItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  String _formatDateFull(DateTime dt) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _getGeneratedWhatsAppMessage() {
    return _currentItem.type == ReportType.lost
        ? 'Halo ${_currentItem.reporterName}, saya melihat laporan barang hilang Anda ("${_currentItem.title}") di aplikasi TemuKampus UNIMAL. Saya ingin mengabarkan informasi terkait barang tersebut.'
        : 'Halo ${_currentItem.reporterName}, saya melihat laporan barang ditemukan ("${_currentItem.title}") di aplikasi TemuKampus UNIMAL. Saya ingin mengonfirmasi bahwa itu barang saya.';
  }

  String _getCleanWhatsAppNumber() {
    var cleanNumber = _currentItem.contactPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '62${cleanNumber.substring(1)}';
    } else if (cleanNumber.startsWith('8')) {
      cleanNumber = '62$cleanNumber';
    }
    return cleanNumber;
  }

  void _showWhatsAppSheet() {
    final cleanPhone = _getCleanWhatsAppNumber();
    final message = _getGeneratedWhatsAppMessage();
    final waUrl = 'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Header Sheet
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      color: Color(0xFF25D366),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hubungi ${_currentItem.reporterName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'No. Terproteksi: ${_currentItem.maskedPhone}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Kotak Panduan Aman UNIMAL Mandiri (Tanpa Server)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.shield_rounded, color: Color(0xFFB45309), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'SOP Keamanan Serah Terima UNIMAL:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1. Titik Temu Wajib: Pos Satpam Utama FT Bukit Indah, Pos Satpam Reuleuet, atau Pos Satpam Cunda.\n2. Verifikasi Fisik KTM: Wajib saling periksa kartu KTM asli pihak kedua sebelum serah terima.\n3. Jangan Pergi Sendirian: Selalu ajak teman kampus dan tolak jika diajak bertemu di kos-kosan atau malam hari.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF92400E),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Opsi 1: Buka WhatsApp Langsung
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    await launchUrl(
                      Uri.parse(waUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (_) {
                    // Fallback jika diblokir browser
                    await launchUrl(
                      Uri.parse(waUrl),
                      mode: LaunchMode.platformDefault,
                      webOnlyWindowName: '_blank',
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text(
                  'Buka Chat WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),

              // Opsi 2: Salin Format Pesan
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Draf pesan konfirmasi berhasil disalin!'),
                      backgroundColor: Color(0xFF1E3A8A),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Salin Draf Pesan Chat'),
              ),
              const SizedBox(height: 10),

              // Opsi 3: Salin Nomor HP Asli
              TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _currentItem.contactPhone));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nomor kontak berhasil disalin ke clipboard!'),
                      backgroundColor: Color(0xFF0D9488),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: const Text('Salin Nomor Telepon'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _toggleResolveStatus() {
    setState(() {
      _currentItem.isResolved = !_currentItem.isResolved;
      if (_currentItem.isResolved) {
        _currentItem.resolvedAt = DateTime.now();
      } else {
        _currentItem.resolvedAt = null;
      }
    });
    widget.onStatusChanged(_currentItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentItem.isResolved
              ? 'Laporan ditandai SELESAI / SUDAH KEMBALI'
              : 'Status laporan diaktifkan kembali',
        ),
        backgroundColor:
            _currentItem.isResolved ? const Color(0xFF0F766E) : const Color(0xFFD97706),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _currentItem.isBookmarked = !_currentItem.isBookmarked;
    });
    widget.onToggleBookmark(_currentItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentItem.isBookmarked
              ? 'Barang disimpan ke daftar favorit Anda'
              : 'Barang dihapus dari daftar favorit',
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_forever_rounded, size: 36, color: Color(0xFFEF4444)),
        title: const Text('Hapus Laporan?'),
        content: const Text(
          'Laporan ini akan dihapus secara permanen dari sistem TemuKampus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              if (widget.onDelete != null) {
                widget.onDelete!(_currentItem.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan berhasil dihapus'),
                  backgroundColor: Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }

  void _reportSuspiciousDialog() {
    String selectedReason = 'Meminta transfer uang / imbalan mencurigakan';
    final reasons = [
      'Meminta transfer uang / imbalan mencurigakan',
      'Mengajak bertemu di lokasi sepi / luar kampus',
      'Nomor telepon fiktif / tidak dapat dihubungi',
      'Mengaku pemilik tanpa bukti fisik KTM',
      'Indikasi laporan palsu / iseng',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            icon: const Icon(Icons.shield_outlined, size: 36, color: Color(0xFFEF4444)),
            title: const Text(
              'Laporkan Laporan Mencurigakan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bantu jaga keamanan sesama mahasiswa UNIMAL dari potensi penipuan atau jebakan fisik.',
                  style: TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Alasan Pelaporan:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: selectedReason,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: reasons.map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDlgState(() => selectedReason = val);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _currentItem.isFlagged = true;
                    _currentItem.flagReason = selectedReason;
                  });
                  widget.onStatusChanged(_currentItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Laporan telah ditandai mencurigakan. Peringatan keamanan telah diaktifkan.'),
                      backgroundColor: Color(0xFFEF4444),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Kirim Laporan'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isResolved = _currentItem.isResolved;

    final typeColor = _currentItem.type == ReportType.lost
        ? const Color(0xFFEF4444)
        : const Color(0xFF10B981);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Laporan Barang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentItem.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _currentItem.isBookmarked ? const Color(0xFFF59E0B) : null,
            ),
            tooltip: _currentItem.isBookmarked ? 'Tersimpan' : 'Simpan Barang',
            onPressed: _toggleBookmark,
          ),
          if (!_currentItem.isMyReport)
            IconButton(
              icon: Icon(
                _currentItem.isFlagged ? Icons.report_rounded : Icons.report_gmailerrorred_rounded,
                color: _currentItem.isFlagged ? const Color(0xFFEF4444) : null,
              ),
              tooltip: 'Laporkan Laporan Mencurigakan',
              onPressed: _reportSuspiciousDialog,
            ),
          if (_currentItem.isMyReport && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
              tooltip: 'Hapus Laporan',
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===============================================================
            // 1. HERO HEADER IMAGE / ILUSTRASI
            // ===============================================================
            if (_currentItem.imageUrl != null && _currentItem.imageUrl!.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    height: 230,
                    width: double.infinity,
                    child: ColorFiltered(
                      colorFilter: isResolved
                          ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                          : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                      child: Image.network(
                        _currentItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => _buildPlaceholderHeader(typeColor, isDark),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              _buildPlaceholderHeader(typeColor, isDark),

            // ===============================================================
            // 2. KONTEN DETAIL BARANG
            // ===============================================================
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BANNER PERINGATAN LAPORAN MENCURIGAKAN (JIKA DI-FLAG)
                  if (_currentItem.isFlagged)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 26),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PERINGATAN: Laporan Sedang Ditinjau',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF991B1B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Laporan ini dicurigai (${_currentItem.flagReason ?? "Diduga fiktif"}). Jangan bertransaksi atau bertemu tanpa kehadiran petugas Satpam UNIMAL.',
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFFB91C1C), height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Status Badge & Kategori
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isResolved ? const Color(0xFF0F766E) : typeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isResolved
                                  ? Icons.check_circle_rounded
                                  : (_currentItem.type == ReportType.lost
                                      ? Icons.search_rounded
                                      : Icons.pan_tool_rounded),
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isResolved
                                  ? 'SUDAH KEMBALI'
                                  : 'STATUS: ${_currentItem.typeLabel.toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _currentItem.category,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                      if (_currentItem.isMyReport) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Laporan Anda',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Judul Barang
                  Text(
                    _currentItem.title,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      decoration: isResolved ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // CARD 1: DESKRIPSI & CIRI KHUSUS
                  _buildSectionHeader('Deskripsi & Ciri-Ciri Khusus', Icons.notes_rounded, isDark),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      _currentItem.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CARD 2: LOKASI & WAKTU KEJADIAN
                  _buildSectionHeader('Informasi Lokasi & Waktu', Icons.place_rounded, isDark),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.school_rounded,
                          iconColor: const Color(0xFF2563EB),
                          title: 'Kampus UNIMAL',
                          value: _currentItem.campus,
                          isDark: isDark,
                        ),
                        Divider(
                          height: 20,
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        ),
                        _buildInfoRow(
                          icon: Icons.location_on_rounded,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Titik Spesifik',
                          value: _currentItem.specificLocation,
                          isDark: isDark,
                        ),
                        Divider(
                          height: 20,
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        ),
                        _buildInfoRow(
                          icon: Icons.event_rounded,
                          iconColor: const Color(0xFF10B981),
                          title: 'Tanggal Kejadian',
                          value: _formatDateFull(_currentItem.date),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CARD 3: KONTAK PELAPOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('Kontak Pelapor', Icons.person_rounded, isDark),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.shield_rounded, size: 12, color: Color(0xFF15803D)),
                            SizedBox(width: 4),
                            Text(
                              'Privasi Terlindungi',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.12),
                          child: Text(
                            _currentItem.reporterName.isNotEmpty
                                ? _currentItem.reporterName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentItem.isMyReport
                                    ? '${_currentItem.reporterName} (Anda Sendiri)'
                                    : _currentItem.reporterName,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currentItem.maskedPhone,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_currentItem.isMyReport && !_currentItem.isResolved)
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _showWhatsAppSheet,
                            icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                            label: const Text('Chat WA', style: TextStyle(fontSize: 12.5)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // =========================================================
                  // 4. ACTION BAR / POV LOGIC
                  // =========================================================

                  // KASUS A: LAPORAN SUDAH SELESAI
                  if (isResolved) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Barang Berhasil Dikembalikan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Laporan ini telah ditutup secara resmi. Fitur klaim dan kontak pelapor telah dinonaktifkan.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF15803D),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_currentItem.isMyReport) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _toggleResolveStatus,
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Buka Kembali Laporan Ini'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ]

                  // KASUS B: LAPORAN AKTIF & DILIHAT OLEH PELAPOR SENDIRI (POV PELAPOR)
                  else if (_currentItem.isMyReport) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.admin_panel_settings_rounded,
                              color: Color(0xFF2563EB), size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Anda adalah pelapor barang ini. Anda dapat menandai barang sudah kembali atau menghapus laporan sewaktu-waktu.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    FilledButton.icon(
                      onPressed: _toggleResolveStatus,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Tandai Barang Sudah Kembali / Selesai'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                      label: const Text('Hapus Laporan Ini'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ]

                  // KASUS C: LAPORAN AKTIF & DILIHAT OLEH PENGUNJUNG UMUM (POV PENGUNJUNG)
                  else ...[
                    FilledButton.icon(
                      onPressed: _showWhatsAppSheet,
                      icon: const Icon(Icons.chat_bubble_rounded),
                      label: Text(
                        _currentItem.type == ReportType.lost
                            ? 'Saya Menemukan Barang Ini'
                            : 'Ini Barang Saya / Ajukan Klaim',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderHeader(Color accentColor, bool isDark) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [accentColor.withValues(alpha: 0.15), accentColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _currentItem.icon,
            size: 54,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
