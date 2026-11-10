/// Pure calculation functions untuk Win Rate Calculator.
/// Semua fungsi bersifat stateless dan tidak bergantung pada framework.
class WrCalculator {
  WrCalculator._();

  /// Hitung total kemenangan dari totalMatch dan WR%
  static int calculateTotalWin(int totalMatch, double currentWR) {
    if (totalMatch <= 0) return 0;
    return (totalMatch * (currentWR / 100.0)).round();
  }

  /// Hitung total kekalahan dari totalMatch dan WR%
  static int calculateTotalLose(int totalMatch, double currentWR) {
    if (totalMatch <= 0) return 0;
    final wins = calculateTotalWin(totalMatch, currentWR);
    final lose = totalMatch - wins;
    return lose >= 0 ? lose : 0;
  }

  /// Hitung jumlah win streak tanpa lose untuk mencapai target WR%
  /// Formula: x = ceil((targetWR * totalMatch - currentWins) / (1 - targetWR))
  static int? calculateRequiredWinStreak({
    required int totalMatch,
    required double currentWRPercent,
    required double targetWRPercent,
  }) {
    if (totalMatch <= 0) return 0;
    if (targetWRPercent <= currentWRPercent) return 0;
    if (targetWRPercent >= 100.0) return null; // Mustahil jika pernah kalah

    final t = targetWRPercent / 100.0;
    final currentWins = totalMatch * (currentWRPercent / 100.0);
    final requiredWins = ((t * totalMatch) - currentWins) / (1.0 - t);
    if (requiredWins < 0) return 0;
    return requiredWins.ceil();
  }

  /// Hitung WR baru setelah lose streak sebanyak N kali
  static double calculateWrAfterLoseStreak({
    required int totalMatch,
    required double currentWRPercent,
    required int loseStreak,
  }) {
    if (totalMatch <= 0) return 0.0;
    final currentWins = calculateTotalWin(totalMatch, currentWRPercent);
    final newTotalMatch = totalMatch + loseStreak;
    if (newTotalMatch <= 0) return 0.0;
    final newWr = (currentWins / newTotalMatch) * 100.0;
    return double.parse(newWr.toStringAsFixed(1));
  }

  /// Hitung berapa kali kalah berturut-turut sebelum WR turun ke persentase target
  static int? calculateLoseStreakToDrop({
    required int totalMatch,
    required double currentWRPercent,
    required double targetLowerWRPercent,
  }) {
    if (totalMatch <= 0) return 0;
    if (targetLowerWRPercent >= currentWRPercent) return 0;
    if (targetLowerWRPercent <= 0.0) return null;

    final t = targetLowerWRPercent / 100.0;
    final currentWins = totalMatch * (currentWRPercent / 100.0);
    final allowedLosses = (currentWins / t) - totalMatch;
    if (allowedLosses < 0) return 0;
    return allowedLosses.floor();
  }
}

