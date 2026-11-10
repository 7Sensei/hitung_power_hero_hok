import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/features/hero_detail/viewmodel/hero_detail_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/power_lane/viewmodel/power_lane_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/shell/viewmodel/shell_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/win_rate/viewmodel/win_rate_viewmodel.dart';
import 'package:hitung_power_hero_hok/views/calculator_view.dart';

class HokApp extends StatelessWidget {
  const HokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShellViewModel()),
        ChangeNotifierProvider(create: (_) => PowerLaneViewModel()),
        ChangeNotifierProvider(create: (_) => HeroDetailViewModel()),
        ChangeNotifierProvider(create: (_) => WinRateViewModel()),
      ],
      child: MaterialApp(
        title: 'HOK by 7Sensei',
        debugShowCheckedModeBanner: false,
        theme: HokTheme.darkTheme,
        home: const CalculatorView(),
      ),
    );
  }
}
