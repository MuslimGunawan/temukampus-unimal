import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;
  final VoidCallback onResetData;

  const AboutPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.onResetData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, String>> anggota = [
      {
        'nama': 'Muslim Gunawan',
        'nim': '240170036',
        'peran': 'Lead Mobile Developer',
      },
      {
        'nama': 'Dio Tri Firnanda',
        'nim': '240170052',
        'peran': 'UI/UX & Frontend Designer',
      },
      {
        'nama': 'Jihan Nur Alifah',
        'nim': '240170057',
        'peran': 'System Analyst & Documentation',
      },
      {
        'nama': 'Nadin Rahmatika Piliang',
        'nim': '240170079',
        'peran': 'Database & Content Management',
      },
      {
        'nama': 'Farid Deza Amin Nur Rasyid',
        'nim': '240170231',
        'peran': 'Quality Assurance & Testing',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang & Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // App Branding Banner Modern
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'TemuKampus UNIMAL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pusat Layanan Barang Hilang & Ditemukan',
                    style: TextStyle(fontSize: 12.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Proyek UAS - Semester Ganjil 2026',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // PENGATURAN TEMA APLIKASI (Dark Mode / Light Mode)
            Material(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Mode Gelap (Dark Mode)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                subtitle: const Text(
                  'Kenyamanan visual layar saat kondisi minim cahaya',
                  style: TextStyle(fontSize: 11.5),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.amber.withValues(alpha: 0.15)
                        : const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: isDarkMode ? Colors.amber : const Color(0xFF1E3A8A),
                    size: 20,
                  ),
                ),
                value: isDarkMode,
                onChanged: onToggleDarkMode,
              ),
            ),
            const SizedBox(height: 14),

            // Card Dosen & Mata Kuliah
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.school_rounded, color: Color(0xFF1E3A8A), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'INF3253 - Pemrograman Mobile (A2)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                            Text(
                              'Teknik Informatika - Universitas Malikussaleh',
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
                  Divider(
                    height: 22,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, color: Color(0xFF0D9488), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dosen Pengampu:',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            const Text(
                              'MUKTI QAMAL, ST., M.IT.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tim Pengembang
            Row(
              children: [
                const Icon(Icons.group_rounded, color: Color(0xFF1E3A8A), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tim Pengembang (Kelompok 6)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...anggota.map((m) {
              final isLead = m['peran']!.contains('Lead');
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLead
                        ? const Color(0xFF2563EB)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: isLead ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isLead
                          ? const Color(0xFF1E3A8A)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      foregroundColor: isLead
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      child: Text(
                        m['nama']![0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['nama']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: isLead
                                  ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A))
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIM: ${m['nim']} • ${m['peran']}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLead)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Lead',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Tombol Reset Data ke Sampel Bawaan
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Data Demo?'),
                    content: const Text(
                      'Ini akan mengembalikan seluruh laporan ke data awal sampel UNIMAL.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          onResetData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data berhasil di-reset ke sampel bawaan'),
                              backgroundColor: Color(0xFF1E3A8A),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Data Demo ke Semula'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                side: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Versi Aplikasi
            Text(
              'TemuKampus v2.1.0 • UNIMAL 2026',
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
