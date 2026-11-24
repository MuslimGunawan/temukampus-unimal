import 'package:flutter/material.dart';
import '../models/report_item.dart';
import '../data/sample_data.dart';

class AddReportPage extends StatefulWidget {
  final Function(ReportItem) onAddReport;

  const AddReportPage({super.key, required this.onAddReport});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();

  ReportType _selectedType = ReportType.lost;
  String _selectedCategory = 'Dokumen & Kartu';
  String _selectedCampus = 'Kampus Bukit Indah';
  DateTime _selectedDate = DateTime.now();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController(); // Kosong by default, diisi mandiri
  final _imageUrlController = TextEditingController();

  bool _obscurePin = true;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Dokumen & Kartu':
        return Icons.badge_outlined;
      case 'Kendaraan & Aksesoris':
        return Icons.sports_motorsports_outlined;
      case 'Elektronik & Gadget':
        return Icons.phone_android_outlined;
      case 'Dompet & Tas':
        return Icons.account_balance_wallet_outlined;
      case 'Pakaian & Buku':
        return Icons.menu_book_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final imgUrl = _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : null;

      final newItem = ReportItem(
        id: 'rpt-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        category: _selectedCategory,
        type: _selectedType,
        campus: _selectedCampus,
        specificLocation: _locationController.text.trim(),
        date: _selectedDate,
        description: _descriptionController.text.trim(),
        reporterName: _nameController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        secretPin: _pinController.text.trim(),
        icon: _getCategoryIcon(_selectedCategory),
        imageUrl: imgUrl,
        isMyReport: true, // Otomatis masuk ke "Laporan Saya"
      );

      // Simpan data ke state utama
      widget.onAddReport(newItem);

      // Bersihkan form secara menyeluruh (PIN kembali kosong)
      _titleController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _nameController.clear();
      _phoneController.clear();
      _pinController.clear();
      _imageUrlController.clear();
      _selectedDate = DateTime.now();

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Laporan berhasil dipublikasikan & tersimpan ke memori perangkat!',
          ),
          backgroundColor: Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredCampusList =
        campusList.where((c) => c != 'Semua Kampus').toList();
    final filteredCategoryList =
        categoryList.where((c) => c != 'Semua Kategori').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buat Laporan Baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            // Banner Intro Singkat
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.campaign_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Publikasikan barang hilang atau temuan Anda agar terhubung dengan civitas akademika UNIMAL.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===============================================================
            // KELOMPOK 1: JENIS LAPORAN (HILANG vs DITEMUKAN)
            // ===============================================================
            _buildCardGroup(
              title: '1. Jenis Laporan',
              icon: Icons.swap_horiz_rounded,
              isDark: isDark,
              child: SegmentedButton<ReportType>(
                segments: const [
                  ButtonSegment(
                    value: ReportType.lost,
                    label: Text('Barang Hilang'),
                    icon: Icon(Icons.search_rounded),
                  ),
                  ButtonSegment(
                    value: ReportType.found,
                    label: Text('Barang Ditemukan'),
                    icon: Icon(Icons.pan_tool_rounded),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<ReportType> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: _selectedType == ReportType.lost
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                  selectedForegroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ===============================================================
            // KELOMPOK 2: DETAIL INFORMASI BARANG
            // ===============================================================
            _buildCardGroup(
              title: '2. Informasi Barang',
              icon: Icons.info_outline_rounded,
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang *',
                      hintText: 'Contoh: Dompet Kulit Cokelat / KTM UNIMAL',
                      prefixIcon: Icon(Icons.title_rounded, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      if (val.trim().length < 3) {
                        return 'Nama barang minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Barang',
                      prefixIcon: Icon(Icons.category_rounded, size: 20),
                    ),
                    items: filteredCategoryList.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontSize: 13.5)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi & Ciri-Ciri Khusus *',
                      hintText:
                          'Warna, stiker khusus, goresan, isi barang, atau tanda unik lainnya...',
                      alignLabelWithHint: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Deskripsi wajib diisi';
                      }
                      if (val.trim().length < 10) {
                        return 'Deskripsi minimal 10 karakter agar mudah diidentifikasi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===============================================================
            // KELOMPOK 3: LOKASI & WAKTU KEJADIAN
            // ===============================================================
            _buildCardGroup(
              title: '3. Lokasi & Waktu Kejadian',
              icon: Icons.place_rounded,
              isDark: isDark,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCampus,
                    decoration: const InputDecoration(
                      labelText: 'Kampus UNIMAL',
                      prefixIcon: Icon(Icons.school_rounded, size: 20),
                    ),
                    items: filteredCampusList.map((campus) {
                      return DropdownMenuItem(
                        value: campus,
                        child: Text(campus, style: const TextStyle(fontSize: 13.5)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCampus = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Titik Spesifik Lokasi *',
                      hintText: 'Contoh: Parkiran Gedung FT / Musala Al-Bayan',
                      prefixIcon: Icon(Icons.location_on_rounded, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Titik lokasi spesifik wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_rounded, size: 20, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggal Kejadian',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===============================================================
            // KELOMPOK 4: FOTO BARANG (MANDIRI & BEBAS TEMPLATE)
            // ===============================================================
            _buildCardGroup(
              title: '4. Foto Barang (Opsional)',
              icon: Icons.photo_camera_rounded,
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Tautan URL Foto Barang',
                      hintText: 'https://...',
                      prefixIcon: const Icon(Icons.link_rounded, size: 20),
                      helperText: 'Opsional. Masukkan link gambar online jika ada foto bukti fisik.',
                      suffixIcon: _imageUrlController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                setState(() {
                                  _imageUrlController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  if (_imageUrlController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(
                              _imageUrlController.text.trim(),
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image_rounded, size: 24, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pratinjau foto barang berhasil dimuat.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===============================================================
            // KELOMPOK 5: IDENTITAS & KEAMANAN PELAPOR
            // ===============================================================
            _buildCardGroup(
              title: '5. Identitas & Privasi Pelapor',
              icon: Icons.security_rounded,
              isDark: isDark,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap Anda *',
                      hintText: 'Contoh: Muslim Gunawan',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama pelapor wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'No. WhatsApp *',
                      hintText: 'Contoh: 085260356561',
                      prefixIcon: Icon(Icons.phone_rounded, size: 20),
                      helperText: 'Nomor akan disamarkan di publik (0852-••••-6561)',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nomor telepon wajib diisi';
                      }
                      final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
                      if (clean.length < 9 || clean.length > 14) {
                        return 'Nomor HP tidak valid (9-14 digit)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: _obscurePin,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Buat PIN Keamanan Anda (4 Digit) *',
                      hintText: 'Ketik 4 digit angka pilihan Anda',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePin ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePin = !_obscurePin;
                          });
                        },
                      ),
                      helperText: 'PIN rahasia mandiri untuk otentikasi saat menutup laporan',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'PIN keamanan 4 digit wajib diisi sendiri';
                      }
                      final clean = val.trim();
                      if (clean.length != 4 || int.tryParse(clean) == null) {
                        return 'PIN harus tepat 4 digit angka';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Submit
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitForm,
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'Publikasikan Laporan Sekarang',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGroup({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
