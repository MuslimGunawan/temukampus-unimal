import 'package:flutter/material.dart';
import '../models/report_item.dart';
import '../data/sample_data.dart';
import '../widgets/report_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final List<ReportItem> reports;
  final Function(ReportItem) onAddReport;
  final Function(ReportItem) onStatusChanged;
  final Function(ReportItem) onToggleBookmark;
  final Function(String id) onDelete;

  const HomePage({
    super.key,
    required this.reports,
    required this.onAddReport,
    required this.onStatusChanged,
    required this.onToggleBookmark,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCampus = 'Semua Kampus';
  String _selectedCategory = 'Semua Kategori';
  int _selectedTypeIndex = 0; // 0: Semua Aktif, 1: Hilang, 2: Ditemukan, 3: Tersimpan, 4: Arsip Selesai
  bool _hideResolved = true; // Kebijakan Auto-Archive

  final List<String> _quickChips = [
    'KTM',
    'Kunci',
    'Helm',
    'Charger',
    'Dompet',
    'Laptop',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedTypeIndex != 0) count++;
    if (_selectedCampus != 'Semua Kampus') count++;
    if (_selectedCategory != 'Semua Kategori') count++;
    if (!_hideResolved) count++;
    return count;
  }

  bool get _hasActiveFilters => _activeFilterCount > 0;

  String _getTypeLabel(int index) {
    switch (index) {
      case 1:
        return 'Hilang';
      case 2:
        return 'Ditemukan';
      case 3:
        return 'Tersimpan';
      case 4:
        return 'Arsip Selesai';
      default:
        return 'Semua Aktif';
    }
  }

  List<ReportItem> get _filteredReports {
    return widget.reports.where((item) {
      // 1. Filter Status
      if (_selectedTypeIndex == 0) {
        if (_hideResolved && item.isResolved) return false;
      } else if (_selectedTypeIndex == 1) {
        if (item.type != ReportType.lost) return false;
        if (_hideResolved && item.isResolved) return false;
      } else if (_selectedTypeIndex == 2) {
        if (item.type != ReportType.found) return false;
        if (_hideResolved && item.isResolved) return false;
      } else if (_selectedTypeIndex == 3) {
        if (!item.isBookmarked) return false;
      } else if (_selectedTypeIndex == 4) {
        if (!item.isResolved) return false;
      }

      // 2. Filter Kampus
      if (_selectedCampus != 'Semua Kampus' && item.campus != _selectedCampus) {
        return false;
      }

      // 3. Filter Kategori
      if (_selectedCategory != 'Semua Kategori' &&
          item.category != _selectedCategory) {
        return false;
      }

      // 4. Filter Kata Kunci
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchLoc = item.specificLocation.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchLoc) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _resetAllFilters() {
    setState(() {
      _selectedCampus = 'Semua Kampus';
      _selectedCategory = 'Semua Kategori';
      _selectedTypeIndex = 0;
      _hideResolved = true;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  // =========================================================================
  // MODAL BOTTOM SHEET: PUSAT FILTER TERPADU (CLEAN & TERORGANISIR)
  // =========================================================================
  void _showFilterSheet() {
    // Salin nilai sementara agar pengguna bisa mengatur filter sebelum menerapkan
    int tempTypeIndex = _selectedTypeIndex;
    String tempCampus = _selectedCampus;
    String tempCategory = _selectedCategory;
    bool tempHideResolved = _hideResolved;
    String tempSearch = _searchQuery;

    final lostCount = widget.reports
        .where((i) => i.type == ReportType.lost && !i.isResolved)
        .length;
    final foundCount = widget.reports
        .where((i) => i.type == ReportType.found && !i.isResolved)
        .length;
    final activeCount = lostCount + foundCount;
    final bookmarkCount = widget.reports.where((i) => i.isBookmarked).length;
    final resolvedCount = widget.reports.where((i) => i.isResolved).length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 4.5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header Sheet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.tune_rounded, color: Color(0xFF1E3A8A), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Filter & Kategori',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                        ),
                        onPressed: () {
                          setSheetState(() {
                            tempTypeIndex = 0;
                            tempCampus = 'Semua Kampus';
                            tempCategory = 'Semua Kategori';
                            tempHideResolved = true;
                            tempSearch = '';
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // Area Form Filter Scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. STATUS LAPORAN
                          _buildFilterSectionTitle('Status Laporan', Icons.flag_rounded),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildChoiceChip(
                                label: 'Semua Aktif ($activeCount)',
                                selected: tempTypeIndex == 0,
                                onSelected: (val) => setSheetState(() => tempTypeIndex = 0),
                                isDark: isDark,
                              ),
                              _buildChoiceChip(
                                label: '🔴 Hilang ($lostCount)',
                                selected: tempTypeIndex == 1,
                                onSelected: (val) => setSheetState(() => tempTypeIndex = 1),
                                isDark: isDark,
                              ),
                              _buildChoiceChip(
                                label: '🟢 Ditemukan ($foundCount)',
                                selected: tempTypeIndex == 2,
                                onSelected: (val) => setSheetState(() => tempTypeIndex = 2),
                                isDark: isDark,
                              ),
                              _buildChoiceChip(
                                label: '⭐ Tersimpan ($bookmarkCount)',
                                selected: tempTypeIndex == 3,
                                onSelected: (val) => setSheetState(() => tempTypeIndex = 3),
                                isDark: isDark,
                              ),
                              _buildChoiceChip(
                                label: '🏁 Selesai ($resolvedCount)',
                                selected: tempTypeIndex == 4,
                                onSelected: (val) => setSheetState(() => tempTypeIndex = 4),
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // 2. PENCARIAN KILAT (KTM, Kunci, Helm, dll)
                          _buildFilterSectionTitle('Pencarian Cepat / Tag', Icons.tag_rounded),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _quickChips.map((chip) {
                              final isSelected = tempSearch.toLowerCase() == chip.toLowerCase();
                              return ActionChip(
                                label: Text(
                                  chip,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: isSelected
                                    ? const Color(0xFF1E3A8A)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                onPressed: () {
                                  setSheetState(() {
                                    if (isSelected) {
                                      tempSearch = '';
                                    } else {
                                      tempSearch = chip;
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),

                          // 3. LOKASI KAMPUS UNIMAL
                          _buildFilterSectionTitle('Lokasi Kampus UNIMAL', Icons.school_rounded),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: campusList.map((campus) {
                              final isSelected = tempCampus == campus;
                              return _buildChoiceChip(
                                label: campus,
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) setSheetState(() => tempCampus = campus);
                                },
                                isDark: isDark,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),

                          // 4. KATEGORI BARANG
                          _buildFilterSectionTitle('Kategori Barang', Icons.category_rounded),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: tempCategory,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            items: categoryList.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setSheetState(() => tempCategory = val);
                              }
                            },
                          ),
                          const SizedBox(height: 18),

                          // 5. KEBIJAKAN AUTO-ARCHIVE
                          Material(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Sembunyikan Barang Selesai',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                subtitle: const Text(
                                  'Hanya tampilkan laporan barang yang masih aktif',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                                value: tempHideResolved,
                                onChanged: (val) {
                                  setSheetState(() => tempHideResolved = val);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Tombol Terapkan Filter
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedTypeIndex = tempTypeIndex;
                        _selectedCampus = tempCampus;
                        _selectedCategory = tempCategory;
                        _hideResolved = tempHideResolved;
                        _searchQuery = tempSearch;
                        _searchController.text = tempSearch;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Terapkan Filter Sekarang',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required bool isDark,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          color: selected
              ? Colors.white
              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
        ),
      ),
      selected: selected,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
      side: BorderSide(
        color: selected ? const Color(0xFF1E3A8A) : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final list = _filteredReports;

    final totalReports = widget.reports.length;
    final lostCount = widget.reports
        .where((i) => i.type == ReportType.lost && !i.isResolved)
        .length;
    final resolvedCount = widget.reports.where((i) => i.isResolved).length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TemuKampus UNIMAL',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Sistem Informasi Barang Hilang & Temuan',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // =================================================================
          // 1. MINI METRIC BANNER STATISTIK MODERN
          // =================================================================
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFF0FDF4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: 'Total Barang',
                    value: '$totalReports',
                    color: const Color(0xFF2563EB),
                    icon: Icons.inventory_2_rounded,
                  ),
                ),
                _buildMetricDivider(isDark),
                Expanded(
                  child: _buildMetricItem(
                    label: 'Masih Dicari',
                    value: '$lostCount',
                    color: const Color(0xFFEF4444),
                    icon: Icons.search_rounded,
                  ),
                ),
                _buildMetricDivider(isDark),
                Expanded(
                  child: _buildMetricItem(
                    label: 'Kembali',
                    value: '$resolvedCount',
                    color: const Color(0xFF10B981),
                    icon: Icons.check_circle_rounded,
                  ),
                ),
              ],
            ),
          ),

          // =================================================================
          // 2. UNIFIED SEARCH & FILTER BUTTON (DENGAN BADGE FILTER AKTIF)
          // =================================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari barang, KTM, kunci, helm...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Tombol Filter Modern dengan Badge Dinamis
                Material(
                  color: _hasActiveFilters
                      ? const Color(0xFF1E3A8A)
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _hasActiveFilters
                              ? const Color(0xFF1E3A8A)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: _hasActiveFilters
                                ? Colors.white
                                : (isDark ? Colors.white70 : const Color(0xFF1E3A8A)),
                          ),
                          if (_hasActiveFilters)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_activeFilterCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =================================================================
          // 3. BARIS FILTER AKTIF (HANYA MUNCUL JIKA FILTER SEDANG DITERAPKAN)
          // =================================================================
          if (_hasActiveFilters)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_rounded, size: 14, color: Color(0xFF1E3A8A)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_selectedTypeIndex != 0)
                            _buildActiveFilterChip(
                              _getTypeLabel(_selectedTypeIndex),
                              () => setState(() => _selectedTypeIndex = 0),
                              isDark,
                            ),
                          if (_selectedCampus != 'Semua Kampus')
                            _buildActiveFilterChip(
                              _selectedCampus,
                              () => setState(() => _selectedCampus = 'Semua Kampus'),
                              isDark,
                            ),
                          if (_selectedCategory != 'Semua Kategori')
                            _buildActiveFilterChip(
                              _selectedCategory,
                              () => setState(() => _selectedCategory = 'Semua Kategori'),
                              isDark,
                            ),
                          if (!_hideResolved)
                            _buildActiveFilterChip(
                              'Termasuk Selesai',
                              () => setState(() => _hideResolved = true),
                              isDark,
                            ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _resetAllFilters,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'Hapus Semua',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // =================================================================
          // 4. LISTVIEW FEED KARTU LAPORAN YANG SEKARANG LEGA & MENYALA
          // =================================================================
          Expanded(
            child: list.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ReportCard(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DetailPage(
                                item: item,
                                onStatusChanged: widget.onStatusChanged,
                                onToggleBookmark: widget.onToggleBookmark,
                                onDelete: widget.onDelete,
                              ),
                            ),
                          );
                        },
                        onToggleBookmark: () => widget.onToggleBookmark(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(bool isDark) {
    return Container(
      height: 24,
      width: 1,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
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
                Icons.search_off_rounded,
                size: 54,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Laporan yang Cocok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba ubah kata kunci pencarian atau reset filter Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: _resetAllFilters,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Semua Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
