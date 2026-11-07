import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';
import '../widgets/gameland_hero_header.dart';
import '../widgets/gameland_lane_view.dart';
import '../widgets/gameland_navbar.dart';
import '../widgets/gameland_sidebar.dart';
import '../widgets/hero_detail_tab_view.dart';
import 'win_rate_calculator_view.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HokTheme.darkBackground,
      // SIDEBAR MENU DRAWER DI KIRI
      drawer: const GamelandSidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. TOP NAVBAR ALA GAMELAND (Dengan Tombol Garis 3 Menu di Kiri)
              GamelandNavbar(
                onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
              ),

              // 2. MAIN CONTAINER WITH MAX-WIDTH (RESPONSIVE)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // KONTEN SCREEN 1: KALKULATOR POWER HOK
                        if (provider.activeScreen == AppScreen.powerCalculator) ...[
                          // Hero Header (Title, Subtitle, Category Pills 5 Lane)
                          const GamelandHeroHeader(),

                          // Content (Lane View vs Hero Power Detail View)
                          if (provider.activeTab == CalculatorTab.lane)
                            const GamelandLaneView()
                          else
                            const HeroDetailTabView(),
                        ]
                        // KONTEN SCREEN 2: PENGHITUNG WIN RATE (johsteven/penghitung-wr)
                        else ...[
                          const WinRateCalculatorView(),
                        ],

                        // Footer Minimalist
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: const Column(
        children: [
          Divider(color: Color(0xFF162116), height: 1),
          SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'Gameland Tools © 2026 • HOK Power & WR Calculator',
                style: TextStyle(color: HokTheme.textMuted, fontSize: 11),
              ),
              Text(
                'Honor of Kings & MLBB Algorithms',
                style: TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
