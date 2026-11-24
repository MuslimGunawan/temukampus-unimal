import 'package:flutter/material.dart';
import '../models/report_item.dart';

List<ReportItem> initialReportData = [
  ReportItem(
    id: 'rpt-001',
    title: 'KTM Mahasiswa Teknik Informatika (NIM 2401700xx)',
    category: 'Dokumen & Kartu',
    type: ReportType.found,
    campus: 'Kampus Bukit Indah',
    specificLocation: 'Meja Depan Lab Komputer 5 (Lantai 3)',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    description:
        'Ditemukan sebuah Kartu Tanda Mahasiswa (KTM) Unimal saat praktikum selesai. Kondisi masih sangat mulus dengan cover plastik transparan.',
    reporterName: 'Dio Tri Firnanda',
    contactPhone: '082277530340',
    secretPin: '1234',
    icon: Icons.badge_outlined,
    imageUrl:
        'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=600&auto=format&fit=crop',
    isResolved: false,
    isMyReport: false,
    isBookmarked: false,
  ),
  ReportItem(
    id: 'rpt-002',
    title: 'Helm KYT RC Seven Hitam Doff',
    category: 'Kendaraan & Aksesoris',
    type: ReportType.lost,
    campus: 'Kampus Bukit Indah',
    specificLocation: 'Parkiran Utama Depan Gedung Fakultas Teknik',
    date: DateTime.now().subtract(const Duration(hours: 7)),
    description:
        'Hilang helm KYT fullface warna hitam doff ukuran L. Ciri khusus ada stiker logo UNIMAL di visor sebelah kanan dan sedikit goresan di bagian belakang.',
    reporterName: 'Farid Deza',
    contactPhone: '085260356561',
    secretPin: '1234',
    icon: Icons.sports_motorsports_outlined,
    imageUrl:
        'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=600&auto=format&fit=crop',
    isResolved: false,
    isMyReport: false,
    isBookmarked: true,
  ),
  ReportItem(
    id: 'rpt-003',
    title: 'Kunci Motor Honda Vario + Gantungan Kulit Cokelat',
    category: 'Kendaraan & Aksesoris',
    type: ReportType.found,
    campus: 'Kampus Bukit Indah',
    specificLocation: 'Tempat Wudhu Musala Al-Bayan Fakultas Teknik',
    date: DateTime.now().subtract(const Duration(days: 1)),
    description:
        'Tertinggal di rak tempat wudhu. Kunci motor kontak warna hitam dengan gantungan kulit cokelat bertuliskan "Genuine Parts". Bagi yang merasa memiliki silakan hubungi saya.',
    reporterName: 'Nadin Rahmatika',
    contactPhone: '082165404956',
    secretPin: '1234',
    icon: Icons.key_outlined,
    imageUrl:
        'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop',
    isResolved: false,
    isMyReport: false,
    isBookmarked: false,
  ),
  ReportItem(
    id: 'rpt-004',
    title: 'Charger Laptop Type-C 65W (Merk Baseus)',
    category: 'Elektronik & Gadget',
    type: ReportType.lost,
    campus: 'Kampus Reuleuet',
    specificLocation: 'Gedung Kuliah Terpadu Ruang 204',
    date: DateTime.now().subtract(const Duration(days: 2)),
    description:
        'Lupa dicabut setelah presentasi mata kuliah. Kepala charger warna hitam ada kabel braided sepanjang 2 meter.',
    reporterName: 'Jihan Nur Alifah',
    contactPhone: '081396889734',
    secretPin: '1234',
    icon: Icons.electrical_services_outlined,
    imageUrl:
        'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&auto=format&fit=crop',
    isResolved: true,
    resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
    isMyReport: false,
    isBookmarked: false,
  ),
  ReportItem(
    id: 'rpt-005',
    title: 'Dompet Kulit Cokelat (Isi KTP & Uang Saku)',
    category: 'Dompet & Tas',
    type: ReportType.found,
    campus: 'Kampus Cunda',
    specificLocation: 'Kantin Belakang Dekat Perpustakaan Cabang',
    date: DateTime.now().subtract(const Duration(days: 3)),
    description:
        'Ditemukan dompet lipat warna cokelat tua. Di dalamnya ada KTP beralamat di Lhokseumawe dan sedikit uang saku. Barang sudah diamankan di pos satpam.',
    reporterName: 'Muslim Gunawan',
    contactPhone: '085766322275',
    secretPin: '1234',
    icon: Icons.account_balance_wallet_outlined,
    imageUrl:
        'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop',
    isResolved: false,
    isMyReport: true,
    isBookmarked: true,
  ),
];

final List<String> campusList = [
  'Semua Kampus',
  'Kampus Bukit Indah',
  'Kampus Reuleuet',
  'Kampus Cunda',
];

final List<String> categoryList = [
  'Semua Kategori',
  'Dokumen & Kartu',
  'Kendaraan & Aksesoris',
  'Elektronik & Gadget',
  'Dompet & Tas',
  'Pakaian & Buku',
  'Lain-lain',
];

// Preset Gambar Cepat untuk Form Tambah Laporan
final Map<String, String> presetItemImages = {
  'Kartu / Dokumen':
      'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=600&auto=format&fit=crop',
  'Helm Motor':
      'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=600&auto=format&fit=crop',
  'Kunci Kendaraan':
      'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop',
  'Charger / Gadget':
      'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&auto=format&fit=crop',
  'Dompet / Uang':
      'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop',
  'Buku / Catatan':
      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop',
};
