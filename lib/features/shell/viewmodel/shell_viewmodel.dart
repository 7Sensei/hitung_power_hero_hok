import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/core/constants.dart';

enum AppScreen {
  powerCalculator,
  winRateCalculator,
}

enum CalculatorTab { lane, hero }

/// ViewModel untuk navigasi shell: screen aktif, tab aktif, lane aktif.
class ShellViewModel extends ChangeNotifier {
  AppScreen _activeScreen = AppScreen.powerCalculator;
  CalculatorTab _activeTab = CalculatorTab.lane;
  HokLane _activeLane = HokLane.clash;

  AppScreen get activeScreen => _activeScreen;
  CalculatorTab get activeTab => _activeTab;
  HokLane get activeLane => _activeLane;

  void setAppScreen(AppScreen screen) {
    _activeScreen = screen;
    notifyListeners();
  }

  void setTab(CalculatorTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  void switchLane(HokLane lane) {
    _activeLane = lane;
    notifyListeners();
  }
}
