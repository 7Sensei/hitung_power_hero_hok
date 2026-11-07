import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';
import '../widgets/hero_detail_tab_view.dart';
import '../widgets/lane_header_widget.dart';
import '../widgets/lane_sections.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return Scaffold(
      backgroundColor: HokTheme.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: HokTheme.goldAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: HokTheme.goldAccent.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.shield, color: HokTheme.goldAccent, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOK Power Calculator',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Honor of Kings • Power Lane & Hero System',
                  style: TextStyle(
                    fontSize: 10,
                    color: HokTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Tombol Muat Contoh Data Sesuai Screenshot Game
          IconButton(
            icon: const Icon(Icons.restore, color: HokTheme.blueCyan),
            tooltip: 'Isi Data Sesuai Screenshot HoK',
            onPressed: () {
              provider.resetToSampleData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil dimuat sesuai contoh screenshot HoK (29.782 Power Lane)!'),
                  backgroundColor: Color(0xFF1B2E54),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // Tombol Reset / Kosongkan
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined, color: HokTheme.textSecondary),
            tooltip: 'Kosongkan Input Lane Aktif',
            onPressed: () => _showResetConfirmation(context, provider),
          ),
          // Tombol Info Panduan Formula
          IconButton(
            icon: const Icon(Icons.help_outline, color: HokTheme.goldAccent),
            tooltip: 'Panduan Rumus HoK',
            onPressed: () => _showFormulaGuideDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              // Tab Switcher Ala Game UI (Hero vs Lane)
              _buildTopTabSelector(provider),

              // Konten Tab
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: provider.activeTab == CalculatorTab.lane
                      ? const Column(
                          children: [
                            LaneHeaderWidget(),
                            SizedBox(height: 18),
                            LaneSectionsWidget(),
                            SizedBox(height: 30),
                          ],
                        )
                      : const HeroDetailTabView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Segmented Tab Switcher seperti di Screenshot Game (Hero / Lane)
  Widget _buildTopTabSelector(CalculatorProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF101B30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3258)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'Lane (Power Lane)',
              subtitle: 'Hero Utama 100% + Hero OP 20%',
              icon: Icons.alt_route_rounded,
              isActive: provider.activeTab == CalculatorTab.lane,
              onTap: () => provider.setTab(CalculatorTab.lane),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildTabButton(
              title: 'Hero (Power Detail)',
              subtitle: 'Power Total × Pengali Total',
              icon: Icons.person_search_rounded,
              isActive: provider.activeTab == CalculatorTab.hero,
              onTap: () => provider.setTab(CalculatorTab.hero),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E3560) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? HokTheme.blueCyan : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? HokTheme.blueCyan : HokTheme.textMuted,
              size: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : HokTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isActive ? HokTheme.goldLight : HokTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Konfirmasi Reset
  void _showResetConfirmation(BuildContext context, CalculatorProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF13223E),
        title: const Text('Reset Lane Aktif?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Semua nilai power di ${provider.currentLaneData.lane.displayName} akan dikosongkan (menjadi 0).',
          style: const TextStyle(color: HokTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearCurrentLane();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: HokTheme.redAccent),
            child: const Text('Reset 0'),
          ),
        ],
      ),
    );
  }

  // Dialog Panduan Rumus
  void _showFormulaGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111D35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: HokTheme.goldAccent),
            SizedBox(width: 8),
            Text('Panduan Sistem Power HoK', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: const SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Rumus Power Lane (分路战力):',
                  style: TextStyle(color: HokTheme.goldAccent, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '• Top 1–5 Hero Utama: Bobot perhitungan 100%.\n'
                  '• Top 6–10 Hero OP Kamu: Bobot perhitungan 20%.\n'
                  '• Total Power Lane = (Subtotal Hero Utama) + (Subtotal Hero OP × 20%).\n'
                  '• Tier Lane: Setiap 1.000 Power = 1 Tier (misal 29.782 = Tier 29).',
                  style: TextStyle(color: HokTheme.textSecondary, fontSize: 12, height: 1.4),
                ),
                SizedBox(height: 14),
                Text(
                  '2. Rumus Power Hero Individual (英雄战力):',
                  style: TextStyle(color: HokTheme.blueCyan, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '• Rumus: Power Hero = Power Total × Pengali Total.\n'
                  '• Power Total = Power Performa Ranked + Power Performa Peak + Power Kemenangan (Maks 3.000).\n'
                  '• Pengali Peak: +1% setiap kelipatan 20 poin di atas 1.200 poin Tourney.\n'
                  '• Pengali Keaktifan: Faktor keaktifan hero (10% s/d 100%).',
                  style: TextStyle(color: HokTheme.textSecondary, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: HokTheme.blueCyan, foregroundColor: Colors.black),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}
