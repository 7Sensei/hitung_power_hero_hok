import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';
import 'hero_slot_card.dart';

class LaneSectionsWidget extends StatelessWidget {
  const LaneSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final laneData = provider.currentLaneData;

    return Column(
      children: [
        // BAGIAN 1: HERO UTAMA (100%)
        _buildSectionContainer(
          context: context,
          title: 'Hero Utama',
          subtitle: 'Top 5 Hero dengan Power Tertinggi (Kontribusi 100%)',
          subtotal: laneData.subtotalUtama,
          weightText: 'Bobot perhitungan 100%',
          isUtama: true,
          slots: List.generate(5, (index) {
            return HeroSlotCard(
              rankNumber: index + 1,
              isUtama: true,
              slotIndex: index,
            );
          }),
        ),

        const SizedBox(height: 20),

        // BAGIAN 2: HERO OP KAMU (20%)
        _buildSectionContainer(
          context: context,
          title: 'Hero OP Kamu',
          subtitle: 'Top 6–10 Hero Cadangan (Kontribusi 20%)',
          subtotal: laneData.subtotalOP,
          rawSubtotal: laneData.sumRawOP,
          weightText: 'Bobot perhitungan 20%',
          isUtama: false,
          slots: List.generate(5, (index) {
            return HeroSlotCard(
              rankNumber: index + 6,
              isUtama: false,
              slotIndex: index,
            );
          }),
        ),

        const SizedBox(height: 20),

        // BAGIAN 3: TARGET SIMULATOR & REKOMENDASI PINTAR
        _buildTargetRecommendationCard(provider),
      ],
    );
  }

  Widget _buildSectionContainer({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int subtotal,
    int? rawSubtotal,
    required String weightText,
    required bool isUtama,
    required List<Widget> slots,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101B31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUtama ? const Color(0xFF264070) : const Color(0xFF1B2E52),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          // Header Baris Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUtama ? const Color(0xFF17294B) : const Color(0xFF13223E),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              border: Border(
                bottom: BorderSide(
                  color: isUtama ? const Color(0xFF284375) : const Color(0xFF1E335A),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isUtama ? Icons.star_rounded : Icons.shield_outlined,
                  color: isUtama ? HokTheme.goldAccent : HokTheme.blueCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: HokTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Box Perhitungan Kanan Sesuai Screenshot Game
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1B30),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUtama ? HokTheme.goldAccent.withValues(alpha: 0.5) : const Color(0xFF2B4475),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond,
                        color: isUtama ? HokTheme.goldAccent : HokTheme.blueCyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            HOKUtils.formatNumber(subtotal),
                            style: TextStyle(
                              color: isUtama ? Colors.white : HokTheme.blueCyan,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            rawSubtotal != null
                                ? '($weightText)'
                                : weightText,
                            style: TextStyle(
                              color: isUtama ? HokTheme.goldLight : HokTheme.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar Slot Hero
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: slots),
          ),
        ],
      ),
    );
  }

  // Rekomendasi Pintar Push Hero
  Widget _buildTargetRecommendationCard(CalculatorProvider provider) {
    final laneData = provider.currentLaneData;
    final diff = laneData.remainingPowerToTarget;

    if (diff <= 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF122C24),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HokTheme.greenAccent.withValues(alpha: 0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.emoji_events, color: HokTheme.goldAccent, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Selamat! Total Power Lane Anda telah melampaui target yang ditentukan!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    // Hero utama terendah (Slot #5)
    final lowestUtama = laneData.heroUtama.reduce((a, b) => a.power < b.power ? a : b);
    // Hero OP tertinggi (Slot #6)
    final highestOP = laneData.heroOP.reduce((a, b) => a.power > b.power ? a : b);
    final gapToPromote = (lowestUtama.power - highestOP.power) + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF142442), Color(0xFF101B33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF284478), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: HokTheme.goldAccent, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Simulator & Strategi Push Paling Efisien',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3560),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Kurang ${HOKUtils.formatNumber(diff)} Poin',
                  style: const TextStyle(
                    color: HokTheme.goldAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Untuk mencapai target ${HOKUtils.formatNumber(laneData.targetPower)} (${laneData.targetPercentile}), berikut opsi terbaik:',
            style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 10),

          // Opsi 1: Push Hero Utama
          _buildStrategyItem(
            icon: Icons.check_circle_outline,
            iconColor: HokTheme.greenAccent,
            title: 'Opsi 1 (Efisiensi 100%): Dorong Hero Utama',
            description:
                'Tingkatkan Hero Utama terendah saat ini (${lowestUtama.heroName} [${lowestUtama.power}]) sebesar +${HOKUtils.formatNumber(diff)} poin. Setiap +1 poin hero langsung menambah +1 poin ke Power Lane.',
          ),
          const SizedBox(height: 8),

          // Opsi 2: Rank Swap (Hero OP masuk ke Top 5)
          _buildStrategyItem(
            icon: Icons.swap_vert,
            iconColor: HokTheme.blueCyan,
            title: 'Opsi 2 (Trik Lonjakan Bobot): Masukkan ${highestOP.heroName} ke Top 5',
            description: gapToPromote > 0
                ? 'Tingkatkan ${highestOP.heroName} (${highestOP.power}) minimal +$gapToPromote poin agar melampaui ${lowestUtama.heroName}. Bobot kontribusinya akan langsung melompat dari 20% menjadi 100%!'
                : 'Hero cadangan sudah siap auto-sort untuk memaksimalkan total power.',
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E3258)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: HokTheme.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
