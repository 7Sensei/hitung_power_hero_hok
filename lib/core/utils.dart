// Re-export dari lokasi baru untuk backward compatibility selama refactor.
import 'utils/hok_calculator.dart';
import 'utils/wr_calculator.dart';

export 'utils/hok_calculator.dart';
export 'utils/wr_calculator.dart';

/// Legacy class — delegasi ke HokCalculator & WrCalculator.
/// Dipertahankan agar kode dan test yang merujuk HOKUtils tetap berjalan.
class HOKUtils {
  // ── Format ────────────────────────────────────────────────────────────────
  static String formatNumber(int value) =>
      HokCalculator.formatNumber(value);

  // ── Lane calculation (delegasi ke HokCalculator) ──────────────────────────
  static int calculateSubtotalUtama(List<int> heroPowers) =>
      HokCalculator.calculateSubtotalUtama(heroPowers);

  static int calculateSubtotalOP(List<int> heroPowers) =>
      HokCalculator.calculateSubtotalOP(heroPowers);

  static int calculatePowerLane(List<int> heroUtama, List<int> heroOP) =>
      HokCalculator.calculatePowerLane(heroUtama, heroOP);

  static int calculateTier(int totalPower) =>
      HokCalculator.calculateTier(totalPower);

  // ── Hero power (delegasi ke HokCalculator) ────────────────────────────────
  static double calculatePeakMultiplier(int poinTourney) =>
      HokCalculator.calculatePeakMultiplier(poinTourney);

  static int calculateHeroPower({
    required int performaRanked,
    required int performaPeak,
    required int kemenangan,
    required int poinPeak,
    required double keaktifanPercent,
  }) => HokCalculator.calculateHeroPower(
    performaRanked: performaRanked,
    performaPeak: performaPeak,
    kemenangan: kemenangan,
    poinPeak: poinPeak,
    keaktifanPercent: keaktifanPercent,
  );

  // ── Win Rate (delegasi ke WrCalculator) ───────────────────────────────────
  static int calculateTotalWin(int totalMatch, double currentWR) =>
      WrCalculator.calculateTotalWin(totalMatch, currentWR);

  static int calculateTotalLose(int totalMatch, double currentWR) =>
      WrCalculator.calculateTotalLose(totalMatch, currentWR);

  static int? calculateRequiredWinStreak({
    required int totalMatch,
    required double currentWRPercent,
    required double targetWRPercent,
  }) => WrCalculator.calculateRequiredWinStreak(
    totalMatch: totalMatch,
    currentWRPercent: currentWRPercent,
    targetWRPercent: targetWRPercent,
  );

  static double calculateWrAfterLoseStreak({
    required int totalMatch,
    required double currentWRPercent,
    required int loseStreak,
  }) => WrCalculator.calculateWrAfterLoseStreak(
    totalMatch: totalMatch,
    currentWRPercent: currentWRPercent,
    loseStreak: loseStreak,
  );

  static int? calculateLoseStreakToDrop({
    required int totalMatch,
    required double currentWRPercent,
    required double targetLowerWRPercent,
  }) => WrCalculator.calculateLoseStreakToDrop(
    totalMatch: totalMatch,
    currentWRPercent: currentWRPercent,
    targetLowerWRPercent: targetLowerWRPercent,
  );
}
