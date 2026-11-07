import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_power_hero_hok/core/utils.dart';
import 'package:hitung_power_hero_hok/main.dart';

void main() {
  group('HOK Calculation Logic Unit Tests', () {
    test('Verifikasi perhitungan Power Lane sesuai Screenshot HoK', () {
      final heroUtama = [6958, 6402, 5226, 4388, 4246];
      final heroOP = [3681, 3627, 2112, 2059, 1331];

      // Subtotal Hero Utama (100%)
      final subtotalUtama = HOKUtils.calculateSubtotalUtama(heroUtama);
      expect(subtotalUtama, 27220);

      // Subtotal Hero OP (20% dari 12.810 = 2.562)
      final subtotalOP = HOKUtils.calculateSubtotalOP(heroOP);
      expect(subtotalOP, 2562);

      // Total Power Lane = 27.220 + 2.562 = 29.782
      final totalLane = HOKUtils.calculatePowerLane(heroUtama, heroOP);
      expect(totalLane, 29782);

      // Tier = 29
      final tier = HOKUtils.calculateTier(totalLane);
      expect(tier, 29);
    });

    test('Verifikasi perhitungan Pengali Peak Tourney', () {
      // 1260 Poin Tourney -> (1260 - 1200) / 20 = 3%
      expect(HOKUtils.calculatePeakMultiplier(1260), 3.0);

      // 1200 Poin Tourney -> 0%
      expect(HOKUtils.calculatePeakMultiplier(1200), 0.0);

      // 1400 Poin Tourney -> 10%
      expect(HOKUtils.calculatePeakMultiplier(1400), 10.0);
    });

    test('Verifikasi rumus Power Hero = Power Total x Pengali Total', () {
      // Power Total = 900 (Ranked) + 200 (Peak) + 100 (Kemenangan) = 1200
      // Pengali Total = (1 + 3% Peak) * (100% Keaktifan) = 1.03
      // Final Hero Power = 1200 * 1.03 = 1236
      final heroPower = HOKUtils.calculateHeroPower(
        performaRanked: 900,
        performaPeak: 200,
        kemenangan: 100,
        poinPeak: 1260,
        keaktifanPercent: 100.0,
      );
      expect(heroPower, 1236);
    });
  });

  testWidgets('HOK Gameland App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const HOKPowerCalculatorApp());
    await tester.pumpAndSettle();

    // Verifikasi brand navbar & komponen utama muncul
    expect(find.text('HOK Power'), findsOneWidget);
    expect(find.text('Hero Utama'), findsOneWidget);
    expect(find.text('Hero OP Kamu'), findsOneWidget);
  });
}
