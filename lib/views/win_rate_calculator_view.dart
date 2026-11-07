import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';

class WinRateCalculatorView extends StatefulWidget {
  const WinRateCalculatorView({super.key});

  @override
  State<WinRateCalculatorView> createState() => _WinRateCalculatorViewState();
}

class _WinRateCalculatorViewState extends State<WinRateCalculatorView> {
  late TextEditingController _totalMatchController;
  late TextEditingController _currentWrController;
  late TextEditingController _targetWrController;
  late TextEditingController _targetDropWrController;

  @override
  void initState() {
    super.initState();
    final p = context.read<CalculatorProvider>();
    _totalMatchController = TextEditingController(text: p.wrTotalMatch.toString());
    _currentWrController = TextEditingController(text: p.wrCurrentPercent.toStringAsFixed(1));
    _targetWrController = TextEditingController(text: p.wrTargetPercent.toStringAsFixed(1));
    _targetDropWrController = TextEditingController(text: p.wrDropTargetPercent.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _totalMatchController.dispose();
    _currentWrController.dispose();
    _targetWrController.dispose();
    _targetDropWrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final isWinStreak = provider.isWrWinStreakMode;

    return Column(
      children: [
        const SizedBox(height: 14),

        // 1. Top Mini Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF111711),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF233223)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '⚡ GAMELAND TOOLS  •  PENGHITUNG WIN RATE',
                style: TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Big Title
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Win Rate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C271C),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E422E)),
                ),
                child: const Text('🎯', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 3. Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: const Text(
            'Kalkulator pintar ala johsteven/penghitung-wr untuk menghitung target kemenangan berturut-turut (win streak) atau batas kekalahan (lose streak).',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 4. Mode Switcher (Win Streak vs Lose Streak)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF0E140E),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF1E2B1E)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModePill(
                label: 'Target Win Streak',
                icon: Icons.trending_up_rounded,
                isSelected: isWinStreak,
                onTap: () => provider.setWrWinStreakMode(true),
              ),
              _buildModePill(
                label: 'Batas Lose Streak',
                icon: Icons.trending_down_rounded,
                isSelected: !isWinStreak,
                onTap: () => provider.setWrWinStreakMode(false),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 5. BANNER HASIL KALKULASI REAL-TIME
        _buildResultBanner(provider, isWinStreak),

        const SizedBox(height: 20),

        // 6. FORM INPUT (MATCH, CURRENT WR, TARGET WR)
        _buildInputCard(provider, isWinStreak),

        const SizedBox(height: 20),

        // 7. FORMULA PENJELASAN
        _buildFormulaExplanationCard(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildModePill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? HokTheme.neonLime : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: HokTheme.neonLime.withValues(alpha: 0.35),
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
                size: 15,
                color: isSelected ? HokTheme.darkText : HokTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? HokTheme.darkText : HokTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Banner Hasil Utama dengan Glow
  Widget _buildResultBanner(CalculatorProvider provider, bool isWinStreak) {
    if (isWinStreak) {
      final reqWins = provider.wrRequiredWinStreak;
      final currentWins = provider.wrCurrentWins;
      final isImpossible = provider.wrTargetPercent >= 100.0 && currentWins < provider.wrTotalMatch;
      final isAlreadyAchieved = provider.wrTargetPercent <= provider.wrCurrentPercent;

      String mainText;
      String subText;

      if (isImpossible) {
        mainText = 'Mustahil Dicapai (100% WR)';
        subText = 'Kamu sudah pernah kalah di pertandingan sebelumnya, sehingga 100% WR tidak bisa dicapai lagi.';
      } else if (isAlreadyAchieved) {
        mainText = 'Target Sudah Tercapai! 🎉';
        subText = 'Win Rate kamu saat ini (${provider.wrCurrentPercent.toStringAsFixed(1)}%) sudah memenuhi atau melampaui target (${provider.wrTargetPercent.toStringAsFixed(1)}%).';
      } else {
        final totalWinsAfter = currentWins + (reqWins ?? 0);
        final totalMatchAfter = provider.wrTotalMatch + (reqWins ?? 0);
        mainText = 'Perlu ${HOKUtils.formatNumber(reqWins ?? 0)} Match Win Streak';
        subText = 'Kamu harus menang $reqWins kali berturut-turut tanpa kekalahan. Total Match akan menjadi $totalMatchAfter match dengan $totalWinsAfter kemenangan.';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0C120C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E2D1E)),
          boxShadow: [
            BoxShadow(
              color: HokTheme.neonLime.withValues(alpha: 0.1),
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
              child: const Text(
                'HASIL KALKULASI WIN STREAK',
                style: TextStyle(
                  color: HokTheme.neonLime,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              mainText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isImpossible ? HokTheme.redAccent : Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HokTheme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildStatPill('Total Match', '${provider.wrTotalMatch}'),
                _buildStatPill('Kemenangan Saat Ini', '$currentWins win'),
                _buildStatPill('WR Sekarang', '${provider.wrCurrentPercent.toStringAsFixed(1)}%'),
                _buildStatPill('Target WR', '${provider.wrTargetPercent.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      );
    } else {
      // Lose Streak Mode
      final maxLosses = provider.wrAllowedLoseStreak;
      final currentWins = provider.wrCurrentWins;
      final isAlreadyLower = provider.wrDropTargetPercent >= provider.wrCurrentPercent;

      String mainText;
      String subText;

      if (isAlreadyLower) {
        mainText = 'WR Sekarang Sudah di Bawah Target';
        subText = 'Win Rate kamu saat ini (${provider.wrCurrentPercent.toStringAsFixed(1)}%) sudah lebih rendah dari ${provider.wrDropTargetPercent.toStringAsFixed(1)}%.';
      } else {
        final totalMatchAfter = provider.wrTotalMatch + (maxLosses ?? 0);
        mainText = 'WR Turun Jika Kalah ${HOKUtils.formatNumber(maxLosses ?? 0)} Kali Berturut-turut';
        subText = 'Jika kamu kalah $maxLosses match berturut-turut, WR kamu akan turun hingga menyentuh ${provider.wrDropTargetPercent.toStringAsFixed(1)}% di total $totalMatchAfter match.';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0C120C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E2D1E)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: HokTheme.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: HokTheme.redAccent.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'SIMULASI BATAS LOSE STREAK',
                style: TextStyle(
                  color: HokTheme.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              mainText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12, height: 1.4),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF141C14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF223022)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(color: HokTheme.textSecondary, fontSize: 11)),
          Text(value, style: const TextStyle(color: HokTheme.neonLime, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  // Kartu Input Data
  Widget _buildInputCard(CalculatorProvider provider, bool isWinStreak) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0D130D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parameter Data Akun',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Masukkan data pertandingan akunmu dari menu profil game:',
            style: TextStyle(color: HokTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 18),

          // 1. Total Match
          _buildInputField(
            title: 'Total Pertandingan (Match)',
            description: 'Jumlah seluruh match yang sudah kamu mainkan.',
            controller: _totalMatchController,
            suffixText: 'Match',
            onChanged: (val) {
              final n = int.tryParse(val) ?? 1;
              provider.updateWrTotalMatch(n);
            },
          ),

          const SizedBox(height: 16),

          // 2. Win Rate Saat Ini
          _buildInputField(
            title: 'Total Win Rate Saat Ini (%)',
            description: 'Persentase win rate akunmu saat ini (contoh: 54.5).',
            controller: _currentWrController,
            suffixText: '%',
            onChanged: (val) {
              final n = double.tryParse(val) ?? 50.0;
              provider.updateWrCurrentPercent(n);
            },
          ),

          const SizedBox(height: 16),

          // 3. Target Win Rate (atau Drop Target)
          if (isWinStreak) ...[
            _buildInputField(
              title: 'Target Win Rate yang Diinginkan (%)',
              description: 'Persentase win rate impian yang ingin kamu capai.',
              controller: _targetWrController,
              suffixText: '%',
              onChanged: (val) {
                final n = double.tryParse(val) ?? 60.0;
                provider.updateWrTargetPercent(n);
              },
            ),
            const SizedBox(height: 10),
            // Quick preset chips untuk target WR (Wrap agar tidak overflow di layar kecil)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                const Text('Pilih Cepat Target: ', style: TextStyle(color: HokTheme.textMuted, fontSize: 11)),
                ...[55.0, 60.0, 65.0, 70.0, 80.0].map((t) {
                  return InkWell(
                    onTap: () {
                      provider.updateWrTargetPercent(t);
                      _targetWrController.text = t.toStringAsFixed(1);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF162216),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF233223)),
                      ),
                      child: Text(
                        '${t.toInt()}%',
                        style: const TextStyle(color: HokTheme.limeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ] else ...[
            _buildInputField(
              title: 'Batas Penurunan Win Rate (%)',
              description: 'Persentase WR batas bawah jika mengalami lose streak.',
              controller: _targetDropWrController,
              suffixText: '%',
              onChanged: (val) {
                final n = double.tryParse(val) ?? 45.0;
                provider.updateWrDropTargetPercent(n);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required String description,
    required TextEditingController controller,
    required String suffixText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(description, style: const TextStyle(color: HokTheme.textMuted, fontSize: 11)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          decoration: InputDecoration(
            suffixText: suffixText,
            suffixStyle: const TextStyle(color: HokTheme.neonLime, fontWeight: FontWeight.bold),
            fillColor: const Color(0xFF131A13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Kartu Penjelasan Rumus johsteven
  Widget _buildFormulaExplanationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D140D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.functions_rounded, color: HokTheme.neonLime, size: 20),
              SizedBox(width: 8),
              Text(
                'Formula Aljabar (johsteven/penghitung-wr)',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Rumus menghitung tambahan match berturut-turut (x) untuk mencapai target WR (T):\n'
            '• W = Total Kemenangan Awal (Total Match × WR Awal)\n'
            '• Persamaan: (W + x) / (Total Match + x) = Target WR\n'
            '• Solusi: x = ⌈(Target WR × Total Match - W) / (1 - Target WR)⌉',
            style: TextStyle(color: HokTheme.textSecondary, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}

