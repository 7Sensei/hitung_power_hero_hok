import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../models/hero_detail_model.dart';
import '../models/hero_model.dart';
import '../models/lane_model.dart';

enum AppScreen {
  powerCalculator,     // Kalkulator Power Lane & Hero HoK
  winRateCalculator,   // Penghitung Win Rate (johsteven/penghitung-wr)
}

enum CalculatorTab { lane, hero }

class CalculatorProvider with ChangeNotifier {
  AppScreen activeScreen = AppScreen.powerCalculator;
  CalculatorTab activeTab = CalculatorTab.lane;
  HokLane activeLane = HokLane.clash;

  // State untuk Penghitung Win Rate (johsteven/penghitung-wr)
  int wrTotalMatch = 100;
  double wrCurrentPercent = 50.0;
  double wrTargetPercent = 60.0;
  double wrDropTargetPercent = 45.0;
  bool isWrWinStreakMode = true; // true = target win streak, false = lose streak check

  // Data 5 Lane terpisah
  late Map<HokLane, LaneData> laneDataMap;

  // Data kalkulator rincian Hero Power (Tab 'Hero')
  HeroPowerDetail heroDetail = HeroPowerDetail(
    powerPerformaRanked: 0,
    powerPerformaPeak: 0,
    powerKemenangan: 100,
    poinPeakSaatIni: 1260,
    pengaliKeaktifanPercent: 10.0,
  );

  CalculatorProvider() {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    laneDataMap = {
      // Clash Lane sesuai persis dengan Screenshot Honor of Kings User
      HokLane.clash: LaneData(
        lane: HokLane.clash,
        currentPercentile: '1,6%',
        targetPower: 33190,
        targetPercentile: 'Top 1%',
        heroUtama: [
          HeroSlotData(heroName: 'Dharma', power: 6958),
          HeroSlotData(heroName: 'Allain', power: 6402),
          HeroSlotData(heroName: 'Biron', power: 5226),
          HeroSlotData(heroName: 'Mayene', power: 4388),
          HeroSlotData(heroName: 'Arthur', power: 4246),
        ],
        heroOP: [
          HeroSlotData(heroName: 'Guan Yu', power: 3681),
          HeroSlotData(heroName: 'Dun', power: 3627),
          HeroSlotData(heroName: 'Sun Ce', power: 2112),
          HeroSlotData(heroName: 'Lu Bu', power: 2059),
          HeroSlotData(heroName: 'Mulan', power: 1331),
        ],
      ),

      // Jungle
      HokLane.jungle: LaneData(
        lane: HokLane.jungle,
        currentPercentile: '3,2%',
        targetPower: 30000,
        targetPercentile: 'Top 2%',
        heroUtama: [
          HeroSlotData(heroName: 'Lam', power: 5800),
          HeroSlotData(heroName: 'Han Xin', power: 5400),
          HeroSlotData(heroName: 'Wukong', power: 5100),
          HeroSlotData(heroName: 'Li Bai', power: 4600),
          HeroSlotData(heroName: 'Butterfly', power: 4300),
        ],
        heroOP: [
          HeroSlotData(heroName: 'Musashi', power: 3200),
          HeroSlotData(heroName: 'Nakoruru', power: 3100),
          HeroSlotData(heroName: 'Zilong', power: 2800),
          HeroSlotData(heroName: 'Dian Wei', power: 2500),
          HeroSlotData(heroName: 'Pei Qinhu', power: 2200),
        ],
      ),

      // Mid Lane
      HokLane.mid: LaneData(
        lane: HokLane.mid,
        currentPercentile: '2,5%',
        targetPower: 31000,
        targetPercentile: 'Top 1.5%',
        heroUtama: [
          HeroSlotData(heroName: 'Diaochan', power: 6200),
          HeroSlotData(heroName: 'Shangguan', power: 5700),
          HeroSlotData(heroName: 'Mai Shiranui', power: 5300),
          HeroSlotData(heroName: 'Gan & Mo', power: 4800),
          HeroSlotData(heroName: 'Xiao Qiao', power: 4400),
        ],
        heroOP: [
          HeroSlotData(heroName: 'Angela', power: 3500),
          HeroSlotData(heroName: 'Lady Zhen', power: 3200),
          HeroSlotData(heroName: 'Princess Frost', power: 2900),
          HeroSlotData(heroName: 'Heino', power: 2600),
          HeroSlotData(heroName: 'Daji', power: 2100),
        ],
      ),

      // Farm Lane
      HokLane.farm: LaneData(
        lane: HokLane.farm,
        currentPercentile: '2,0%',
        targetPower: 32500,
        targetPercentile: 'Top 1%',
        heroUtama: [
          HeroSlotData(heroName: 'Arli', power: 6500),
          HeroSlotData(heroName: 'Marco Polo', power: 6000),
          HeroSlotData(heroName: 'Lady Sun', power: 5500),
          HeroSlotData(heroName: 'Garo', power: 4900),
          HeroSlotData(heroName: 'Luban No.7', power: 4500),
        ],
        heroOP: [
          HeroSlotData(heroName: 'Shouyue', power: 3600),
          HeroSlotData(heroName: 'Consort Yu', power: 3300),
          HeroSlotData(heroName: 'Di Renjie', power: 3000),
          HeroSlotData(heroName: 'Hou Yi', power: 2600),
          HeroSlotData(heroName: 'Alessio', power: 2200),
        ],
      ),

      // Roamer
      HokLane.roam: LaneData(
        lane: HokLane.roam,
        currentPercentile: '1,8%',
        targetPower: 31500,
        targetPercentile: 'Top 1%',
        heroUtama: [
          HeroSlotData(heroName: 'Da Qiao', power: 6300),
          HeroSlotData(heroName: 'Dolia', power: 5900),
          HeroSlotData(heroName: 'Taiyi Zhenren', power: 5200),
          HeroSlotData(heroName: 'Zhang Fei', power: 4700),
          HeroSlotData(heroName: 'Yaria', power: 4400),
        ],
        heroOP: [
          HeroSlotData(heroName: 'Sun Bin', power: 3500),
          HeroSlotData(heroName: 'Guiguzi', power: 3200),
          HeroSlotData(heroName: 'Donghuang', power: 2800),
          HeroSlotData(heroName: 'Liu Shan', power: 2500),
          HeroSlotData(heroName: 'Zhuangzi', power: 2200),
        ],
      ),
    };
  }

  // Getter data Lane yang sedang aktif
  LaneData get currentLaneData => laneDataMap[activeLane]!;

  // Ganti Tab Utama (Lane / Hero)
  void setTab(CalculatorTab tab) {
    activeTab = tab;
    notifyListeners();
  }

  // Ganti Lane yang sedang dilihat
  void switchLane(HokLane lane) {
    activeLane = lane;
    notifyListeners();
  }

  // Update Power Hero Utama
  void updateHeroUtamaPower(int index, int power) {
    if (index >= 0 && index < currentLaneData.heroUtama.length) {
      currentLaneData.heroUtama[index].power = power.clamp(0, 99999);
      notifyListeners();
    }
  }

  // Update Power Hero OP
  void updateHeroOPPower(int index, int power) {
    if (index >= 0 && index < currentLaneData.heroOP.length) {
      currentLaneData.heroOP[index].power = power.clamp(0, 99999);
      notifyListeners();
    }
  }

  // Quick delta power (+/-)
  void quickDeltaPower({required bool isUtama, required int index, required int delta}) {
    if (isUtama) {
      final current = currentLaneData.heroUtama[index].power;
      updateHeroUtamaPower(index, (current + delta).clamp(0, 99999));
    } else {
      final current = currentLaneData.heroOP[index].power;
      updateHeroOPPower(index, (current + delta).clamp(0, 99999));
    }
  }

  // Ubah nama hero pada slot
  void updateHeroName({required bool isUtama, required int index, required String newName}) {
    if (isUtama) {
      currentLaneData.heroUtama[index].heroName = newName;
    } else {
      currentLaneData.heroOP[index].heroName = newName;
    }
    notifyListeners();
  }

  // Update Target Power
  void updateTargetPower(int newTarget) {
    currentLaneData.targetPower = newTarget.clamp(0, 999999);
    notifyListeners();
  }

  // Auto-sort seluruh 10 hero berdasarkan power tertinggi: Top 1-5 jadi Hero Utama, Top 6-10 jadi Hero OP
  void autoSortCurrentLane() {
    final allTen = [
      ...currentLaneData.heroUtama,
      ...currentLaneData.heroOP,
    ];
    allTen.sort((a, b) => b.power.compareTo(a.power));

    currentLaneData.heroUtama = allTen.sublist(0, 5);
    currentLaneData.heroOP = allTen.sublist(5, 10);
    notifyListeners();
  }

  // Reset ke data awal sesuai screenshot
  void resetToSampleData() {
    _initializeDefaultData();
    notifyListeners();
  }

  // Reset Lane aktif ke 0
  void clearCurrentLane() {
    for (var hero in currentLaneData.heroUtama) {
      hero.power = 0;
    }
    for (var hero in currentLaneData.heroOP) {
      hero.power = 0;
    }
    notifyListeners();
  }

  // --- TAB HERO POWER DETAIL METHODS ---
  void updatePerformaRanked(int val) {
    heroDetail.powerPerformaRanked = val.clamp(0, 3000);
    notifyListeners();
  }

  void updatePerformaPeak(int val) {
    heroDetail.powerPerformaPeak = val.clamp(0, 1000);
    notifyListeners();
  }

  void updatePowerKemenangan(int val) {
    heroDetail.powerKemenangan = val.clamp(0, 3000);
    notifyListeners();
  }

  void updatePoinPeak(int val) {
    heroDetail.poinPeakSaatIni = val.clamp(0, 3500);
    notifyListeners();
  }

  void updateKeaktifan(double val) {
    heroDetail.pengaliKeaktifanPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  // Salin hasil kalkulasi Hero Power ke slot hero di Lane aktif
  void applyHeroPowerToSlot({required bool isUtama, required int index}) {
    final power = heroDetail.finalHeroPower;
    if (isUtama) {
      updateHeroUtamaPower(index, power);
    } else {
      updateHeroOPPower(index, power);
    }
    setTab(CalculatorTab.lane);
  }

  // --- SCREEN SWITCHER (Sidebar Menu) ---
  void setAppScreen(AppScreen screen) {
    activeScreen = screen;
    notifyListeners();
  }

  // --- WIN RATE CALCULATOR METHODS (johsteven/penghitung-wr) ---
  int get wrCurrentWins => (wrTotalMatch * (wrCurrentPercent / 100.0)).round();

  int? get wrRequiredWinStreak => HOKUtils.calculateRequiredWinStreak(
        totalMatch: wrTotalMatch,
        currentWRPercent: wrCurrentPercent,
        targetWRPercent: wrTargetPercent,
      );

  int? get wrAllowedLoseStreak => HOKUtils.calculateLoseStreakToDrop(
        totalMatch: wrTotalMatch,
        currentWRPercent: wrCurrentPercent,
        targetLowerWRPercent: wrDropTargetPercent,
      );

  void updateWrTotalMatch(int val) {
    wrTotalMatch = val.clamp(1, 999999);
    notifyListeners();
  }

  void updateWrCurrentPercent(double val) {
    wrCurrentPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  void updateWrTargetPercent(double val) {
    wrTargetPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  void updateWrDropTargetPercent(double val) {
    wrDropTargetPercent = val.clamp(0.0, 100.0);
    notifyListeners();
  }

  void setWrWinStreakMode(bool isWinStreak) {
    isWrWinStreakMode = isWinStreak;
    notifyListeners();
  }
}
