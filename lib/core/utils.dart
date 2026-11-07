class HOKUtils {
  // Menghitung Power Lane berdasarkan bobot
  static double calculatePowerLane(List<int> heroUtama, List<int> heroOP) {
    int sumUtama = heroUtama.fold(0, (prev, element) => prev + element);
    int sumOP = heroOP.fold(0, (prev, element) => prev + element);

    // Total Hero Utama + (Total Hero OP * 20%)
    return sumUtama + (sumOP * 0.2);
  }
}
