import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'views/calculator_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CalculatorProvider())],
      child: const HOKWebKalkulator(),
    ),
  );
}

class HOKWebKalkulator extends StatelessWidget {
  const HOKWebKalkulator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOK Power Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF121A2F,
        ), // Warna biru gelap ala HOK
        primaryColor: Colors.blueAccent,
      ),
      home: const CalculatorView(),
    );
  }
}
