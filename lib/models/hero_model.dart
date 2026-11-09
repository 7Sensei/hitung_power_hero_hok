import '../core/constants.dart';

class HokHero {
  final String id;
  final String name;
  final HokLane lane;
  final int defaultPower;

  const HokHero({
    required this.id,
    required this.name,
    required this.lane,
    required this.defaultPower,
  });
}

class HeroSlotData {
  String heroName;
  int power;

  HeroSlotData({required this.heroName, required this.power});

  HeroSlotData copyWith({String? heroName, int? power}) {
    return HeroSlotData(
      heroName: heroName ?? this.heroName,
      power: power ?? this.power,
    );
  }
}
