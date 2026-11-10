import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/core/utils/wr_calculator.dart';

/// ViewModel untuk fitur Penghitung Win Rate.
/// Mengelola input state dan kalkulasi WR.
class WinRateViewModel extends ChangeNotifier {
  int _totalMatch = 100;
  double _currentPercent = 50.0;
  double _targetPercent = 60.0;
  double _dropTargetPercent = 45.0;

  int get totalMatch => _totalMatch;
  double get currentPercent => _currentPercent;
  double get targetPercent => _targetPercent;
  double get dropTargetPercent => _dropTargetPercent;

  // Computed values
  int get currentWins =>
      (_totalMatch * (_currentPercent / 100.0)).round();

  int? get requiredWinStreak => WrCalculator.calculateRequiredWinStreak(
    totalMatch: _totalMatch,
    currentWRPercent: _currentPercent,
    targetWRPercent: _targetPercent,
  );

  int? get allowedLoseStreak => WrCalculator.calculateLoseStreakToDrop(
    totalMatch: _totalMatch,
    currentWRPercent: _currentPercent,
    targetLowerWRPercent: _dropTargetPercent,
  );

  void updateTotalMatch(int val) {
    _totalMatch = val.clamp(1, 999999);
    notifyListeners();
  }

  void updateCurrentPercent(double val) {
    _currentPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  void updateTargetPercent(double val) {
    _targetPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  void updateDropTargetPercent(double val) {
    _dropTargetPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }
}
