import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_power_hero_hok/core/utils.dart';
import 'package:hitung_power_hero_hok/main.dart';
import 'package:hitung_power_hero_hok/views/win_rate_calculator_view.dart';

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

  group('Win Rate Calculator (johsteven/penghitung-wr) Unit Tests Sesuai Screenshot', () {
    test('Screenshot 1: Verifikasi rumus Win Streak target WR', () {
      // 100 match, 50% WR (50 win), target 60% WR -> butuh 25 win tanpa lose
      final reqWins = HOKUtils.calculateRequiredWinStreak(
        totalMatch: 100,
        currentWRPercent: 50.0,
        targetWRPercent: 60.0,
      );
      expect(reqWins, 25);
    });

    test('Screenshot 2: Verifikasi rumus Hitung WR dengan lose streak', () {
      // 100 match, 50% WR, lose streak 5 kali -> WR menjadi 47.6%
      final newWr = HOKUtils.calculateWrAfterLoseStreak(
        totalMatch: 100,
        currentWRPercent: 50.0,
        loseStreak: 5,
      );
      expect(newWr, 47.6);
    });

    test('Screenshot 3: Verifikasi rumus Cek total win atau lose', () {
      // 100 match, 50% WR -> Total win: 50 match, Total lose: 50 match
      expect(HOKUtils.calculateTotalWin(100, 50.0), 50);
      expect(HOKUtils.calculateTotalLose(100, 50.0), 50);
    });
  });

  testWidgets('HOK Gameland App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const HOKPowerCalculatorApp());
    await tester.pumpAndSettle();

    // Verifikasi brand navbar & komponen utama muncul
    expect(find.text('HOK Power'), findsOneWidget);
    expect(find.text('Hero Utama'), findsOneWidget);
  });

  testWidgets('Win Rate Calculator View smoke & mode switch test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: WinRateCalculatorView(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan default di mode Win Streak
    expect(find.text('Hitung Win Streak'), findsWidgets);
    expect(find.text('Hitung Sekarang'), findsOneWidget);

    // Switch ke Lose Streak
    await tester.tap(find.text('Lose Streak'));
    await tester.pumpAndSettle();
    expect(find.text('Hitung WR × Lose Streak'), findsOneWidget);

    // Switch ke Win / Lose
    await tester.tap(find.text('Win / Lose'));
    await tester.pumpAndSettle();
    expect(find.text('Cek Total Win / Lose'), findsOneWidget);
    expect(find.text('Win'), findsOneWidget);
    expect(find.text('Lose'), findsOneWidget);
  });
}
