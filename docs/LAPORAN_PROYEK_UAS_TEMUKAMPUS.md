# PROYEK MAHASISWA PEMROGRAMAN MOBILE
## SEMESTER GANJIL 2026

### LAPORAN AKHIR PROYEK UJIAN AKHIR SEMESTER (UAS)
**“PENGEMBANGAN APLIKASI TEMUKAMPUS: PUSAT INFORMASI DAN PELAPORAN BARANG HILANG (LOST AND FOUND) DI LINGKUNGAN UNIVERSITAS MALIKUSSALEH BERBASIS FLUTTER”**

---

**Disusun Oleh: Kelompok 6 (Kelas Pemrograman Mobile A2)**
1. **Muslim Gunawan (NIM: 240170036)** - *Lead Mobile Developer*
2. **Dio Tri Firnanda (NIM: 240170052)** - *UI/UX & Frontend Designer*
3. **Jihan Nur Alifah (NIM: 240170057)** - *System Analyst & Documentation*
4. **Nadin Rahmatika Piliang (NIM: 240170079)** - *Database & Content Management*
5. **Farid Deza Amin Nur Rasyid (NIM: 240170231)** - *Quality Assurance & Testing*

**Dosen Pengampu**: **MUKTI QAMAL, ST., M.IT.**  
**PROGRAM STUDI TEKNIK INFORMATIKA - FAKULTAS TEKNIK - UNIVERSITAS MALIKUSSALEH**

---

## BAB I. DESKRIPSI PERANGKAT LUNAK

### 1.1 Latar Belakang Masalah
Aktivitas perkuliahan di lingkungan perguruan tinggi yang dinamis dan padat kerap diwarnai oleh insiden tertinggal atau hilangnya barang-barang berharga mahasiswa dan staf. Di lingkungan Universitas Malikussaleh (UNIMAL), yang tersebar di beberapa lokasi kampus utama seperti Kampus Bukit Indah (Fakultas Teknik, Lab Komputer), Kampus Reuleuet (Gedung Rektorat dan Gedung Kuliah Terpadu), serta Kampus Cunda, mobilitas civitas akademika sangat tinggi.

Barang-barang seperti Kartu Tanda Mahasiswa (KTM), kunci sepeda motor di area parkiran, helm di musala, charger laptop di ruang kuliah, hingga dompet sering kali tertinggal atau tercecer. Hingga saat ini, penyebaran informasi terkait penemuan maupun pencarian barang hilang masih mengandalkan mekanisme konvensional yang tidak efisien, yaitu melalui unggahan status WhatsApp Story atau Instagram Story mahasiswa yang terbatas waktu penayangannya (hanya bertahan 24 jam) dan cepat tenggelam di grup percakapan. Akibatnya, barang temuan jarang sampai kembali kepada pemilik aslinya, serta menimbulkan celah penyalahgunaan oleh pihak yang tidak bertanggung jawab.

### 1.2 Definisi dan Solusi Perangkat Lunak (TemuKampus)
TemuKampus adalah aplikasi mobile berbasis Flutter dan Material Design 3 yang dirancang khusus sebagai sistem informasi terpusat pelaporan barang hilang (*Lost*) dan barang ditemukan (*Found*) di lingkungan Universitas Malikussaleh. Aplikasi ini menghubungkan mahasiswa yang kehilangan barang dengan mahasiswa penemu barang secara real-time, transparan, aman, dan beradab.

### 1.3 Manfaat bagi Orang Banyak
Sesuai dengan kriteria utama proyek mahasiswa, aplikasi TemuKampus memberikan manfaat nyata bagi masyarakat kampus, antara lain:
1. **Pusat Informasi Terstruktur**: Seluruh data barang hilang dan ditemukan tersimpan rapi dalam satu basis data terpusat yang dapat diakses kapan saja tanpa terhapus oleh batas waktu story 24 jam.
2. **Perlindungan Privasi Data Pribadi**: Nomor telepon pelapor disensor otomatis di ruang publik (format: `0822-••••-0340`) guna mencegah potensi kejahatan penipuan, spam, atau pelecehan kontak.
3. **Perlindungan Hak Pelapor (*Ownership Authorization*)**: Sistem memisahkan hak akses secara tegas. Pengunjung umum tidak dapat menutup laporan orang lain, sedangkan pelapor sah memegang kendali penuh untuk menandai status selesai atau menghapus laporan.
4. **Budaya Kejujuran dan Integritas Kampus**: Memfasilitasi serah terima barang secara aman melalui panduan posko resmi di kampus (Pos Satpam Fakultas Teknik Bukit Indah, Musala Al-Bayan, atau Gedung Rektorat).

---

## BAB II. KEBUTUHAN DAN SPESIFIKASI PERANGKAT LUNAK

### 2.1 Kebutuhan Fungsional (*Functional Requirements*)

| Kode | Nama Fitur | Deskripsi Fungsional |
|---|---|---|
| **FR-01** | Feed & Eksplorasi Laporan | Menampilkan seluruh daftar barang hilang dan ditemukan lengkap dengan thumbnail foto, badge status kontras, dan detail lokasi kampus. |
| **FR-02** | Pencarian Cepat (*Live Search*) | Menyaring daftar barang secara instan berdasarkan kata kunci judul, deskripsi, atau tombol chip rekomendasi (KTM, Kunci, Helm, dll.). |
| **FR-03** | Penyaringan Multi-Kategori | Memfilter barang berdasarkan lokasi kampus (Bukit Indah, Reuleuet, Cunda), status, kategori barang, dan opsi sembunyikan barang selesai. |
| **FR-04** | Publikasi Laporan Baru | Formulir interaktif pelaporan barang hilang/ditemukan dilengkapi pemilihan tanggal (*DatePicker*), preset foto barang, dan validasi data ketat. |
| **FR-05** | Integrasi WhatsApp Terarah | Menghubungkan penemu dengan pemilik melalui WhatsApp API resmi (`wa.me`) dengan draf pesan otomatis yang telah terisi nama barang. |
| **FR-06** | Pusat Kendali 'Laporan Saya' | Tab khusus bagi pelapor untuk memantau status laporan aktif, menandai barang sudah kembali, atau menghapus postingan. |
| **FR-07** | Bookmark / Simpan Favorit | Pengguna dapat menyimpan barang yang sedang dipantau ke dalam daftar tersimpan dengan menekan ikon penanda. |
| **FR-08** | Penyimpanan Lokal Permanen | Data laporan, status penyelesaian, dan pengaturan tema tersimpan permanen di memori lokal perangkat (*SharedPreferences*). |

### 2.2 Kebutuhan Non-Fungsional (*Non-Functional Requirements*)
1. **Kinerja (*Performance*)**: Waktu render daftar laporan di bawah 1 detik dengan menggunakan `ListView.builder` on-demand rendering.
2. **Kemudahan Penggunaan (*Usability*)**: Antarmuka modern Material 3 dengan perbedaan visual yang sangat tegas antara barang aktif (garis tepi menyala) dan barang selesai (efek grayscale dan stempel diagonal).
3. **Keamanan & Privasi**: Sensor otomatis nomor telepon publik dan proteksi wewenang penutupan status laporan.
4. **Kompatibilitas Perangkat**: Mendukung sistem operasi Android dan Web browser Chrome dengan mode terang (*Light Mode*) dan mode gelap (*Dark Mode*).

---

## BAB III. RANCANGAN SISTEM

### 3.1 Diagram Use Case (Peran & Interaksi Pengguna)
Sistem TemuKampus memiliki dua sudut pandang interaksi utama:
- **Aktor Pelapor (Pemilik Laporan)**:
  - Membuka formulir dan mengunggah laporan baru (barang hilang / ditemukan).
  - Menentukan PIN rahasia keamanan laporan.
  - Memantau laporan di tab 'Laporan Saya'.
  - Menandai status 'Selesai / Sudah Dikembalikan'.
  - Menghapus laporan secara permanen.
- **Aktor Pengunjung / Penemu / Pengklaim**:
  - Menjelajahi katalog laporan di Beranda.
  - Menggunakan fitur pencarian kata kunci dan chip cepat.
  - Membuka detail barang dan membaca panduan aman serah terima UNIMAL.
  - Menghubungi kontak pelapor secara langsung via chat WhatsApp terenkripsi.
  - Menyimpan barang ke daftar favorit (Bookmark).

### 3.2 Rancangan Alur Kerja Sistem (Flowchart Logika)
1. **Alur Pelaporan Barang**:
   `[Mulai] -> [Pilih Jenis: Hilang/Ditemukan] -> [Input Judul, Kategori, Kampus, Lokasi] -> [Pilih Tanggal & Foto] -> [Input Kontak & PIN 1234] -> [Validasi Form] -> [Simpan ke StorageService] -> [Tampil di Beranda & Laporan Saya] -> [Selesai]`
2. **Alur Klaim / Hubungi Pelapor**:
   `[Mulai] -> [Buka Detail Barang] -> [Cek Status Barang] -> [Jika Selesai: Tampilkan Banner Transaksi Ditutup] -> [Jika Aktif: Tampilkan Tombol Hubungi WhatsApp] -> [Tampilkan Panduan Aman UNIMAL] -> [Buka WhatsApp Resmi] -> [Selesai]`
3. **Alur Penyelesaian / Auto-Archive**:
   `[Mulai] -> [Pelapor Membuka Laporan Sendiri] -> [Klik 'Tandai Selesai'] -> [Status Berubah isResolved=true & Set resolvedAt=Now] -> [Kartu Menjadi Dimmed + Stempel SUDAH KEMBALI] -> [Otomatis Masuk Arsip Selesai] -> [Selesai]`

---

## BAB IV. STRUKTUR PROGRAM & ARSITEKTUR KODE

Arsitektur program TemuKampus menerapkan pendekatan Clean Architecture yang memisahkan tanggung jawab antara Data, Model, Komponen Antarmuka (Widgets), Layanan (Services), dan Halaman Layar (Pages):

```text
temu_kampus/lib/
├── models/
│   └── report_item.dart         <- Entitas Model data laporan, JSON serialization & phone masking
├── services/
│   └── storage_service.dart     <- Layanan SharedPreferences (Load/Save/Reset data lokal & Dark Mode)
├── data/
│   └── sample_data.dart         <- Master data awal kampus UNIMAL & repositori preset foto
├── widgets/
│   └── report_card.dart         <- Komponen kartu visual (Extract Widget) dengan stempel status & glow accent
├── pages/
│   ├── home_page.dart           <- Dashboard Beranda, pencarian instan, chip cepat, dan 5 filter status
│   ├── detail_page.dart         <- Layar detail barang, panduan keamanan serah terima, dan WhatsApp launcher
│   ├── my_reports_page.dart     <- Pusat kendali laporan pribadi milik pengguna
│   ├── add_report_page.dart     <- Formulir publikasi laporan baru, pemilih foto, dan validasi data
│   └── about_page.dart          <- Halaman civitas akademika, kelompok 6, dosen pengampu, dan switch tema
└── main.dart                    <- Titik masuk aplikasi, inisialisasi tema Material 3, dan navigasi 4 tab
```

---

## BAB V. KODE SUMBER PROGRAM (SOURCE CODE)

Seluruh kode sumber lengkap terlampir pada repositori proyek di folder `temu_kampus/lib/` dan siap dijalankan secara native pada perangkat Android maupun browser Google Chrome.
