import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';

class LaneHeaderWidget extends StatelessWidget {
  const LaneHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final laneData = provider.currentLaneData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF13223E),
            Color(0xFF1B2E54),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2B4476),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris 1: Status Power & Lane Selector
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;

              final currentPowerBlock = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold Badge Tier
                  _buildTierBadge(
                    tier: laneData.currentTier,
                    isGold: true,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Power Lane',
                        style: TextStyle(
                          color: HokTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        HOKUtils.formatNumber(laneData.totalPowerLane),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Peringkat Saat Ini   ${laneData.currentPercentile}',
                        style: const TextStyle(
                          color: HokTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              );

              final arrowAndTargetBlock = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.keyboard_double_arrow_right,
                    color: HokTheme.blueCyan,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  // Target Badge
                  _buildTierBadge(
                    tier: laneData.targetTier,
                    isGold: false,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _showEditTargetDialog(context, provider),
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            Text(
                              HOKUtils.formatNumber(laneData.targetPower),
                              style: const TextStyle(
                                color: HokTheme.goldLight,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: HokTheme.goldAccent,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        laneData.targetPercentile,
                        style: const TextStyle(
                          color: HokTheme.blueCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );

              final laneSelectorPill = _buildLaneSelectorPill(context, provider);

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        laneSelectorPill,
                        _buildAutoSortButton(provider),
                      ],
                    ),
                    const SizedBox(height: 16),
                    currentPowerBlock,
                    const SizedBox(height: 12),
                    arrowAndTargetBlock,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentPowerBlock,
                  const SizedBox(width: 20),
                  arrowAndTargetBlock,
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      laneSelectorPill,
                      const SizedBox(height: 8),
                      _buildAutoSortButton(provider),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFF263C68), height: 1),
          const SizedBox(height: 12),

          // Baris 2: Aturan Text & Progress Bar
          Row(
            children: [
              Expanded(
                child: Text(
                  'Power Lane = ${laneData.lane.displayName} Hero Utama + Hero OP Kamu (Berdasarkan Power Tertinggi Sepanjang Masa)',
                  style: const TextStyle(
                    color: HokTheme.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF17294D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A4275)),
                ),
                child: Text(
                  'Tier ${laneData.currentTier}',
                  style: const TextStyle(
                    color: HokTheme.goldAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Progress bar menuju target
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: laneData.progressToTarget,
              minHeight: 6,
              backgroundColor: const Color(0xFF182846),
              valueColor: const AlwaysStoppedAnimation<Color>(HokTheme.blueCyan),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress menuju target: ${(laneData.progressToTarget * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: HokTheme.textMuted, fontSize: 11),
              ),
              Text(
                laneData.remainingPowerToTarget > 0
                    ? 'Kurang ${HOKUtils.formatNumber(laneData.remainingPowerToTarget)} poin lagi'
                    : 'Target Tercapai! 🎉',
                style: TextStyle(
                  color: laneData.remainingPowerToTarget > 0
                      ? HokTheme.goldLight
                      : HokTheme.greenAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Badge Tier Berkilau
  Widget _buildTierBadge({required int tier, required bool isGold}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isGold
              ? [const Color(0xFFFFDF70), const Color(0xFFB78103)]
              : [const Color(0xFF67B6FF), const Color(0xFF1E52A4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isGold ? Colors.amber : Colors.blue).withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0F1B30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield,
                size: 14,
                color: isGold ? HokTheme.goldAccent : HokTheme.blueCyan,
              ),
              Text(
                '$tier',
                style: TextStyle(
                  color: isGold ? HokTheme.goldAccent : HokTheme.blueCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pill Selector Lane di pojok kanan atas
  Widget _buildLaneSelectorPill(BuildContext context, CalculatorProvider provider) {
    final lane = provider.currentLaneData.lane;
    return InkWell(
      onTap: () => _showLanePicker(context, provider),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF17294D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: lane.accentColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(lane.icon, color: lane.accentColor, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lane.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Tier ${provider.currentLaneData.currentTier}',
                  style: TextStyle(
                    color: lane.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.sync_alt, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  // Tombol Auto-Sort Ranking
  Widget _buildAutoSortButton(CalculatorProvider provider) {
    return TextButton.icon(
      onPressed: () => provider.autoSortCurrentLane(),
      style: TextButton.styleFrom(
        foregroundColor: HokTheme.blueCyan,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.sort, size: 14),
      label: const Text(
        'Auto-Sort 10 Hero',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Dialog Pilih Lane
  void _showLanePicker(BuildContext context, CalculatorProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121D34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Lane Honor of Kings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...HokLane.values.map((lane) {
                final isSelected = lane == provider.activeLane;
                final lData = provider.laneDataMap[lane]!;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: isSelected ? const Color(0xFF1D325A) : null,
                  leading: CircleAvatar(
                    backgroundColor: lane.accentColor.withValues(alpha: 0.2),
                    child: Icon(lane.icon, color: lane.accentColor),
                  ),
                  title: Text(
                    lane.displayName,
                    style: TextStyle(
                      color: isSelected ? lane.accentColor : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${lane.chineseName}  •  Tier ${lData.currentTier} (${HOKUtils.formatNumber(lData.totalPowerLane)} Power)',
                    style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: lane.accentColor)
                      : null,
                  onTap: () {
                    provider.switchLane(lane);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Dialog Edit Target Power
  void _showEditTargetDialog(BuildContext context, CalculatorProvider provider) {
    final controller = TextEditingController(
      text: provider.currentLaneData.targetPower.toString(),
    );
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF13223E),
          title: const Text(
            'Ubah Target Power Lane',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Target Poin Power (contoh: 33190)',
              suffixText: 'Power',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = int.tryParse(controller.text) ?? provider.currentLaneData.targetPower;
                provider.updateTargetPower(val);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HokTheme.blueCyan,
                foregroundColor: Colors.black,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
