import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/core/numeric_input_formatter.dart';
import 'package:hitung_power_hero_hok/core/utils.dart';
import 'package:hitung_power_hero_hok/features/shell/view/gameland_footer.dart';

enum WrMode {
  winStreak, // Hitung Win Streak (Home)
  loseStreak, // Hitung WR dengan lose streak
  checkWinLose, // Cek total win atau lose
}

class WinRateCalculatorView extends StatefulWidget {
  const WinRateCalculatorView({super.key});

  @override
  State<WinRateCalculatorView> createState() => _WinRateCalculatorViewState();
}

class _WinRateCalculatorViewState extends State<WinRateCalculatorView>
    with SingleTickerProviderStateMixin {
  WrMode _mode = WrMode.winStreak;

  final TextEditingController _matchController = TextEditingController();
  final TextEditingController _wrController = TextEditingController();
  final TextEditingController _targetWrController = TextEditingController();
  final TextEditingController _loseStreakController = TextEditingController();

  bool _hasCalculated = true;
  int? _resultWinStreak;
  double? _resultNewWr;
  int? _resultTotalWin;
  int? _resultTotalLose;
  int _lastCalculatedTargetWr = 60;
  int _lastCalculatedLoseStreak = 5;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _matchController.dispose();
    _wrController.dispose();
    _targetWrController.dispose();
    _loseStreakController.dispose();
    super.dispose();
  }

  void _calculate() {
    final match = int.tryParse(_matchController.text) ?? 100;
    final wr = double.tryParse(_wrController.text) ?? 50.0;

    setState(() {
      _hasCalculated = true;
      if (_mode == WrMode.winStreak) {
        final targetWr = double.tryParse(_targetWrController.text) ?? 60.0;
        _lastCalculatedTargetWr = targetWr.toInt();
        _resultWinStreak = HOKUtils.calculateRequiredWinStreak(
          totalMatch: match,
          currentWRPercent: wr,
          targetWRPercent: targetWr,
        );
      } else if (_mode == WrMode.loseStreak) {
        final loseStreak = int.tryParse(_loseStreakController.text) ?? 5;
        _lastCalculatedLoseStreak = loseStreak;
        _resultNewWr = HOKUtils.calculateWrAfterLoseStreak(
          totalMatch: match,
          currentWRPercent: wr,
          loseStreak: loseStreak,
        );
      } else if (_mode == WrMode.checkWinLose) {
        _resultTotalWin = HOKUtils.calculateTotalWin(match, wr);
        _resultTotalLose = HOKUtils.calculateTotalLose(match, wr);
      }
    });
  }

  String get _modeTitle {
    switch (_mode) {
      case WrMode.winStreak:
        return 'Hitung Win Streak';
      case WrMode.loseStreak:
        return 'Hitung WR × Lose Streak';
      case WrMode.checkWinLose:
        return 'Cek Total Win / Lose';
    }
  }

  String get _modeSubtitle {
    switch (_mode) {
      case WrMode.winStreak:
        return 'Berapa kali harus menang tanpa kalah untuk mencapai target WR';
      case WrMode.loseStreak:
        return 'Prediksi WR baru setelah mengalami lose streak berturut-turut';
      case WrMode.checkWinLose:
        return 'Cek jumlah win dan lose berdasarkan match dan WR saat ini';
    }
  }

  IconData get _modeIcon {
    switch (_mode) {
      case WrMode.winStreak:
        return Icons.trending_up_rounded;
      case WrMode.loseStreak:
        return Icons.trending_down_rounded;
      case WrMode.checkWinLose:
        return Icons.pie_chart_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        // 1. Header Banner
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHeaderBanner(),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // 2. Floating Mode Selector (Melayang/pinned saat di-scroll)
        SliverPersistentHeader(
          pinned: true,
          delegate: _WrModeSelectorDelegate(
            selectedMode: _mode,
            onModeChanged: (mode) {
              setState(() => _mode = mode);
              _calculate();
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // 3. Form Card, Result Card (dengan visualisasi fl_chart), Quick Nav, dan Footer
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Input Card
                    _buildFormCard(),

                    const SizedBox(height: 16),

                    // Result Card (dengan visualisasi fl_chart)
                    if (_hasCalculated) _buildResultCard(),

                    const SizedBox(height: 28),

                    // Gameland Footer
                    const GamelandFooter(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HEADER BANNER (Ambient glow like hero detail banner)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0C120C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E2D1E)),
        boxShadow: [
          BoxShadow(
            color: HokTheme.neonLime.withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: HokTheme.neonLime.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: HokTheme.neonLime.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _modeTitle,
              style: const TextStyle(
                color: HokTheme.neonLime,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Icon(
            _modeIcon,
            size: 40,
            color: HokTheme.neonLime.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          Text(
            _modeSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  FORM CARD (Gameland dark card style)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D130D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Total match
          _buildInputGroup(
            useAppIcon: true,
            label: 'Total Match',
            controller: _matchController,
            hintText: '100',
            suffixText: 'match',
          ),

          const SizedBox(height: 14),

          // 2. Total WR
          _buildInputGroup(
            icon: Icons.percent_rounded,
            label: 'Win Rate Saat Ini',
            controller: _wrController,
            hintText: '50',
            suffixText: '%',
            allowDecimal: true,
          ),

          const SizedBox(height: 14),

          // 3. Input Ketiga (Tergantung Mode)
          if (_mode == WrMode.winStreak)
            _buildInputGroup(
              icon: Icons.flag_rounded,
              label: 'Target Win Rate',
              controller: _targetWrController,
              hintText: '60',
              suffixText: '%',
              allowDecimal: true,
            )
          else if (_mode == WrMode.loseStreak)
            _buildInputGroup(
              icon: Icons.heart_broken_rounded,
              label: 'Jumlah Lose Streak',
              controller: _loseStreakController,
              hintText: '5',
              suffixText: '×',
            ),

          const SizedBox(height: 20),

          // Tombol "Hitung" Neon Lime
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: HokTheme.neonLime,
                foregroundColor: HokTheme.darkText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: HokTheme.neonLime.withValues(alpha: 0.4),
              ),
              icon: const Icon(Icons.calculate_rounded, size: 20),
              label: const Text(
                'Hitung Sekarang',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup({
    IconData? icon,
    bool useAppIcon = false,
    required String label,
    required TextEditingController controller,
    String? hintText,
    String? suffixText,
    bool allowDecimal = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (useAppIcon)
              Image.asset(
                'assets/icon_app.png',
                width: 14,
                height: 14,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                size: 14,
                color: HokTheme.neonLime.withValues(alpha: 0.7),
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: HokTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          inputFormatters: [
            NumericInputFormatter(context: context, allowDecimal: allowDecimal),
          ],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: HokTheme.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFF141E14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            suffixText: suffixText,
            suffixStyle: TextStyle(
              color: HokTheme.neonLime.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF223022)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF223022)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: HokTheme.neonLime,
                width: 1.5,
              ),
            ),
          ),
          onSubmitted: (_) => _calculate(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  RESULT CARD (Gameland ambient glow)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0C120C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HokTheme.neonLime.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: HokTheme.neonLime.withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _buildResultContent(),
    );
  }

  Widget _buildResultContent() {
    if (_mode == WrMode.winStreak) {
      return _buildWinStreakResult();
    } else if (_mode == WrMode.loseStreak) {
      return _buildLoseStreakResult();
    } else {
      return _buildCheckWinLoseResult();
    }
  }

  Widget _buildWinStreakResult() {
    if (_resultWinStreak == null) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HokTheme.redAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: HokTheme.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Target WR 100% mustahil dicapai jika sudah pernah mengalami kekalahan.',
              style: TextStyle(
                color: HokTheme.redAccent,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      );
    }

    final currentWr = double.tryParse(_wrController.text) ?? 50.0;
    final targetWr = double.tryParse(_targetWrController.text) ?? 60.0;

    return Column(
      children: [
        const Icon(
          Icons.emoji_events_rounded,
          color: HokTheme.neonLime,
          size: 32,
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
            children: [
              const TextSpan(text: 'Kamu perlu '),
              TextSpan(
                text: '$_resultWinStreak',
                style: const TextStyle(
                  color: HokTheme.neonLime,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              const TextSpan(
                text: ' win berturut-turut\nuntuk mencapai win rate ',
              ),
              TextSpan(
                text: '$_lastCalculatedTargetWr%',
                style: const TextStyle(
                  color: HokTheme.neonLime,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF1B2B1B), height: 1),
        const SizedBox(height: 14),
        // Visualisasi fl_chart BarChart perbandingan WR Saat Ini vs Target
        _buildComparisonBarChart(
          labelA: 'Saat Ini',
          valueA: currentWr,
          colorA: const Color(0xFF2C3E2C),
          labelB: 'Target',
          valueB: targetWr,
          colorB: HokTheme.neonLime,
        ),
      ],
    );
  }

  Widget _buildLoseStreakResult() {
    final currentWr = double.tryParse(_wrController.text) ?? 50.0;
    final newWr = _resultNewWr ?? currentWr;

    return Column(
      children: [
        const Icon(
          Icons.trending_down_rounded,
          color: HokTheme.redAccent,
          size: 32,
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
            children: [
              const TextSpan(text: 'Jika kamu lose streak sebanyak '),
              TextSpan(
                text: '$_lastCalculatedLoseStreak',
                style: const TextStyle(
                  color: HokTheme.redAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const TextSpan(text: ' kali,\nmaka WR kamu menjadi '),
              TextSpan(
                text: '${_resultNewWr?.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: (_resultNewWr ?? 0) < 50
                      ? HokTheme.redAccent
                      : HokTheme.neonLime,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF1B2B1B), height: 1),
        const SizedBox(height: 14),
        // Visualisasi fl_chart BarChart perbandingan WR Sebelum vs Setelah Lose Streak
        _buildComparisonBarChart(
          labelA: 'Sebelum',
          valueA: currentWr,
          colorA: const Color(0xFF2C3E2C),
          labelB: 'Setelah',
          valueB: newWr,
          colorB: HokTheme.redAccent,
        ),
      ],
    );
  }

  Widget _buildCheckWinLoseResult() {
    final win = _resultTotalWin ?? 0;
    final lose = _resultTotalLose ?? 0;
    final total = win + lose;
    final winPercent = total > 0 ? (win / total) * 100 : 0.0;
    final losePercent = total > 0 ? (lose / total) * 100 : 0.0;

    return Column(
      children: [
        // 1. Donut PieChart dari fl_chart
        if (total > 0)
          SizedBox(
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 46,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: HokTheme.neonLime,
                        value: win.toDouble(),
                        title: '${winPercent.toStringAsFixed(0)}%',
                        radius: 26,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: HokTheme.darkText,
                        ),
                      ),
                      PieChartSectionData(
                        color: HokTheme.redAccent,
                        value: lose.toDouble(),
                        title: '${losePercent.toStringAsFixed(0)}%',
                        radius: 26,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${winPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'WIN RATE',
                      style: TextStyle(
                        color: HokTheme.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // 2. Kotak Angka Rincian Win & Lose
        Row(
          children: [
            // Win Side
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: HokTheme.neonLime.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HokTheme.neonLime.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: HokTheme.neonLime,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$win',
                      style: const TextStyle(
                        color: HokTheme.neonLime,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Win',
                      style: TextStyle(
                        color: HokTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Lose Side
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: HokTheme.redAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HokTheme.redAccent.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cancel_rounded,
                      color: HokTheme.redAccent,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$lose',
                      style: const TextStyle(
                        color: HokTheme.redAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Lose',
                      style: TextStyle(
                        color: HokTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  FL_CHART HELPER: BAR CHART PERBANDINGAN WR
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildComparisonBarChart({
    required String labelA,
    required double valueA,
    required Color colorA,
    required String labelB,
    required double valueB,
    required Color colorB,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            const Text(
              'Perbandingan Win Rate',
              style: TextStyle(
                color: HokTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildChartLegend(labelA, colorA),
                const SizedBox(width: 10),
                _buildChartLegend(labelB, colorB),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 165,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF141F14),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = groupIndex == 0 ? labelA : labelB;
                    return BarTooltipItem(
                      '$label: ${rod.toY.toStringAsFixed(1)}%',
                      const TextStyle(
                        color: HokTheme.neonLime,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 25,
                    getTitlesWidget: (val, meta) => Text(
                      '${val.toInt()}%',
                      style: const TextStyle(
                        color: HokTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (val, meta) {
                      final isFirst = val == 0;
                      final title = isFirst ? labelA : labelB;
                      final percent = isFirst ? valueA : valueB;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '$title\n${percent.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isFirst ? colorA : colorB,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (val) => const FlLine(
                  color: Color(0xFF182418),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: valueA.clamp(0, 100),
                      color: colorA,
                      width: 32,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: valueB.clamp(0, 100),
                      color: colorB,
                      width: 32,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: HokTheme.textMuted, fontSize: 10),
        ),
      ],
    );
  }

}


// ═══════════════════════════════════════════════════════════════════════════
//  WIN RATE MODE SELECTOR FLOATING DELEGATE
//  Menempel (pinned) di bawah navbar saat halaman Penghitung WR di-scroll.
// ═══════════════════════════════════════════════════════════════════════════
class _WrModeSelectorDelegate extends SliverPersistentHeaderDelegate {
  const _WrModeSelectorDelegate({
    required this.selectedMode,
    required this.onModeChanged,
  });

  final WrMode selectedMode;
  final ValueChanged<WrMode> onModeChanged;

  static const double _height = 70;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: HokTheme.darkBackground,
      alignment: Alignment.center,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: HokTheme.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: HokTheme.cardBorder),
              ),
              child: Row(
                children: WrMode.values.map((mode) {
                  final isActive = mode == selectedMode;
                  String label;
                  IconData icon;
                  switch (mode) {
                    case WrMode.winStreak:
                      label = 'Win Streak';
                      icon = Icons.trending_up_rounded;
                    case WrMode.loseStreak:
                      label = 'Lose Streak';
                      icon = Icons.trending_down_rounded;
                    case WrMode.checkWinLose:
                      label = 'Win / Lose';
                      icon = Icons.pie_chart_rounded;
                  }
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onModeChanged(mode),
                      child: AnimatedContainer(
                        key: ValueKey('wr-mode-${mode.name}'),
                        duration: const Duration(milliseconds: 200),
                        constraints: const BoxConstraints(minHeight: 48),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? HokTheme.neonLime
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: HokTheme.neonLime.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 15,
                              color: isActive
                                  ? HokTheme.darkText
                                  : HokTheme.textMuted,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isActive
                                      ? HokTheme.darkText
                                      : HokTheme.textMuted,
                                  fontSize: 12,
                                  fontWeight: isActive
                                      ? FontWeight.w900
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _WrModeSelectorDelegate oldDelegate) => true;
}

/// Backward compatibility typedef
typedef WinRateView = WinRateCalculatorView;
