import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';

class GamelandHeroHeader extends StatelessWidget {
  const GamelandHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final isLaneMode = provider.activeTab == CalculatorTab.lane;

    return Column(
      children: [
        const SizedBox(height: 14),

        // 1. Top Mini Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF111711),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF233223)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLaneMode
                    ? '⚡ HOK POWER  •  ${provider.currentLaneData.lane.displayName.toUpperCase()}'
                    : '⚡ HOK POWER  •  RINCIAN HERO POWER INDIVIDUAL',
                style: const TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Big Title (Ala Gameland: "Power Lane 🎮 Simulator" atau "Rincian Hero 🎮 Calculator")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isLaneMode ? 'Power Lane' : 'Rincian Hero',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF1C271C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E422E)),
              ),
              child: const Text('🎮', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Text(
              isLaneMode ? 'Simulator' : 'Calculator',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 3. Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            isLaneMode
                ? 'Kalkulator resmi Power Lane (分路战力) Honor of Kings. Bobot Hero Utama 100% dan Hero OP 20% untuk menentukan Tier dan sisa poin ke target rank.'
                : 'Kalkulator rincian Hero Power individual berdasarkan rumus resmi in-game: Power Hero = Power Total × Pengali Total.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 4. Selector 5 Lane (Hanya tampil saat mode Power Lane aktif)
        if (isLaneMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0E140E),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF1E2B1E)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: HokLane.values.map((lane) {
                  final isSelected = provider.activeLane == lane;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => provider.switchLane(lane),
                      borderRadius: BorderRadius.circular(30),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? HokTheme.neonLime : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: HokTheme.neonLime.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              lane.icon,
                              size: 14,
                              color: isSelected ? HokTheme.darkText : HokTheme.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              lane.displayName,
                              style: TextStyle(
                                color: isSelected ? HokTheme.darkText : HokTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
