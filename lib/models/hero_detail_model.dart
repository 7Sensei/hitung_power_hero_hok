class HeroPowerDetail {
  int powerPerformaRanked;
  int powerPerformaPeak;
  int powerKemenangan;
  int poinPeakSaatIni;
  double pengaliKeaktifanPercent; // 10% s/d 100%

  HeroPowerDetail({
    this.powerPerformaRanked = 900,
    this.powerPerformaPeak = 200,
    this.powerKemenangan = 100,
    this.poinPeakSaatIni = 1260,
    this.pengaliKeaktifanPercent = 100.0,
  });

  // Pengali Peak: +1% setiap 20 poin di atas 1200 (contoh: 1260 = +3%)
  double get pengaliPeakPercent {
    if (poinPeakSaatIni <= 1200) return 0.0;
    return ((poinPeakSaatIni - 1200) ~/ 20).toDouble();
  }

  // Power Total = Performa Ranked + Performa Peak + Power Kemenangan
  int get powerTotal {
    return powerPerformaRanked + powerPerformaPeak + powerKemenangan;
  }

  // Pengali Total = (1 + Pengali Peak %) * (Pengali Keaktifan %)
  double get pengaliTotal {
    final peakFactor = 1.0 + (pengaliPeakPercent / 100.0);
    final keaktifanFactor = pengaliKeaktifanPercent / 100.0;
    return peakFactor * keaktifanFactor;
  }

  // Power Hero Akhir = Power Total * Pengali Total
  int get finalHeroPower {
    return (powerTotal * pengaliTotal).round();
  }
}

