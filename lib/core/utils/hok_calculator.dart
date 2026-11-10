/// Pure calculation functions untuk Power Lane dan Hero Power.
/// Semua fungsi bersifat stateless dan tidak bergantung pada framework.
class HokCalculator {
  HokCalculator._();

  /// Format angka dengan titik pemisah ribuan ala Indonesia/HoK
  /// Contoh: 29782 → "29.782"
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

  /// Total Power 5 Hero Utama (Bobot 100%)
  static int calculateSubtotalUtama(List<int> heroPowers) =>
      heroPowers.fold(0, (sum, val) => sum + val);

  /// Kontribusi Power 5 Hero OP (Bobot 20%)
  static int calculateSubtotalOP(List<int> heroPowers) =>
      (heroPowers.fold(0, (sum, val) => sum + val) * 0.2).round();

  /// Total Power Lane = Subtotal Utama (100%) + Subtotal OP (20%)
  static int calculatePowerLane(List<int> heroUtama, List<int> heroOP) =>
      calculateSubtotalUtama(heroUtama) + calculateSubtotalOP(heroOP);

  /// Tier Lane (kelipatan 1000)
  static int calculateTier(int totalPower) => totalPower ~/ 1000;

  /// Pengali Peak Tourney: +1% setiap 20 poin di atas 1200
  static double calculatePeakMultiplier(int poinTourney) {
    if (poinTourney <= 1200) return 0.0;
    return ((poinTourney - 1200) ~/ 20).toDouble();
  }

  /// Rumus resmi in-game: Power Hero = Power Total × Pengali Total
  static int calculateHeroPower({
    required int performaRanked,
    required int performaPeak,
    required int kemenangan,
    required int poinPeak,
    required double keaktifanPercent,
  }) {
    final powerTotal = performaRanked + performaPeak + kemenangan;
    final peakPercent = calculatePeakMultiplier(poinPeak);
    final pengaliPeakFactor = 1.0 + (peakPercent / 100.0);
    final keaktifanFactor = (keaktifanPercent / 100.0).clamp(0.0, 1.0);
    return (powerTotal * pengaliPeakFactor * keaktifanFactor).round();
  }
}
