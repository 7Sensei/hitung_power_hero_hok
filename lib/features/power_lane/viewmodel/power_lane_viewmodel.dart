import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/core/constants.dart';
import 'package:hitung_power_hero_hok/data/models/hero_model.dart';
import 'package:hitung_power_hero_hok/data/models/lane_model.dart';

/// ViewModel untuk fitur Power Lane: data 5 lane, hero slot, dan perhitungan lane.
class PowerLaneViewModel extends ChangeNotifier {
  late Map<HokLane, LaneData> _laneDataMap;
  HokLane _activeLane = HokLane.clash;

  PowerLaneViewModel() {
    _initializeDefaultData();
  }

  Map<HokLane, LaneData> get laneDataMap => _laneDataMap;
  HokLane get activeLane => _activeLane;
  LaneData get currentLaneData => _laneDataMap[_activeLane]!;

  void _initializeDefaultData() {
    _laneDataMap = {
      // Clash Lane sesuai persis dengan Screenshot Honor of Kings User
      HokLane.clash: LaneData(
        lane: HokLane.clash,
        currentPercentile: '1,6%',
        targetPower: 33190,
        targetPercentile: 'Top 1%',
        heroUtama: [
          const HeroSlotData(heroName: 'Dharma', power: 6958),
          const HeroSlotData(heroName: 'Allain', power: 6402),
          const HeroSlotData(heroName: 'Biron', power: 5226),
          const HeroSlotData(heroName: 'Mayene', power: 4388),
          const HeroSlotData(heroName: 'Arthur', power: 4246),
        ],
        heroOP: [
          const HeroSlotData(heroName: 'Guan Yu', power: 3681),
          const HeroSlotData(heroName: 'Dun', power: 3627),
          const HeroSlotData(heroName: 'Sun Ce', power: 2112),
          const HeroSlotData(heroName: 'Lu Bu', power: 2059),
          const HeroSlotData(heroName: 'Mulan', power: 1331),
        ],
      ),

      // Jungle
      HokLane.jungle: LaneData(
        lane: HokLane.jungle,
        currentPercentile: '3,2%',
        targetPower: 30000,
        targetPercentile: 'Top 2%',
        heroUtama: [
          const HeroSlotData(heroName: 'Lam', power: 5800),
          const HeroSlotData(heroName: 'Han Xin', power: 5400),
          const HeroSlotData(heroName: 'Wukong', power: 5100),
          const HeroSlotData(heroName: 'Li Bai', power: 4600),
          const HeroSlotData(heroName: 'Butterfly', power: 4300),
        ],
        heroOP: [
          const HeroSlotData(heroName: 'Musashi', power: 3200),
          const HeroSlotData(heroName: 'Nakoruru', power: 3100),
          const HeroSlotData(heroName: 'Zilong', power: 2800),
          const HeroSlotData(heroName: 'Dian Wei', power: 2500),
          const HeroSlotData(heroName: 'Pei Qinhu', power: 2200),
        ],
      ),

      // Mid Lane
      HokLane.mid: LaneData(
        lane: HokLane.mid,
        currentPercentile: '2,5%',
        targetPower: 31000,
        targetPercentile: 'Top 1.5%',
        heroUtama: [
          const HeroSlotData(heroName: 'Diaochan', power: 6200),
          const HeroSlotData(heroName: 'Shangguan', power: 5700),
          const HeroSlotData(heroName: 'Mai Shiranui', power: 5300),
          const HeroSlotData(heroName: 'Gan & Mo', power: 4800),
          const HeroSlotData(heroName: 'Xiao Qiao', power: 4400),
        ],
        heroOP: [
          const HeroSlotData(heroName: 'Angela', power: 3500),
          const HeroSlotData(heroName: 'Lady Zhen', power: 3200),
          const HeroSlotData(heroName: 'Princess Frost', power: 2900),
          const HeroSlotData(heroName: 'Heino', power: 2600),
          const HeroSlotData(heroName: 'Daji', power: 2100),
        ],
      ),

      // Farm Lane
      HokLane.farm: LaneData(
        lane: HokLane.farm,
        currentPercentile: '2,0%',
        targetPower: 32500,
        targetPercentile: 'Top 1%',
        heroUtama: [
          const HeroSlotData(heroName: 'Arli', power: 6500),
          const HeroSlotData(heroName: 'Marco Polo', power: 6000),
          const HeroSlotData(heroName: 'Lady Sun', power: 5500),
          const HeroSlotData(heroName: 'Garo', power: 4900),
          const HeroSlotData(heroName: 'Luban No.7', power: 4500),
        ],
        heroOP: [
          const HeroSlotData(heroName: 'Shouyue', power: 3600),
          const HeroSlotData(heroName: 'Consort Yu', power: 3300),
          const HeroSlotData(heroName: 'Di Renjie', power: 3000),
          const HeroSlotData(heroName: 'Hou Yi', power: 2600),
          const HeroSlotData(heroName: 'Alessio', power: 2200),
        ],
      ),

      // Roamer
      HokLane.roam: LaneData(
        lane: HokLane.roam,
        currentPercentile: '1,8%',
        targetPower: 31500,
        targetPercentile: 'Top 1%',
        heroUtama: [
          const HeroSlotData(heroName: 'Da Qiao', power: 6300),
          const HeroSlotData(heroName: 'Dolia', power: 5900),
          const HeroSlotData(heroName: 'Taiyi Zhenren', power: 5200),
          const HeroSlotData(heroName: 'Zhang Fei', power: 4700),
          const HeroSlotData(heroName: 'Yaria', power: 4400),
        ],
        heroOP: [
          const HeroSlotData(heroName: 'Sun Bin', power: 3500),
          const HeroSlotData(heroName: 'Guiguzi', power: 3200),
          const HeroSlotData(heroName: 'Donghuang', power: 2800),
          const HeroSlotData(heroName: 'Liu Shan', power: 2500),
          const HeroSlotData(heroName: 'Zhuangzi', power: 2200),
        ],
      ),
    };
  }

  // Ganti Lane yang sedang dilihat
  void switchLane(HokLane lane) {
    _activeLane = lane;
    notifyListeners();
  }

  // Update Power Hero Utama — menggunakan copyWith (immutable model)
  void updateHeroUtamaPower(int index, int power) {
    if (index >= 0 && index < currentLaneData.heroUtama.length) {
      currentLaneData.heroUtama[index] =
          currentLaneData.heroUtama[index].copyWith(
        power: power.clamp(0, 99999),
      );
      notifyListeners();
    }
  }

  // Update Power Hero OP — menggunakan copyWith (immutable model)
  void updateHeroOPPower(int index, int power) {
    if (index >= 0 && index < currentLaneData.heroOP.length) {
      currentLaneData.heroOP[index] =
          currentLaneData.heroOP[index].copyWith(
        power: power.clamp(0, 99999),
      );
      notifyListeners();
    }
  }

  // Quick delta power (+/-)
  void quickDeltaPower({
    required bool isUtama,
    required int index,
    required int delta,
  }) {
    if (isUtama) {
      final current = currentLaneData.heroUtama[index].power;
      updateHeroUtamaPower(index, (current + delta).clamp(0, 99999));
    } else {
      final current = currentLaneData.heroOP[index].power;
      updateHeroOPPower(index, (current + delta).clamp(0, 99999));
    }
  }

  // Ubah nama hero pada slot — menggunakan copyWith
  void updateHeroName({
    required bool isUtama,
    required int index,
    required String newName,
  }) {
    if (isUtama) {
      currentLaneData.heroUtama[index] =
          currentLaneData.heroUtama[index].copyWith(heroName: newName);
    } else {
      currentLaneData.heroOP[index] =
          currentLaneData.heroOP[index].copyWith(heroName: newName);
    }
    notifyListeners();
  }

  // Update Target Power
  void updateTargetPower(int newTarget) {
    currentLaneData.targetPower = newTarget.clamp(0, 999999);
    notifyListeners();
  }

  // Auto-sort seluruh 10 hero berdasarkan power tertinggi
  void autoSortCurrentLane() {
    final allTen = [
      ...currentLaneData.heroUtama,
      ...currentLaneData.heroOP,
    ]..sort((a, b) => b.power.compareTo(a.power));

    for (var i = 0; i < 5; i++) {
      currentLaneData.heroUtama[i] = allTen[i];
    }
    for (var i = 0; i < 5; i++) {
      currentLaneData.heroOP[i] = allTen[5 + i];
    }
    notifyListeners();
  }

  // Reset ke data awal sesuai screenshot
  void resetToSampleData() {
    _initializeDefaultData();
    notifyListeners();
  }

  // Reset Lane aktif ke power 0
  void clearCurrentLane() {
    for (var i = 0; i < currentLaneData.heroUtama.length; i++) {
      currentLaneData.heroUtama[i] =
          currentLaneData.heroUtama[i].copyWith(power: 0);
    }
    for (var i = 0; i < currentLaneData.heroOP.length; i++) {
      currentLaneData.heroOP[i] =
          currentLaneData.heroOP[i].copyWith(power: 0);
    }
    notifyListeners();
  }

  // Salin hasil kalkulasi Hero Power ke slot hero di lane tertentu
  void applyHeroPowerToSlot({
    required bool isUtama,
    required int index,
    required int power,
    HokLane? targetLane,
  }) {
    final lane = targetLane ?? _activeLane;
    final data = _laneDataMap[lane]!;
    if (isUtama) {
      data.heroUtama[index] = data.heroUtama[index].copyWith(
        power: power.clamp(0, 99999),
      );
    } else {
      data.heroOP[index] = data.heroOP[index].copyWith(
        power: power.clamp(0, 99999),
      );
    }
    _activeLane = lane;
    notifyListeners();
  }
}
