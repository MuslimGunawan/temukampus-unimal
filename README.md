# 🎓 TemuKampus UNIMAL

> **Sistem Informasi & Pelaporan Barang Hilang dan Temuan (*Lost & Found*) Terpadu di Lingkungan Universitas Malikussaleh**  
> Proyek Akhir Semester (UAS) Mata Kuliah **Pemrograman Mobile (Kelas A2)**  
> Jurusan Teknik Informatika, Fakultas Teknik, Universitas Malikussaleh.

---

## 📌 Latar Belakang Masalah
Aktivitas perkuliahan di lingkungan perguruan tinggi yang dinamis kerap diwarnai oleh tertinggal atau tercecernya barang berharga mahasiswa, seperti KTM, kunci motor, helm, charger laptop, hingga dompet di area kampus (Kampus Bukit Indah, Reuleuet, dan Cunda). 

Selama ini, penyebaran info barang hilang hanya mengandalkan status WhatsApp Story atau Instagram Story yang hilang dalam 24 jam dan cepat tenggelam di grup obrolan. **TemuKampus** hadir sebagai platform terpusat, real-time, transparan, dan aman untuk menjembatani mahasiswa yang kehilangan barang dengan mahasiswa penemu barang secara beradab dan bertanggung jawab.

---

## ✨ Fitur Utama (*Core Features*)

- 🔍 **Feed & Live Search**: Eksplorasi seluruh laporan barang hilang (*Lost*) dan ditemukan (*Found*) dengan pencarian instan berdasarkan judul, lokasi, atau rekomendasi tag (KTM, Kunci, Helm, Charger, dll.).
- 🏷️ **Multi-Filter & Status Kontras**: Filter interaktif berdasarkan lokasi kampus (Bukit Indah, Reuleuet, Cunda), status laporan, kategori barang, serta filter khusus untuk menyembunyikan barang yang sudah selesai/kembali.
- 📝 **Formulir Pelaporan Interaktif**: Pelaporan barang baru yang mudah, dilengkapi pemilihan tanggal (*DatePicker*), preset foto barang, dan validasi formulir yang ketat.
- 🔒 **Perlindungan Privasi & Keamanan**:
  - Nomor telepon otomatis disensor di ruang publik (format: `0822-••••-0340`) untuk mencegah spam dan penyalahgunaan kontak.
  - Otorisasi pelapor (*Ownership Authorization*): Pengunjung umum tidak dapat menutup/mengubah status laporan orang lain.
- 💬 **Integrasi WhatsApp Direct API**: Menghubungkan penemu dengan pemilik secara instan via `wa.me` dengan draf pesan otomatis yang telah terisi nama barang dan lokasi.
- 💾 **Penyimpanan Lokal Persisten**: Menggunakan `shared_preferences` untuk menyimpan data laporan secara lokal dan otomatis di perangkat pengguna.

---

## 🏗️ Arsitektur & Teknologi

- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.x / Material 3)
- **Language**: [Dart](https://dart.dev/)
- **State & Local Storage**: `StatefulWidget` & `shared_preferences`
- **External Integration**: `url_launcher` (WhatsApp Direct Link) & `intl` (Format Tanggal & Waktu)
- **Interactive Architecture**: Visualisasi diagram alur data dan arsitektur aplikasi tersedia di [docs/arsitektur_temukampus_unimal.html](docs/arsitektur_temukampus_unimal.html).

---

## 🚀 Panduan Memulai (*Getting Started*)

Ikuti langkah-langkah mudah berikut untuk mengkloning dan menjalankan proyek ini di laptop/komputer kamu:

### 1. Prasyarat (*Prerequisites*)
Pastikan kamu telah menginstal:
- [Git](https://git-scm.com/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.0 ke atas)
- Browser Google Chrome atau Emulator Android / HP Android fisik terhubung dengan mode USB Debugging.

### 2. Clone Repository
```bash
git clone https://github.com/MuslimGunawan/temukampus-unimal.git
cd temukampus-unimal
```

### 3. Unduh Dependensi Proyek
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
Untuk menjalankan di browser Google Chrome:
```bash
flutter run -d chrome
```
Atau jika ingin menjalankan di perangkat Android:
```bash
flutter run
```

### 5. Menjalankan Analisis & Unit Test
```bash
dart analyze
flutter test
```

---

## 👥 Tim Pengembang (Kelompok 6 - Kelas Pemrograman Mobile A2)

| Nama Mahasiswa | NIM | Peran Utama |
|---|---|---|
| **Muslim Gunawan** | **240170036** | *Lead Mobile Developer* |
| **Dio Tri Firnanda** | **240170052** | *UI/UX & Frontend Designer* |
| **Jihan Nur Alifah** | **240170057** | *System Analyst & Documentation* |
| **Nadin Rahmatika Piliang** | **240170079** | *Database & Content Management* |
| **Farid Deza Amin Nur Rasyid** | **240170231** | *Quality Assurance & Testing* |

**Dosen Pengampu**: **MUKTI QAMAL, ST., M.IT.**  
*Program Studi Teknik Informatika, Fakultas Teknik, Universitas Malikussaleh*

---

## 📄 Dokumentasi Tambahan
Dokumentasi lengkap proyek dapat dilihat pada folder `docs/`:
- [Laporan Akhir Proyek UAS (Markdown)](docs/LAPORAN_PROYEK_UAS_TEMUKAMPUS.md)
- [Laporan Format Word (.docx)](docs/Laporan_Proyek_UAS_TemuKampus_UNIMAL.docx)
- [Diagram Arsitektur Interaktif (HTML)](docs/arsitektur_temukampus_unimal.html)
