import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';
import '../widgets/gameland_hero_header.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final scrolled = _scrollController.offset > 60;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
            // 1. TOP NAVBAR ALA GAMELAND (FLOATING / TETAP DI ATAS SAAT SCROLL)
            GamelandNavbar(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),

            // 2. HASIL TIER / POWER HERO FLOATING (MUNCUL KETIKA SCROLL KE BAWAH)
            if (provider.activeScreen == AppScreen.powerCalculator)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                crossFadeState: _isScrolled
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildFloatingResultBar(provider),
                secondChild: const SizedBox(width: double.infinity, height: 0),
              ),

            // 3. MAIN SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // KONTEN SCREEN 1: KALKULATOR POWER HOK
                          if (provider.activeScreen ==
                              AppScreen.powerCalculator) ...[
                            // Hero Header (Title, Subtitle, Category Pills 5 Lane)
                            const GamelandHeroHeader(),

                            // Content (Lane View vs Hero Power Detail View)
                            if (provider.activeTab == CalculatorTab.lane)
                              const GamelandLaneView()
                            else
                              const HeroDetailTabView(),
                          ]
                          // KONTEN SCREEN 2: PENGHITUNG WIN RATE
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FLOATING RESULT BAR KETIKA BERGESER KE BAWAH ---
  Widget _buildFloatingResultBar(CalculatorProvider provider) {
    final isLaneTab = provider.activeTab == CalculatorTab.lane;

    return InkWell(
      onTap: () {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0C130C),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF1E2E1E), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: HokTheme.neonLime.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: isLaneTab
                      ? _buildFloatingLaneContent(provider)
                      : _buildFloatingHeroContent(provider),
                ),
              ),
            ),
            if (isLaneTab)
              LinearProgressIndicator(
                value: provider.currentLaneData.progressToTarget,
                backgroundColor: const Color(0xFF142014),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  HokTheme.neonLime,
                ),
                minHeight: 2,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingLaneContent(CalculatorProvider provider) {
    final laneData = provider.currentLaneData;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sisi Kiri: Lane Name + Tier Badge
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: laneData.lane.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  laneData.lane.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: HokTheme.neonLime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HokTheme.neonLime.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Tier ${laneData.currentTier}',
                  style: const TextStyle(
                    color: HokTheme.neonLime,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Sisi Kanan: Power Saat Ini & Gap Target
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${HOKUtils.formatNumber(laneData.totalPowerLane)} Power',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  laneData.remainingPowerToTarget > 0
                      ? '(-${HOKUtils.formatNumber(laneData.remainingPowerToTarget)})'
                      : '(Tercapai! 🎉)',
                  style: TextStyle(
                    color: laneData.remainingPowerToTarget > 0
                        ? HokTheme.textSecondary
                        : HokTheme.neonLime,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: HokTheme.neonLime,
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingHeroContent(CalculatorProvider provider) {
    final detail = provider.heroDetail;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sisi Kiri: Label & Ikon
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: HokTheme.neonLime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: HokTheme.neonLime,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  'Power Hero',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Sisi Kanan: Hasil Power Hero & Breakdown
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${HOKUtils.formatNumber(detail.finalHeroPower)} Power',
                  style: const TextStyle(
                    color: HokTheme.neonLime,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${HOKUtils.formatNumber(detail.powerTotal)} × ${(detail.pengaliTotal * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: HokTheme.neonLime,
                  size: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final currentYear = DateTime.now().year.toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Divider(color: Color(0xFF162116), height: 1),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'HOK by 7Sensei © $currentYear • All Rights Reserved',
                style: const TextStyle(color: HokTheme.textMuted, fontSize: 11),
              ),
              const Text(
                'Honor of Kings',
                style: TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
