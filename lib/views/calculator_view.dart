import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/calculator_provider.dart';
import '../widgets/gameland_hero_header.dart';
import '../widgets/gameland_lane_view.dart';
import '../widgets/gameland_navbar.dart';
import '../widgets/hero_detail_tab_view.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return Scaffold(
      backgroundColor: HokTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. TOP NAVBAR ALA GAMELAND (Termasuk Switcher Power Lane & Rincian Hero di Atas)
              const GamelandNavbar(),

              // 2. MAIN CONTAINER WITH MAX-WIDTH (RESPONSIVE)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Hero Header (Title, Subtitle, Category Pills 5 Lane)
                        const GamelandHeroHeader(),

                        // Content (Lane View vs Hero Power Detail View)
                        if (provider.activeTab == CalculatorTab.lane)
                          const GamelandLaneView()
                        else
                          const HeroDetailTabView(),

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HOK Power Calculator © 2026 • Gameland SaaS Style',
                style: TextStyle(color: HokTheme.textMuted, fontSize: 11),
              ),
              Row(
                children: [
                  Text(
                    'Honor of Kings In-Game Logic',
                    style: TextStyle(color: HokTheme.limeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
