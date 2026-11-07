import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/utils.dart';

enum WrMode {
  winStreak,    // Hitung Win Streak (Home)
  loseStreak,   // Hitung WR dengan lose streak
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

  final TextEditingController _matchController = TextEditingController(text: '100');
  final TextEditingController _wrController = TextEditingController(text: '50');
  final TextEditingController _targetWrController = TextEditingController(text: '60');
  final TextEditingController _loseStreakController = TextEditingController(text: '5');

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Mode Selector Pills ───
              _buildModeSelector(),

              const SizedBox(height: 20),

              // ─── Header Banner ───
              _buildHeaderBanner(),

              const SizedBox(height: 20),

              // ─── Form Card ───
              _buildFormCard(),

              const SizedBox(height: 16),

              // ─── Result Card ───
              if (_hasCalculated) _buildResultCard(),

              const SizedBox(height: 16),

              // ─── Quick Nav Links ───
              _buildQuickNavLinks(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  MODE SELECTOR (Pill tabs matching Gameland lane pills)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: HokTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HokTheme.cardBorder),
      ),
      child: Row(
        children: WrMode.values.map((mode) {
          final isActive = mode == _mode;
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
              onTap: () {
                setState(() => _mode = mode);
                _calculate();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? HokTheme.neonLime : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: HokTheme.neonLime.withValues(alpha: 0.3),
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
                      color: isActive ? HokTheme.darkText : HokTheme.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isActive ? HokTheme.darkText : HokTheme.textMuted,
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
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
              border: Border.all(color: HokTheme.neonLime.withValues(alpha: 0.3)),
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
            icon: Icons.sports_esports_rounded,
            label: 'Total Match',
            controller: _matchController,
            suffixText: 'match',
          ),

          const SizedBox(height: 14),

          // 2. Total WR
          _buildInputGroup(
            icon: Icons.percent_rounded,
            label: 'Win Rate Saat Ini',
            controller: _wrController,
            suffixText: '%',
          ),

          const SizedBox(height: 14),

          // 3. Input Ketiga (Tergantung Mode)
          if (_mode == WrMode.winStreak)
            _buildInputGroup(
              icon: Icons.flag_rounded,
              label: 'Target Win Rate',
              controller: _targetWrController,
              suffixText: '%',
            )
          else if (_mode == WrMode.loseStreak)
            _buildInputGroup(
              icon: Icons.heart_broken_rounded,
              label: 'Jumlah Lose Streak',
              controller: _loseStreakController,
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
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: HokTheme.neonLime.withValues(alpha: 0.7)),
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141E14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              borderSide: const BorderSide(color: HokTheme.neonLime, width: 1.5),
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
        border: Border.all(
          color: HokTheme.neonLime.withValues(alpha: 0.2),
        ),
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
            child: const Icon(Icons.warning_rounded, color: HokTheme.redAccent, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Target WR 100% mustahil dicapai jika sudah pernah mengalami kekalahan.',
              style: TextStyle(color: HokTheme.redAccent, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Icon(Icons.emoji_events_rounded, color: HokTheme.neonLime, size: 32),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: HokTheme.textSecondary, fontSize: 13, height: 1.6),
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
              const TextSpan(text: ' win berturut-turut\nuntuk mencapai win rate '),
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
      ],
    );
  }

  Widget _buildLoseStreakResult() {
    return Column(
      children: [
        const Icon(Icons.trending_down_rounded, color: HokTheme.redAccent, size: 32),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: HokTheme.textSecondary, fontSize: 13, height: 1.6),
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
                  color: (_resultNewWr ?? 0) < 50 ? HokTheme.redAccent : HokTheme.neonLime,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckWinLoseResult() {
    return Row(
      children: [
        // Win Side
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: HokTheme.neonLime.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: HokTheme.neonLime.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: HokTheme.neonLime, size: 24),
                const SizedBox(height: 6),
                Text(
                  '$_resultTotalWin',
                  style: const TextStyle(
                    color: HokTheme.neonLime,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Win',
                  style: TextStyle(color: HokTheme.textSecondary, fontSize: 12),
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
              border: Border.all(color: HokTheme.redAccent.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                const Icon(Icons.cancel_rounded, color: HokTheme.redAccent, size: 24),
                const SizedBox(height: 6),
                Text(
                  '$_resultTotalLose',
                  style: const TextStyle(
                    color: HokTheme.redAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Lose',
                  style: TextStyle(color: HokTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  QUICK NAV LINKS (Neon lime text links instead of yellow)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildQuickNavLinks() {
    final List<({String label, IconData icon, VoidCallback onTap})> links = [];

    if (_mode != WrMode.winStreak) {
      links.add((
        label: 'Kembali ke Hitung Win Streak',
        icon: Icons.trending_up_rounded,
        onTap: () {
          setState(() => _mode = WrMode.winStreak);
          _calculate();
        },
      ));
    }
    if (_mode != WrMode.loseStreak) {
      links.add((
        label: 'Hitung WR dengan Lose Streak',
        icon: Icons.trending_down_rounded,
        onTap: () {
          setState(() => _mode = WrMode.loseStreak);
          _calculate();
        },
      ));
    }
    if (_mode != WrMode.checkWinLose) {
      links.add((
        label: 'Cek Total Win atau Lose',
        icon: Icons.pie_chart_rounded,
        onTap: () {
          setState(() => _mode = WrMode.checkWinLose);
          _calculate();
        },
      ));
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D130D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        children: links.map((link) {
          return InkWell(
            onTap: link.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(link.icon, size: 14, color: HokTheme.neonLime.withValues(alpha: 0.7)),
                  const SizedBox(width: 8),
                  Text(
                    link.label,
                    style: TextStyle(
                      color: HokTheme.neonLime.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
