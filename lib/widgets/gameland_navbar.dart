import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';

class GamelandNavbar extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const GamelandNavbar({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 720;

        final leftBrandBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Garis 3 (Menu Drawer Sidebar)
            InkWell(
              onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 38,
                height: 38,
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
              child: const Center(
                child: Icon(
                  Icons.sports_esports_rounded,
                  color: HokTheme.darkText,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                provider.activeScreen == AppScreen.powerCalculator
                    ? 'HOK Power'
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
            provider.activeScreen == AppScreen.powerCalculator
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
                        isActive: provider.activeTab == CalculatorTab.lane,
                        onTap: () => provider.setTab(CalculatorTab.lane),
                      ),
                      _buildTabPill(
                        label: 'Rincian Hero',
                        icon: Icons.calculate_outlined,
                        isActive: provider.activeTab == CalculatorTab.hero,
                        onTap: () => provider.setTab(CalculatorTab.hero),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
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
                      'Win Rate Tool',
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
            provider.activeScreen == AppScreen.powerCalculator &&
            provider.activeTab == CalculatorTab.lane;

        final rightActionsBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPowerLaneActions) ...[
              // Pill Muat Contoh HoK
              InkWell(
                onTap: () {
                  provider.resetToSampleData();
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
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
                  provider.clearCurrentLane();
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

        if (isNarrow) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
          width: 34,
          height: 34,
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
