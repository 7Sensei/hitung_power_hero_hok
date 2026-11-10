import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';

class GamelandSidebar extends StatelessWidget {
  const GamelandSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return Drawer(
      backgroundColor: const Color(0xFF090D09),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        side: BorderSide(color: Color(0xFF1C2B1C)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Drawer
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: HokTheme.neonLime,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icon_app.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOK by 7Sensei',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tools & Utilities for HOK',
                          style: TextStyle(
                            color: HokTheme.textSecondary,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: HokTheme.textMuted,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(color: Color(0xFF182418), height: 1),
              const SizedBox(height: 20),

              const Text(
                'PILIH TOOLS',
                style: TextStyle(
                  color: HokTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              // Menu 1: Kalkulator Power HoK
              _buildMenuItem(
                title: 'Kalkulator Power HoK',
                subtitle: 'Power Lane & Rincian Hero Power',
                icon: Icons.shield_rounded,
                badge: 'Tools',
                isSelected: provider.activeScreen == AppScreen.powerCalculator,
                onTap: () {
                  provider.setAppScreen(AppScreen.powerCalculator);
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              // Menu 2: Penghitung Win Rate (johsteven/penghitung-wr)
              _buildMenuItem(
                title: 'Penghitung Win Rate (WR)',
                subtitle: 'Target Win Streak & Lose Streak',
                icon: Icons.insights_rounded,
                badge: 'Tools',
                isSelected:
                    provider.activeScreen == AppScreen.winRateCalculator,
                onTap: () {
                  provider.setAppScreen(AppScreen.winRateCalculator);
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              // Footer Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F150F),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1B281B)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.code_rounded,
                          color: HokTheme.neonLime,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Open Source Tools',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• HOK by 7Sensei',
                      style: TextStyle(
                        color: HokTheme.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? HokTheme.neonLime : const Color(0xFF101610),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? HokTheme.neonLime : const Color(0xFF1B281B),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HokTheme.neonLime.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0A0F0A)
                    : const Color(0xFF182418),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? HokTheme.neonLime : Colors.white70,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? HokTheme.darkText : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1C271C)
                          : HokTheme.textSecondary,
                      fontSize: 11,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0A0F0A)
                    : const Color(0xFF182418),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: isSelected ? HokTheme.neonLime : HokTheme.limeAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
