import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hitung_power_hero_hok/core/utils.dart';
import 'package:hitung_power_hero_hok/main.dart';
import 'package:hitung_power_hero_hok/models/hero_detail_model.dart';
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

    test('Verifikasi batas cap Power Performa Peak berdasarkan Poin Peak', () {
      final detail = HeroPowerDetail(selectedPeakPointsTier: 1200);
      expect(detail.peakPowerCap, 200);

      detail.selectedPeakPointsTier = 1500;
      expect(detail.peakPowerCap, 900);

      detail.selectedPeakPointsTier = 2400;
      expect(detail.peakPowerCap, 5400);
    });
  });

  group(
    'Win Rate Calculator (johsteven/penghitung-wr) Unit Tests Sesuai Screenshot',
    () {
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
    },
  );

  testWidgets('HOK Gameland App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const HOKPowerCalculatorApp());
    await tester.pumpAndSettle();

    // Verifikasi brand navbar & komponen utama muncul
    expect(find.text('HOK Power'), findsOneWidget);
    expect(find.text('Hero Utama'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Win Rate Calculator View smoke & mode switch test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: WinRateCalculatorView()),
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

  testWidgets('Hero Detail tab slider drag test without jump', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HOKPowerCalculatorApp());
    await tester.pumpAndSettle();

    // Di halaman Power Lane, tombol Sample & Hapus harus ada
    expect(find.text('Sample'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

    // Pindah ke tab Rincian Hero
    await tester.tap(find.text('Rincian Hero'));
    await tester.pumpAndSettle();

    // Di halaman Rincian Hero, tombol Sample & Hapus TIDAK boleh ada
    expect(find.text('Sample'), findsNothing);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);

    expect(find.text('Power Performa Ranked'), findsOneWidget);
    expect(find.text('Power Performa Peak'), findsOneWidget);

    // Temukan slider pertama (Power Performa Ranked) dan drag ke kanan
    final sliders = find.byType(Slider);
    expect(sliders, findsWidgets);

    await tester.drag(sliders.first, const Offset(50, 0), warnIfMissed: false);
    await tester.pumpAndSettle();

    final exception = tester.takeException();
    if (exception is FlutterError) {
      debugPrint('TEST EXCEPTION DETAILS: ${exception.toStringDeep()}');
    }
    expect(exception, isNull);
  });

  testWidgets('Sidebar drawer test and no overflow on narrow screens', (
    WidgetTester tester,
  ) async {
    // Set ukuran layar mobile tipikal misal 375x812
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HOKPowerCalculatorApp());
    await tester.pumpAndSettle();

    // Buka Drawer melalui tombol menu
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    // Pastikan menu drawer tampil
    expect(find.text('PILIH TOOLS'), findsOneWidget);
    expect(find.text('Kalkulator Power HoK'), findsOneWidget);
    expect(find.text('Penghitung Win Rate (WR)'), findsOneWidget);

    // Ganti ke Penghitung Win Rate dari drawer
    await tester.tap(find.text('Penghitung Win Rate (WR)'));
    await tester.pumpAndSettle();

    expect(find.text('Hitung Win Streak'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
