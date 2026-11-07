import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';

class HeroDetailTabView extends StatefulWidget {
  const HeroDetailTabView({super.key});

  @override
  State<HeroDetailTabView> createState() => _HeroDetailTabViewState();
}

class _HeroDetailTabViewState extends State<HeroDetailTabView> {
  late TextEditingController _rankedController;
  late TextEditingController _peakPerfController;
  late TextEditingController _kemenanganController;
  late TextEditingController _poinPeakController;

  @override
  void initState() {
    super.initState();
    final detail = context.read<CalculatorProvider>().heroDetail;
    _rankedController = TextEditingController(text: detail.powerPerformaRanked.toString());
    _peakPerfController = TextEditingController(text: detail.powerPerformaPeak.toString());
    _kemenanganController = TextEditingController(text: detail.powerKemenangan.toString());
    _poinPeakController = TextEditingController(text: detail.poinPeakSaatIni.toString());
  }

  @override
  void dispose() {
    _rankedController.dispose();
    _peakPerfController.dispose();
    _kemenanganController.dispose();
    _poinPeakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final detail = provider.heroDetail;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Hasil Perhitungan Utama
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF132342), Color(0xFF1C315B)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2E487C), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Power Hero = Power Total × Pengali Total',
                  style: TextStyle(
                    color: HokTheme.blueCyan,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Icon(Icons.diamond, color: HokTheme.goldAccent, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      HOKUtils.formatNumber(detail.finalHeroPower),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Power',
                      style: TextStyle(color: HokTheme.goldLight, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFormulaBadge('Power Total', HOKUtils.formatNumber(detail.powerTotal)),
                    const Text('×', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildFormulaBadge('Pengali Total', '${(detail.pengaliTotal * 100).toStringAsFixed(1)}%'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SEKSI 1: POWER TOTAL (KOMPONEN POIN)
          const Text(
            '1. Komponen Power Total',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // 1. Power Performa Ranked
          _buildItemCard(
            title: 'Power Performa Ranked',
            currentValueText: '${detail.powerPerformaRanked} / 1.500',
            description: 'Standar: 900. Bertambah lebih cepat jika di bawah standar. Dipengaruhi hasil & skor match ranked serta tier pemain.',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: detail.powerPerformaRanked.toDouble(),
                    min: 0,
                    max: 1500,
                    divisions: 150,
                    activeColor: HokTheme.blueCyan,
                    inactiveColor: const Color(0xFF1B2A48),
                    onChanged: (val) {
                      provider.updatePerformaRanked(val.round());
                      _rankedController.text = val.round().toString();
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _rankedController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                    onChanged: (val) {
                      final n = int.tryParse(val) ?? 0;
                      provider.updatePerformaRanked(n);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Power Performa Peak
          _buildItemCard(
            title: 'Power Performa Peak',
            currentValueText: '${detail.powerPerformaPeak} / 200',
            description: 'Standar: 200. Bertambah lebih cepat jika di bawah standar. Makin tinggi Poin Tourney, makin tinggi pula batas standarnya.',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: detail.powerPerformaPeak.toDouble(),
                    min: 0,
                    max: 400,
                    divisions: 80,
                    activeColor: HokTheme.blueCyan,
                    inactiveColor: const Color(0xFF1B2A48),
                    onChanged: (val) {
                      provider.updatePerformaPeak(val.round());
                      _peakPerfController.text = val.round().toString();
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _peakPerfController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                    onChanged: (val) {
                      final n = int.tryParse(val) ?? 0;
                      provider.updatePerformaPeak(n);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Power Kemenangan
          _buildItemCard(
            title: 'Power Kemenangan',
            currentValueText: '${detail.powerKemenangan} / 3.000',
            description: 'Menangkan Ranked Match atau Peak Tournament untuk meningkatkan (Maksimal 3.000 poin). Dipengaruhi kemenangan di beberapa Season terakhir.',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: detail.powerKemenangan.toDouble(),
                    min: 0,
                    max: 3000,
                    divisions: 150,
                    activeColor: HokTheme.goldAccent,
                    inactiveColor: const Color(0xFF1B2A48),
                    onChanged: (val) {
                      provider.updatePowerKemenangan(val.round());
                      _kemenanganController.text = val.round().toString();
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _kemenanganController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                    onChanged: (val) {
                      final n = int.tryParse(val) ?? 0;
                      provider.updatePowerKemenangan(n);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SEKSI 2: PENGALI TOTAL (FAKTOR MULTIPLIER)
          const Text(
            '2. Komponen Pengali Total',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Pengali Peak (Poin Tourney)
          _buildItemCard(
            title: 'Pengali Peak',
            currentValueText: '${detail.pengaliPeakPercent.toStringAsFixed(0)}%',
            description: 'Poin Peak saat ini: ${detail.poinPeakSaatIni}. Dihitung otomatis: +1% setiap kelipatan 20 poin di atas 1.200.',
            child: Row(
              children: [
                const Icon(Icons.military_tech, color: HokTheme.goldAccent),
                const SizedBox(width: 10),
                const Text('Poin Peak Tourney:', style: TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _poinPeakController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '1260',
                      suffixText: 'Poin',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onChanged: (val) {
                      final n = int.tryParse(val) ?? 1200;
                      provider.updatePoinPeak(n);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pengali Keaktifan
          _buildItemCard(
            title: 'Pengali Keaktifan',
            currentValueText: '${detail.pengaliKeaktifanPercent.toStringAsFixed(0)}%',
            description: 'Keaktifan hero (${detail.pengaliKeaktifanPercent < 50 ? 'Kurang/Tidak Aktif' : 'Aktif'}). Menurun setiap minggu jika tidak dimainkan, dapat dipulihkan dengan bermain dan meraih MVP.',
            child: Slider(
              value: detail.pengaliKeaktifanPercent,
              min: 10,
              max: 100,
              divisions: 18,
              activeColor: detail.pengaliKeaktifanPercent >= 80 ? HokTheme.greenAccent : HokTheme.goldAccent,
              inactiveColor: const Color(0xFF1B2A48),
              onChanged: (val) {
                provider.updateKeaktifan(val);
              },
            ),
          ),

          const SizedBox(height: 24),

          // Tombol Salin ke Slot Hero di Kalkulator Lane
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showApplyToSlotSheet(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: HokTheme.blueCyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.assignment_return_outlined),
              label: Text(
                'Terapkan Power ${HOKUtils.formatNumber(detail.finalHeroPower)} ke Slot Lane',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFormulaBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F192E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B4475)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(color: HokTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required String currentValueText,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121E36),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3258)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2D4F),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentValueText,
                  style: const TextStyle(
                    color: HokTheme.blueCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: HokTheme.textSecondary, fontSize: 11, height: 1.3),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Bottom Sheet untuk memilih slot mana di Lane aktif yang ingin diisi
  void _showApplyToSlotSheet(BuildContext context, CalculatorProvider provider) {
    final laneData = provider.currentLaneData;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111D33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Slot di ${laneData.lane.displayName}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Nilai power ${HOKUtils.formatNumber(provider.heroDetail.finalHeroPower)} akan disalin ke slot terpilih:',
                style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: ListView(
                  children: [
                    const Text('Top 5 Hero Utama (100%):', style: TextStyle(color: HokTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    ...List.generate(5, (idx) {
                      final h = laneData.heroUtama[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF1F355E),
                          child: Text('#${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                        title: Text(h.heroName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        trailing: Text('${h.power} Power', style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12)),
                        onTap: () {
                          provider.applyHeroPowerToSlot(isUtama: true, index: idx);
                          Navigator.pop(ctx);
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text('Top 6-10 Hero OP (20%):', style: TextStyle(color: HokTheme.blueCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    ...List.generate(5, (idx) {
                      final h = laneData.heroOP[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF1F355E),
                          child: Text('#${idx + 6}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                        title: Text(h.heroName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        trailing: Text('${h.power} Power', style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12)),
                        onTap: () {
                          provider.applyHeroPowerToSlot(isUtama: false, index: idx);
                          Navigator.pop(ctx);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
