class HOKUtils {
  // Format angka dengan titik pemisah ribuan ala Indonesia/HoK (contoh: 29782 -> "29.782")
  static String formatNumber(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  // Hitung Subtotal Hero Utama (Bobot 100%)
  static int calculateSubtotalUtama(List<int> heroPowers) {
    return heroPowers.fold(0, (sum, val) => sum + val);
  }

  // Hitung Kontribusi Hero OP (Bobot 20%)
  static int calculateSubtotalOP(List<int> heroPowers) {
    final rawSum = heroPowers.fold(0, (sum, val) => sum + val);
    return (rawSum * 0.2).round();
  }

  // Hitung Total Power Lane
  static int calculatePowerLane(List<int> heroUtama, List<int> heroOP) {
    return calculateSubtotalUtama(heroUtama) + calculateSubtotalOP(heroOP);
  }

  // Hitung Tier dari Total Power Lane (setiap 1000 power = 1 Tier)
  static int calculateTier(int totalPower) {
    return totalPower ~/ 1000;
  }

  // Hitung Pengali Peak dari Poin Tourney (+1% per 20 poin di atas 1200)
  static double calculatePeakMultiplier(int poinTourney) {
    if (poinTourney <= 1200) return 0.0;
    return ((poinTourney - 1200) ~/ 20).toDouble();
  }

  // Hitung Rincian Hero Power Individual: Power Hero = Power Total * Pengali Total
  static int calculateHeroPower({
    required int performaRanked,
    required int performaPeak,
    required int kemenangan,
    required int poinPeak,
    required double keaktifanPercent, // 10 s/d 100
  }) {
    final powerTotal = performaRanked + performaPeak + kemenangan;
    final peakPercent = calculatePeakMultiplier(poinPeak);
    final pengaliPeakFactor = 1.0 + (peakPercent / 100.0);
    final keaktifanFactor = (keaktifanPercent / 100.0).clamp(0.0, 1.0);
    final pengaliTotal = pengaliPeakFactor * keaktifanFactor;
    return (powerTotal * pengaliTotal).round();
  }

  // ==========================================
  // FITUR PENGHITUNG WIN RATE (johsteven/penghitung-wr)
  // ==========================================

  // 1. Hitung Total Kemenangan (Win)
  static int calculateTotalWin(int totalMatch, double currentWR) {
    if (totalMatch <= 0) return 0;
    return (totalMatch * (currentWR / 100.0)).round();
  }

  // 2. Hitung Total Kekalahan (Lose)
  static int calculateTotalLose(int totalMatch, double currentWR) {
    if (totalMatch <= 0) return 0;
    final wins = calculateTotalWin(totalMatch, currentWR);
    final lose = totalMatch - wins;
    return lose >= 0 ? lose : 0;
  }

  // 3. Hitung jumlah match win streak tanpa lose yang dibutuhkan untuk mencapai target Win Rate
  // Formula: x = ceil((targetWR * totalMatch - currentWins) / (1 - targetWR))
  static int? calculateRequiredWinStreak({
    required int totalMatch,
    required double currentWRPercent,
    required double targetWRPercent,
  }) {
    if (totalMatch <= 0) return 0;
    if (targetWRPercent <= currentWRPercent) return 0;
    if (targetWRPercent >= 100.0) {
      return null; // Mustahil dicapai jika pernah kalah
    }

    final t = targetWRPercent / 100.0;
    final currentWins = totalMatch * (currentWRPercent / 100.0);
    final requiredWins = ((t * totalMatch) - currentWins) / (1.0 - t);
    if (requiredWins < 0) return 0;
    return requiredWins.ceil();
  }

  // 4. Hitung Win Rate baru jika mengalami Lose Streak sebanyak N kali
  // Formula: newWR = (currentWins / (totalMatch + loseStreak)) * 100%
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

  // 5. Hitung berapa kali kalah berturut-turut (lose streak) sebelum WR turun ke persentase tertentu
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
