import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';

class GamelandNavbar extends StatelessWidget {
  const GamelandNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo Kiri
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: HokTheme.neonLime,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.sports_esports_rounded,
                        color: HokTheme.darkText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'HOK Power',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              // Tengah: Floating Capsule Menu (Untuk Desktop / Tablet)
              if (!isMobile)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111711),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: const Color(0xFF1E2B1E)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNavCapsuleItem(
                        label: 'Power Lane',
                        isActive: provider.activeTab == CalculatorTab.lane,
                        onTap: () => provider.setTab(CalculatorTab.lane),
                      ),
                      _buildNavCapsuleItem(
                        label: 'Hero Power',
                        isActive: provider.activeTab == CalculatorTab.hero,
                        onTap: () => provider.setTab(CalculatorTab.hero),
                      ),
                      _buildNavCapsuleItem(
                        label: 'Auto-Sort',
                        isActive: false,
                        onTap: () {
                          provider.autoSortCurrentLane();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('10 Hero berhasil di-sort otomatis berdasarkan power tertinggi!'),
                              backgroundColor: Color(0xFF162416),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

              // Kanan: Tombol Aksi Bulat Ala Gameland
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Salin Ringkasan Text untuk Share
                  InkWell(
                    onTap: () => _copySummaryToClipboard(context, provider),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: HokTheme.neonLime.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: HokTheme.neonLime.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.share_outlined, color: HokTheme.neonLime, size: 15),
                          SizedBox(width: 6),
                          Text(
                            'Salin Rekap',
                            style: TextStyle(
                              color: HokTheme.neonLime,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Pill Muat Contoh HoK
                  InkWell(
                    onTap: () {
                      provider.resetToSampleData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data contoh screenshot HoK (29.782 Power) berhasil dimuat!'),
                          backgroundColor: Color(0xFF162416),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121912),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF223222)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.refresh_rounded, color: Colors.white70, size: 15),
                          SizedBox(width: 6),
                          Text(
                            'Sample HoK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Circle Reset Button
                  _buildCircleButton(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Kosongkan Input',
                    onTap: () {
                      provider.clearCurrentLane();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildNavCapsuleItem({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E2D1E) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? HokTheme.neonLime : HokTheme.textSecondary,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static Widget _buildCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF121912),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF223222)),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white70, size: 18),
        ),
      ),
    );
  }

  // Fungsi Salin Rekap ke Clipboard
  static void _copySummaryToClipboard(BuildContext context, CalculatorProvider provider) {
    final l = provider.currentLaneData;
    final buffer = StringBuffer();
    buffer.writeln('🎮 *HONOR OF KINGS - POWER LANE SUMMARY*');
    buffer.writeln('🛡️ *${l.lane.displayName}*: ${HOKUtils.formatNumber(l.totalPowerLane)} Power (Tier ${l.currentTier})');
    buffer.writeln('📊 Peringkat: ${l.currentPercentile}');
    buffer.writeln('');
    buffer.writeln('👑 *Top 5 Hero Utama (100%)*:');
    for (int i = 0; i < l.heroUtama.length; i++) {
      final h = l.heroUtama[i];
      buffer.writeln('  ${i + 1}. ${h.heroName}: ${HOKUtils.formatNumber(h.power)} Power');
    }
    buffer.writeln('  👉 Subtotal: ${HOKUtils.formatNumber(l.subtotalUtama)} Power');
    buffer.writeln('');
    buffer.writeln('⚡ *Top 6-10 Hero OP (20%)*:');
    for (int i = 0; i < l.heroOP.length; i++) {
      final h = l.heroOP[i];
      buffer.writeln('  ${i + 6}. ${h.heroName}: ${HOKUtils.formatNumber(h.power)} Power');
    }
    buffer.writeln('  👉 Subtotal Kontribusi: ${HOKUtils.formatNumber(l.subtotalOP)} Power (20% dari ${HOKUtils.formatNumber(l.sumRawOP)})');
    buffer.writeln('');
    buffer.writeln('🎯 *Target*: ${HOKUtils.formatNumber(l.targetPower)} Power (${l.targetPercentile})');
    if (l.remainingPowerToTarget > 0) {
      buffer.writeln('⏳ Butuh +${HOKUtils.formatNumber(l.remainingPowerToTarget)} poin lagi untuk mencapai target.');
    } else {
      buffer.writeln('🎉 Target telah tercapai!');
    }
    buffer.writeln('');
    buffer.writeln('🚀 Dihitung via HOK Power Calculator');

    Clipboard.setData(ClipboardData(text: buffer.toString())).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ringkasan Power Lane berhasil disalin ke clipboard! Siap dibagikan ke teman/komunitas.'),
            backgroundColor: Color(0xFF162416),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }
}
