import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/models/hero_detail_model.dart';

/// ViewModel untuk tab Rincian Hero Power Individual.
class HeroDetailViewModel extends ChangeNotifier {
  HeroPowerDetail _detail = HeroPowerDetail();

  HeroPowerDetail get detail => _detail;
  HeroPowerDetail get heroDetail => _detail;

  void updatePerformaRanked(int val) {
    _detail = _detail.copyWith(
      powerPerformaRanked: val.clamp(0, 2500),
    );
    notifyListeners();
  }

  void updatePerformaPeak(int val) {
    _detail = _detail.copyWith(
      powerPerformaPeak: val.clamp(0, _detail.peakPowerCap),
    );
    notifyListeners();
  }

  void updateSelectedPeakTier(int tierPoints) {
    final newDetail = _detail.copyWith(selectedPeakPointsTier: tierPoints);
    final clampedPeak = _detail.powerPerformaPeak > newDetail.peakPowerCap
        ? newDetail.peakPowerCap
        : _detail.powerPerformaPeak;
    final newPoinPeak = _detail.poinPeakSaatIni < tierPoints
        ? tierPoints
        : _detail.poinPeakSaatIni;
    _detail = newDetail.copyWith(
      powerPerformaPeak: clampedPeak,
      poinPeakSaatIni: newPoinPeak,
    );
    notifyListeners();
  }

  void updatePowerKemenangan(int val) {
    _detail = _detail.copyWith(powerKemenangan: val.clamp(0, 3000));
    notifyListeners();
  }

  void updatePoinPeak(int val) {
    final sanitized = val < 1200 ? 1200 : val.clamp(1200, 3500);
    int matchedTier = 1200;
    for (final tier in kPeakCapTiers) {
      if (sanitized >= tier.peakPoints) {
        matchedTier = tier.peakPoints;
      }
    }
    final clampedPeak = _detail.powerPerformaPeak > _detail.peakPowerCap
        ? _detail.peakPowerCap
        : _detail.powerPerformaPeak;
    _detail = _detail.copyWith(
      poinPeakSaatIni: sanitized,
      selectedPeakPointsTier: matchedTier,
      powerPerformaPeak: clampedPeak,
    );
    notifyListeners();
  }

  void updateKeaktifan(double val) {
    _detail = _detail.copyWith(
      pengaliKeaktifanPercent: val.clamp(0.0, 100.0),
    );
    notifyListeners();
  }
}
