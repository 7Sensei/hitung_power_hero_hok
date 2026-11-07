import 'package:flutter/material.dart';
import '../core/utils.dart';

class CalculatorProvider with ChangeNotifier {
  // Menyimpan input 5 Hero Utama dan 5 Hero OP (default 0)
  List<int> heroUtama = List.filled(5, 0);
  List<int> heroOP = List.filled(5, 0);

  // Mengambil total hasil kalkulasi secara real-time
  double get totalPowerLane => HOKUtils.calculatePowerLane(heroUtama, heroOP);

  // Fungsi untuk memperbarui angka Hero Utama dari TextField
  void updateHeroUtama(int index, String value) {
    heroUtama[index] = int.tryParse(value) ?? 0;
    notifyListeners(); // Memicu UI untuk render ulang otomatis
  }

  // Fungsi untuk memperbarui angka Hero OP dari TextField
  void updateHeroOP(int index, String value) {
    heroOP[index] = int.tryParse(value) ?? 0;
    notifyListeners();
  }

  // Tombol reset semua form ke 0
  void resetKalkulator() {
    heroUtama = List.filled(5, 0);
    heroOP = List.filled(5, 0);
    notifyListeners();
  }
}
