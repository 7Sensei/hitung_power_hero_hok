import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';

/// Formatter khusus untuk form input angka.
/// Menolak karakter huruf/simbol non-angka dan menampilkan SnackBar peringatan
/// "Hanya bisa input angka!" secara real-time.
class NumericInputFormatter extends TextInputFormatter {
  final BuildContext context;
  final bool allowDecimal;
  static DateTime? _lastWarningTime;

  NumericInputFormatter({
    required this.context,
    this.allowDecimal = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final validPattern =
        allowDecimal ? RegExp(r'^[0-9.]*$') : RegExp(r'^[0-9]*$');

    if (validPattern.hasMatch(newValue.text)) {
      // Jika desimal, hanya boleh ada maksimal satu titik
      if (allowDecimal && '.'.allMatches(newValue.text).length > 1) {
        showWarning(context);
        return oldValue;
      }
      return newValue;
    }

    // Karakter huruf / simbol tidak valid terdeteksi
    showWarning(context);
    return oldValue;
  }

  /// Menampilkan peringatan SnackBar floating ala tema Gameland.
  static void showWarning(BuildContext context) {
    final now = DateTime.now();
    if (_lastWarningTime != null &&
        now.difference(_lastWarningTime!) < const Duration(milliseconds: 1200)) {
      return;
    }
    _lastWarningTime = now;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: HokTheme.redAccent,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hanya bisa input angka!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1B1212),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: HokTheme.redAccent.withValues(alpha: 0.5)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

