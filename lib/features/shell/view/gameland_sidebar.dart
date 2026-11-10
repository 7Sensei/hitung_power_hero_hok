import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/features/shell/viewmodel/shell_viewmodel.dart';

class GamelandSidebar extends StatelessWidget {
  const GamelandSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final shellVM = context.watch<ShellViewModel>();

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
                isSelected: shellVM.activeScreen == AppScreen.powerCalculator,
                onTap: () {
                  shellVM.setAppScreen(AppScreen.powerCalculator);
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
                isSelected: shellVM.activeScreen == AppScreen.winRateCalculator,
                onTap: () {
                  shellVM.setAppScreen(AppScreen.winRateCalculator);
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              // Footer Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F150F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1C271C)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: HokTheme.neonLime,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tools utilitas Honor of Kings untuk membantu optimasi Power Lane & WR.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 11,
                          height: 1.4,
                        ),
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
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A261A) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? HokTheme.neonLime : const Color(0xFF182218),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? HokTheme.neonLime
                    : const Color(0xFF141C14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? HokTheme.darkText : HokTheme.neonLime,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? HokTheme.neonLime.withValues(alpha: 0.2)
                              : const Color(0xFF1B241B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: isSelected
                                ? HokTheme.neonLime
                                : HokTheme.textMuted,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: HokTheme.textMuted,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: isSelected ? HokTheme.neonLime : const Color(0xFF2E3E2E),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
