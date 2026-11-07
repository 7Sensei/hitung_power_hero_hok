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
}
