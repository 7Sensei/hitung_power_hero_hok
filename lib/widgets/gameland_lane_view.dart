import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../models/lane_model.dart';
import '../providers/calculator_provider.dart';
import 'hero_picker_dialog.dart';

class GamelandLaneView extends StatelessWidget {
  const GamelandLaneView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final laneData = provider.currentLaneData;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        return Column(
          children: [
            // 1. STATS BANNER ALA GAMELAND (Ambient Glow & Key Stats)
            _buildStatOverviewBanner(context, provider, laneData),

            const SizedBox(height: 20),

            // 2. DUA KARTU UTAMA (HERO UTAMA 100% & HERO OP 20%)
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom Kiri: Hero Utama (100%)
                  Expanded(
                    child: _buildHeroGroupCard(
                      context: context,
                      provider: provider,
                      laneData: laneData,
                      isUtama: true,
                      title: 'Hero Utama',
                      weightTag: 'Bobot 100%',
                      subtotalText: HOKUtils.formatNumber(
                        laneData.subtotalUtama,
                      ),
                      icon: Icons.workspace_premium_rounded,
                      iconColor: HokTheme.neonLime,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Kolom Kanan: Hero OP (20%)
                  Expanded(
                    child: _buildHeroGroupCard(
                      context: context,
                      provider: provider,
                      laneData: laneData,
                      isUtama: false,
                      title: 'Hero OP Kamu',
                      weightTag: 'Bobot 20%',
                      subtotalText: HOKUtils.formatNumber(laneData.subtotalOP),
                      extraSubtotalText:
                          '(20% dari ${HOKUtils.formatNumber(laneData.sumRawOP)})',
                      icon: Icons.shield_outlined,
                      iconColor: HokTheme.limeAccent,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildHeroGroupCard(
                    context: context,
                    provider: provider,
                    laneData: laneData,
                    isUtama: true,
                    title: 'Hero Utama',
                    weightTag: 'Bobot 100%',
                    subtotalText: HOKUtils.formatNumber(laneData.subtotalUtama),
                    icon: Icons.workspace_premium_rounded,
                    iconColor: HokTheme.neonLime,
                  ),
                  const SizedBox(height: 20),
                  _buildHeroGroupCard(
                    context: context,
                    provider: provider,
                    laneData: laneData,
                    isUtama: false,
                    title: 'Hero OP Kamu',
                    weightTag: 'Bobot 20%',
                    subtotalText: HOKUtils.formatNumber(laneData.subtotalOP),
                    extraSubtotalText:
                        '(20% dari ${HOKUtils.formatNumber(laneData.sumRawOP)})',
                    icon: Icons.shield_outlined,
                    iconColor: HokTheme.limeAccent,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // 3. KARTU REKOMENDASI PINTAR (Bento Card Ala Gameland)
            _buildSmartStrategyCard(context, provider, laneData),

            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  // --- STAT OVERVIEW BANNER DENGAN AMBIENT GLOW ---
  Widget _buildStatOverviewBanner(
    BuildContext context,
    CalculatorProvider provider,
    LaneData laneData,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C120C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2C1E)),
        boxShadow: [
          BoxShadow(
            color: HokTheme.neonLime.withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient Glow Hijau di Latar Belakang
          Positioned(
            bottom: -40,
            right: 40,
            child: Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HokTheme.neonLime.withValues(alpha: 0.12),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom Power Saat Ini
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: HokTheme.neonLime.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: HokTheme.neonLime.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${laneData.lane.displayName} • Tier ${laneData.currentTier}',
                                style: const TextStyle(
                                  color: HokTheme.neonLime,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              HOKUtils.formatNumber(laneData.totalPowerLane),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Kolom Target Power
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () =>
                                _showEditTargetDialog(context, provider),
                            borderRadius: BorderRadius.circular(6),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Target ${HOKUtils.formatNumber(laneData.targetPower)}',
                                    style: const TextStyle(
                                      color: HokTheme.limeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: HokTheme.limeAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              laneData.remainingPowerToTarget > 0
                                  ? 'Kurang ${HOKUtils.formatNumber(laneData.remainingPowerToTarget)} poin lagi'
                                  : 'Target Tercapai! 🎉',
                              style: TextStyle(
                                color: laneData.remainingPowerToTarget > 0
                                    ? HokTheme.textSecondary
                                    : HokTheme.neonLime,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Linear Progress Bar Ala Gameland
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: laneData.progressToTarget,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF172217),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      HokTheme.neonLime,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Progress ke target: ${(laneData.progressToTarget * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: HokTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Formula: Utama (${HOKUtils.formatNumber(laneData.subtotalUtama)}) + OP (${HOKUtils.formatNumber(laneData.subtotalOP)})',
                      style: const TextStyle(
                        color: HokTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- KARTU DAFTAR HERO (HERO UTAMA & HERO OP) ---
  Widget _buildHeroGroupCard({
    required BuildContext context,
    required CalculatorProvider provider,
    required LaneData laneData,
    required bool isUtama,
    required String title,
    required String weightTag,
    required String subtotalText,
    String? extraSubtotalText,
    required IconData icon,
    required Color iconColor,
  }) {
    final heroes = isUtama ? laneData.heroUtama : laneData.heroOP;
    final startIndex = isUtama ? 1 : 6;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D130D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFF101710),
              borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor.withValues(alpha: 0.3)),
                  ),
                  child: Center(child: Icon(icon, color: iconColor, size: 20)),
                ),
                const SizedBox(width: 12),
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
                        weightTag,
                        style: const TextStyle(
                          color: HokTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      subtotalText,
                      style: TextStyle(
                        color: isUtama ? HokTheme.neonLime : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (extraSubtotalText != null)
                      Text(
                        extraSubtotalText,
                        style: const TextStyle(
                          color: HokTheme.textMuted,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFF182218)),

          // List 5 Slot Hero
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              children: List.generate(5, (index) {
                final rank = startIndex + index;
                final slot = heroes[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121912),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1A261A)),
                  ),
                  child: Row(
                    children: [
                      // Badge Rank #
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isUtama
                              ? HokTheme.neonLime.withValues(alpha: 0.2)
                              : const Color(0xFF192419),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '#$rank',
                            style: TextStyle(
                              color: isUtama
                                  ? HokTheme.neonLime
                                  : HokTheme.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Hero Avatar & Nama (Bisa diklik untuk ganti Hero HoK)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => HeroPickerDialog(
                                initialLane: laneData.lane,
                                onSelected: (h) {
                                  provider.updateHeroName(
                                    isUtama: isUtama,
                                    index: index,
                                    newName: h.name,
                                  );
                                  if (slot.power == 0) {
                                    if (isUtama) {
                                      provider.updateHeroUtamaPower(
                                        index,
                                        h.defaultPower,
                                      );
                                    } else {
                                      provider.updateHeroOPPower(
                                        index,
                                        h.defaultPower,
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF1D2A1D),
                                  child: Text(
                                    slot.heroName.isNotEmpty
                                        ? slot.heroName
                                              .substring(
                                                0,
                                                slot.heroName.length >= 2
                                                    ? 2
                                                    : 1,
                                              )
                                              .toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: isUtama
                                          ? HokTheme.neonLime
                                          : Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        slot.heroName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        'Ganti hero',
                                        style: TextStyle(
                                          color: HokTheme.textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Input Power Hero
                      SizedBox(
                        width: 90,
                        child: _GamelandPowerField(
                          initialValue: slot.power,
                          onChanged: (newVal) {
                            if (isUtama) {
                              provider.updateHeroUtamaPower(index, newVal);
                            } else {
                              provider.updateHeroOPPower(index, newVal);
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 6),

                      // Tombol Cepat +100 / +500
                      InkWell(
                        onTap: () => provider.quickDeltaPower(
                          isUtama: isUtama,
                          index: index,
                          delta: 100,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF192419),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF233223)),
                          ),
                          child: const Text(
                            '+100',
                            style: TextStyle(
                              color: HokTheme.limeAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // --- KARTU STRATEGI PINTAR ALA BENTO GAMELAND ---
  Widget _buildSmartStrategyCard(
    BuildContext context,
    CalculatorProvider provider,
    LaneData laneData,
  ) {
    final diff = laneData.remainingPowerToTarget;
    final totalPower = laneData.totalPowerLane;
    final currentTier = laneData.currentTier;
    final nextTierPower = (currentTier + 1) * 1000;
    final pointsToNextTier = nextTierPower - totalPower;

    final lowestUtama = laneData.heroUtama.reduce(
      (a, b) => a.power < b.power ? a : b,
    );
    final highestOP = laneData.heroOP.reduce(
      (a, b) => a.power > b.power ? a : b,
    );
    final gapToPromote = (lowestUtama.power - highestOP.power) + 1;
    final avgPerUtama = diff > 0 ? (diff / 5).ceil() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0D140D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: HokTheme.neonLime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    color: HokTheme.neonLime,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Rekomendasi Push Tercepat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A261A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  diff > 0
                      ? 'Sisa ${HOKUtils.formatNumber(diff)} Poin'
                      : 'Target Tercapai',
                  style: const TextStyle(
                    color: HokTheme.neonLime,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (diff <= 0)
            _buildStrategyRow(
              title: 'Target Saat Ini Tercapai! 🎉',
              detail:
                  'Total Power Lane telah memenuhi target ${HOKUtils.formatNumber(laneData.targetPower)}. '
                  'Anda hanya membutuhkan +${HOKUtils.formatNumber(pointsToNextTier)} poin lagi untuk naik ke Tier ${currentTier + 1} (${HOKUtils.formatNumber(nextTierPower)} Power). '
                  'Anda dapat menaikkan target dengan menekan tombol edit pada Target Power.',
            )
          else ...[
            _buildStrategyRow(
              title: 'Prioritas 1: Maksimalkan Slot Hero Utama (Bobot 100%)',
              detail:
                  'Setiap kenaikan power pada 5 slot Hero Utama dihitung 100% penuh ke Power Lane. '
                  'Untuk mengejar sisa target ${HOKUtils.formatNumber(diff)} poin, Anda cukup menaikkan rata-rata +${HOKUtils.formatNumber(avgPerUtama)} poin per slot pada 5 Hero Utama.',
            ),
            const SizedBox(height: 10),
            _buildStrategyRow(
              title:
                  'Prioritas 2: Tukar Slot Hero OP ke Top 5 (Bobot 20% → 100%)',
              detail: gapToPromote > 0
                  ? 'Tingkatkan power slot Hero OP tertinggi sebesar minimal +${HOKUtils.formatNumber(gapToPromote)} poin agar melampaui slot terendah di Hero Utama. '
                        'Bobot kontribusinya akan otomatis melonjak dari 20% menjadi 100% (peningkatan efisiensi 5x lipat).'
                  : 'Power di seluruh slot Hero Utama saat ini sudah lebih tinggi dibandingkan seluruh slot Hero OP.',
            ),
            const SizedBox(height: 10),
            _buildStrategyRow(
              title: 'Target Terdekat: Naik ke Tier ${currentTier + 1}',
              detail:
                  'Power Lane saat ini adalah ${HOKUtils.formatNumber(totalPower)} (Tier $currentTier). '
                  'Hanya membutuhkan +${HOKUtils.formatNumber(pointsToNextTier)} poin lagi untuk mencapai Tier ${currentTier + 1} (${HOKUtils.formatNumber(nextTierPower)} Power).',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStrategyRow({required String title, required String detail}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111811),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1B271B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTargetDialog(
    BuildContext context,
    CalculatorProvider provider,
  ) {
    final controller = TextEditingController(
      text: provider.currentLaneData.targetPower.toString(),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F160F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Ubah Target Power Lane',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Target Power (misal: 33190)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: HokTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final n =
                  int.tryParse(controller.text) ??
                  provider.currentLaneData.targetPower;
              provider.updateTargetPower(n);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HokTheme.neonLime,
              foregroundColor: HokTheme.darkText,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _GamelandPowerField extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const _GamelandPowerField({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_GamelandPowerField> createState() => _GamelandPowerFieldState();
}

class _GamelandPowerFieldState extends State<_GamelandPowerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(covariant _GamelandPowerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue.toString() != _controller.text) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        fillColor: const Color(0xFF162116),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF223222)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF223222)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: HokTheme.neonLime),
        ),
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val) ?? 0;
        widget.onChanged(parsed);
      },
    );
  }
}
