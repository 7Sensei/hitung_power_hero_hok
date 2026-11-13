import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/features/power_lane/viewmodel/power_lane_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/shell/viewmodel/shell_viewmodel.dart';

class GamelandNavbar extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const GamelandNavbar({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final shellVM = context.watch<ShellViewModel>();
    final powerLaneVM = context.watch<PowerLaneViewModel>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 720;

        final leftBrandBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Garis 3 (Menu Drawer Sidebar)
            InkWell(
              key: const ValueKey('navbar-menu-button'),
              onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF111711),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF223222)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_rounded,
                    color: HokTheme.neonLime,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Logo & Judul Brand
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: HokTheme.neonLime,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icon_app.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                shellVM.activeScreen == AppScreen.powerCalculator
                    ? 'kalkulator Power Lane'
                    : 'Penghitung WR',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        );

        final centerSwitcherBlock =
            shellVM.activeScreen == AppScreen.powerCalculator
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF111711),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF202E20)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTabPill(
                        label: 'Power Lane',
                        icon: Icons.alt_route_rounded,
                        isActive: shellVM.activeTab == CalculatorTab.lane,
                        onTap: () => shellVM.setTab(CalculatorTab.lane),
                      ),
                      _buildTabPill(
                        label: 'Rincian Hero',
                        icon: Icons.calculate_outlined,
                        isActive: shellVM.activeTab == CalculatorTab.hero,
                        onTap: () => shellVM.setTab(CalculatorTab.hero),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF111711),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF202E20)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      color: HokTheme.neonLime,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'WR Tools',
                      style: TextStyle(
                        color: HokTheme.neonLime,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );

        final showPowerLaneActions =
            shellVM.activeScreen == AppScreen.powerCalculator &&
            shellVM.activeTab == CalculatorTab.lane;

        final rightActionsBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPowerLaneActions) ...[
              // Pill Muat Contoh HoK
              InkWell(
                onTap: () {
                  powerLaneVM.resetToSampleData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Data contoh screenshot HoK (29.782 Power) dimuat!',
                      ),
                      backgroundColor: Color(0xFF162416),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121912),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF223222)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        color: HokTheme.neonLime,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Sample',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Tombol Reset Kosongkan Input
              _buildCircleButton(
                icon: Icons.delete_outline_rounded,
                tooltip: 'Kosongkan Input',
                onTap: () {
                  powerLaneVM.clearCurrentLane();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Input nilai lane telah dikosongkan.'),
                      backgroundColor: Color(0xFF162416),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ],
        );

        if (constraints.maxWidth < 420) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF090D09),
              border: Border(
                bottom: BorderSide(color: Color(0xFF192519), width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                leftBrandBlock,
                const SizedBox(height: 8),
                Center(child: centerSwitcherBlock),
                if (showPowerLaneActions) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: rightActionsBlock,
                  ),
                ],
              ],
            ),
          );
        }

        if (isNarrow) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF090D09),
              border: Border(
                bottom: BorderSide(color: Color(0xFF192519), width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: leftBrandBlock),
                    const SizedBox(width: 8),
                    rightActionsBlock,
                  ],
                ),
                const SizedBox(height: 10),
                centerSwitcherBlock,
              ],
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF090D09),
            border: Border(
              bottom: BorderSide(color: Color(0xFF192519), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [leftBrandBlock, rightActionsBlock],
              ),
              Center(child: centerSwitcherBlock),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTabPill({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? HokTheme.neonLime : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: HokTheme.neonLime.withValues(alpha: 0.3),
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
              icon,
              size: 14,
              color: isActive ? HokTheme.darkText : HokTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? HokTheme.darkText : HokTheme.textSecondary,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF121912),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF223222)),
          ),
          child: Center(child: Icon(icon, color: Colors.white70, size: 16)),
        ),
      ),
    );
  }
}
