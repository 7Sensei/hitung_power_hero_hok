import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';

class GamelandHeroHeader extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  const GamelandHeroHeader({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return Column(
      children: [
        const SizedBox(height: 16),

        // 1. Top Mini Pill Badge (Sesuai referensi: "? FAQ - Gaming As A Service")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF111711),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF233223)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '⚡ HOK POWER  •  HONOR OF KINGS CALCULATOR',
                style: TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 2. Big Title (Sesuai referensi: "Frequently Asked 🎮 Questions")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Power Lane',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(width: 12),
            // Game controller icon / badge ala referensi
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C271C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E422E)),
              ),
              child: const Text('🎮', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            const Text(
              'Simulator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 3. Subtitle (Sesuai referensi: "Everything you need to know about...")
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 620),
          child: Text(
            'Kalkulator akurat Power Lane (分路战力) dan rincian Hero Power (英雄战力) resmi Honor of Kings. Simulasikan target Tier dan strategi push hero secara real-time.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 4. Search Bar Capsule (Sesuai referensi: "Q Search questions...")
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F150F),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF202C20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Cari nama hero (misal: Dharma, Lam, Diaochan)...',
                hintStyle: TextStyle(color: HokTheme.textMuted, fontSize: 13),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: HokTheme.limeAccent,
                  size: 20,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 5. Category Pills Capsule Bar (Sesuai referensi: "General | Billing | Technical...")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0E140E),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF1E2B1E)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 5 Tombol Lane
                ...HokLane.values.map((lane) {
                  final isSelected =
                      provider.activeTab == CalculatorTab.lane &&
                      provider.activeLane == lane;

                  return _buildCategoryPill(
                    label: lane.displayName,
                    icon: lane.icon,
                    isSelected: isSelected,
                    onTap: () {
                      provider.setTab(CalculatorTab.lane);
                      provider.switchLane(lane);
                    },
                  );
                }),

                // Tombol Tab Hero Power Detail
                _buildCategoryPill(
                  label: 'Rincian Hero',
                  icon: Icons.calculate_outlined,
                  isSelected: provider.activeTab == CalculatorTab.hero,
                  onTap: () {
                    provider.setTab(CalculatorTab.hero);
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoryPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? HokTheme.neonLime : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: HokTheme.neonLime.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? HokTheme.darkText : HokTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? HokTheme.darkText
                      : HokTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
