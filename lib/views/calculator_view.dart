import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';
import '../widgets/gameland_lane_view.dart';
import '../widgets/gameland_navbar.dart';
import '../widgets/gameland_sidebar.dart';
import '../widgets/hero_detail_tab_view.dart';
import 'win_rate_calculator_view.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

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

            // 2. KONTEN HALAMAN (Masing-masing memiliki CustomScrollView dengan Collapsible Card)
            Expanded(
              child: provider.activeScreen == AppScreen.powerCalculator
                  ? (provider.activeTab == CalculatorTab.lane
                        ? const GamelandLaneView()
                        : const HeroDetailTabView())
                  : const SingleChildScrollView(child: WinRateCalculatorView()),
            ),
          ],
        ),
      ),
    );
  }
}
