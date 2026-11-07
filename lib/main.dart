import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/calculator_provider.dart';
import 'views/calculator_view.dart';

void main() {
  runApp(const HOKPowerCalculatorApp());
}

class HOKPowerCalculatorApp extends StatelessWidget {
  const HOKPowerCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
      ],
      child: MaterialApp(
        title: 'HOK Power Calculator',
        debugShowCheckedModeBanner: false,
        theme: HokTheme.darkTheme,
        home: const CalculatorView(),
      ),
    );
  }
}
