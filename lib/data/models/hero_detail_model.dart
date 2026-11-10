class PeakCapTier {
  final int peakPoints;
  final int capPower;

  const PeakCapTier({required this.peakPoints, required this.capPower});
}

// Data Batas Cap Power Performa Peak berdasarkan Poin Peak
const List<PeakCapTier> kPeakCapTiers = [
  PeakCapTier(peakPoints: 1200, capPower: 200),
  PeakCapTier(peakPoints: 1300, capPower: 400),
  PeakCapTier(peakPoints: 1400, capPower: 600),
  PeakCapTier(peakPoints: 1500, capPower: 900),
  PeakCapTier(peakPoints: 1600, capPower: 1200),
  PeakCapTier(peakPoints: 1700, capPower: 1600),
  PeakCapTier(peakPoints: 1800, capPower: 2000),
  PeakCapTier(peakPoints: 1900, capPower: 2500),
  PeakCapTier(peakPoints: 2000, capPower: 3000),
  PeakCapTier(peakPoints: 2100, capPower: 3600),
  PeakCapTier(peakPoints: 2200, capPower: 4200),
  PeakCapTier(peakPoints: 2300, capPower: 4800),
  PeakCapTier(peakPoints: 2400, capPower: 5400),
];

/// Model immutable untuk data rincian Hero Power Individual.
class HeroPowerDetail {
  final int powerPerformaRanked;
  final int powerPerformaPeak;
  final int powerKemenangan;
  final int poinPeakSaatIni;
  final double pengaliKeaktifanPercent; // 10% s/d 100%
  final int selectedPeakPointsTier;

  const HeroPowerDetail({
    this.powerPerformaRanked = 900,
    this.powerPerformaPeak = 200,
    this.powerKemenangan = 100,
    this.poinPeakSaatIni = 1200,
    this.pengaliKeaktifanPercent = 100.0,
    this.selectedPeakPointsTier = 1200,
  });

  HeroPowerDetail copyWith({
    int? powerPerformaRanked,
    int? powerPerformaPeak,
    int? powerKemenangan,
    int? poinPeakSaatIni,
    double? pengaliKeaktifanPercent,
    int? selectedPeakPointsTier,
  }) {
    return HeroPowerDetail(
      powerPerformaRanked: powerPerformaRanked ?? this.powerPerformaRanked,
      powerPerformaPeak: powerPerformaPeak ?? this.powerPerformaPeak,
      powerKemenangan: powerKemenangan ?? this.powerKemenangan,
      poinPeakSaatIni: poinPeakSaatIni ?? this.poinPeakSaatIni,
      pengaliKeaktifanPercent:
          pengaliKeaktifanPercent ?? this.pengaliKeaktifanPercent,
      selectedPeakPointsTier:
          selectedPeakPointsTier ?? this.selectedPeakPointsTier,
    );
  }

  // Batas maksimal (cap) Power Performa Peak berdasarkan tier poin peak yang dipilih
  int get peakPowerCap {
    for (final tier in kPeakCapTiers.reversed) {
      if (selectedPeakPointsTier >= tier.peakPoints) {
        return tier.capPower;
      }
    }
    return 200;
  }

  // Pengali Peak: +1% setiap 20 poin di atas 1200
  double get pengaliPeakPercent {
    if (poinPeakSaatIni <= 1200) return 0.0;
    return ((poinPeakSaatIni - 1200) ~/ 20).toDouble();
  }

  // Power Total = Performa Ranked + Performa Peak + Power Kemenangan
  int get powerTotal =>
      powerPerformaRanked + powerPerformaPeak + powerKemenangan;

  // Pengali Total = (1 + Pengali Peak %) * (Pengali Keaktifan %)
  double get pengaliTotal {
    final peakFactor = 1.0 + (pengaliPeakPercent / 100.0);
    final keaktifanFactor = pengaliKeaktifanPercent / 100.0;
    return peakFactor * keaktifanFactor;
  }

  // Power Hero Akhir = Power Total * Pengali Total
  int get finalHeroPower => (powerTotal * pengaliTotal).round();
}

