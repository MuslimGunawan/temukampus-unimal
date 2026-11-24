import 'package:flutter/material.dart';

enum ReportType { lost, found }

class ReportItem {
  final String id;
  final String title;
  final String category;
  final ReportType type;
  final String campus;
  final String specificLocation;
  final DateTime date;
  final String description;
  final String reporterName;
  final String contactPhone;
  final String secretPin;
  final IconData icon;
  final String? imageUrl;
  bool isResolved;
  DateTime? resolvedAt; // Tanggal kapan laporan diselesaikan (untuk auto-archive)
  bool isMyReport;
  bool isBookmarked;
  bool isFlagged;
  String? flagReason;

  ReportItem({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.campus,
    required this.specificLocation,
    required this.date,
    required this.description,
    required this.reporterName,
    required this.contactPhone,
    required this.secretPin,
    required this.icon,
    this.imageUrl,
    this.isResolved = false,
    this.resolvedAt,
    this.isMyReport = false,
    this.isBookmarked = false,
    this.isFlagged = false,
    this.flagReason,
  });

  String get typeLabel => type == ReportType.lost ? 'HILANG' : 'DITEMUKAN';

  Color get typeColor =>
      type == ReportType.lost ? Colors.red.shade700 : Colors.teal.shade700;

  Color get typeBackgroundColor =>
      type == ReportType.lost ? Colors.red.shade50 : Colors.teal.shade50;

  // Masking nomor HP demi privasi (Contoh: 0822-••••-0340)
  String get maskedPhone {
    final clean = contactPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length >= 8) {
      final prefix = clean.substring(0, 4);
      final suffix = clean.substring(clean.length - 4);
      return '$prefix-••••-$suffix';
    }
    return '08••-••••-••••';
  }

  // Menghitung berapa hari sejak barang diselesaikan
  int get daysSinceResolved {
    if (resolvedAt == null) return 0;
    return DateTime.now().difference(resolvedAt!).inDays;
  }

  static IconData getCategoryIcon(String cat) {
    switch (cat) {
      case 'Dokumen & Kartu':
        return Icons.badge_outlined;
      case 'Kendaraan & Aksesoris':
        return Icons.sports_motorsports_outlined;
      case 'Elektronik & Gadget':
        return Icons.electrical_services_outlined;
      case 'Dompet & Tas':
        return Icons.account_balance_wallet_outlined;
      case 'Pakaian & Buku':
        return Icons.menu_book_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // Serialisasi JSON untuk SharedPreferences (Penyimpanan Lokal Permanen)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'type': type == ReportType.lost ? 'lost' : 'found',
      'campus': campus,
      'specificLocation': specificLocation,
      'date': date.toIso8601String(),
      'description': description,
      'reporterName': reporterName,
      'contactPhone': contactPhone,
      'secretPin': secretPin,
      'imageUrl': imageUrl,
      'isResolved': isResolved,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'isMyReport': isMyReport,
      'isBookmarked': isBookmarked,
      'isFlagged': isFlagged,
      'flagReason': flagReason,
    };
  }

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] as String? ?? 'Lain-lain';
    final resDateStr = json['resolvedAt'] as String?;

    return ReportItem(
      id: json['id'] as String,
      title: json['title'] as String,
      category: cat,
      type: json['type'] == 'lost' ? ReportType.lost : ReportType.found,
      campus: json['campus'] as String,
      specificLocation: json['specificLocation'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      reporterName: json['reporterName'] as String,
      contactPhone: json['contactPhone'] as String,
      secretPin: json['secretPin'] as String? ?? '1234',
      icon: getCategoryIcon(cat),
      imageUrl: json['imageUrl'] as String?,
      isResolved: json['isResolved'] as bool? ?? false,
      resolvedAt: resDateStr != null ? DateTime.tryParse(resDateStr) : null,
      isMyReport: json['isMyReport'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isFlagged: json['isFlagged'] as bool? ?? false,
      flagReason: json['flagReason'] as String?,
    );
  }
}
