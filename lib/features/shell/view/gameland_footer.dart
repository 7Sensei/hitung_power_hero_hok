import 'package:flutter/material.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';

class GamelandFooter extends StatelessWidget {
  const GamelandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year.toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Divider(color: Color(0xFF162116), height: 1),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'HOK by 7Sensei © $currentYear • All Rights Reserved',
                style: const TextStyle(color: HokTheme.textMuted, fontSize: 11),
              ),
              const Text(
                'Honor of Kings',
                style: TextStyle(
                  color: HokTheme.limeAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
