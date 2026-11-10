import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/features/hero_detail/view/hero_detail_view.dart';
import 'package:hitung_power_hero_hok/features/power_lane/view/power_lane_view.dart';
import 'package:hitung_power_hero_hok/features/shell/view/gameland_navbar.dart';
import 'package:hitung_power_hero_hok/features/shell/view/gameland_sidebar.dart';
import 'package:hitung_power_hero_hok/features/shell/viewmodel/shell_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/win_rate/view/win_rate_view.dart';

class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final shellVM = context.watch<ShellViewModel>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HokTheme.darkBackground,
      // SIDEBAR MENU DRAWER DI KIRI
      drawer: const GamelandSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP NAVBAR ALA GAMELAND (TETAP DIAM DI ATAS)
            GamelandNavbar(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),

            // 2. KONTEN HALAMAN
            Expanded(
              child: shellVM.activeScreen == AppScreen.powerCalculator
                  ? (shellVM.activeTab == CalculatorTab.lane
                        ? const PowerLaneView()
                        : const HeroDetailView())
                  : const WinRateView(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility typedef
typedef CalculatorView = ShellView;
