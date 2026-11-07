import '../core/constants.dart';
import 'hero_model.dart';

class LaneData {
  final HokLane lane;
  List<HeroSlotData> heroUtama; // 5 Hero Utama (Bobot 100%)
  List<HeroSlotData> heroOP;    // 5 Hero OP Kamu (Bobot 20%)
  String currentPercentile;
  int targetPower;
  String targetPercentile;

  LaneData({
    required this.lane,
    required this.heroUtama,
    required this.heroOP,
    this.currentPercentile = '1,6%',
    this.targetPower = 33190,
    this.targetPercentile = 'Top 1%',
  });

  // Total Power Hero Utama (Bobot 100%)
  int get subtotalUtama {
    return heroUtama.fold<int>(0, (sum, hero) => sum + hero.power);
  }

  // Total Power Hero OP sebelum bobot
  int get sumRawOP {
    return heroOP.fold<int>(0, (sum, hero) => sum + hero.power);
  }

  // Kontribusi Power Hero OP (Bobot 20%)
  int get subtotalOP {
    return (sumRawOP * 0.2).round();
  }

  // Total Power Lane = Subtotal Utama + Subtotal OP
  int get totalPowerLane {
    return subtotalUtama + subtotalOP;
  }

  // Tier Lane (kelipatan 1000)
  int get currentTier {
    return totalPowerLane ~/ 1000;
  }

  // Target Tier
  int get targetTier {
    return targetPower ~/ 1000;
  }

  // Sisa poin menuju target
  int get remainingPowerToTarget {
    final diff = targetPower - totalPowerLane;
    return diff > 0 ? diff : 0;
  }

  // Progress % menuju target
  double get progressToTarget {
    if (targetPower <= 0) return 1.0;
    final progress = totalPowerLane / targetPower;
    return progress.clamp(0.0, 1.0);
  }
}

