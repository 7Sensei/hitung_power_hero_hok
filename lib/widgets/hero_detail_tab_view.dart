import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../models/hero_detail_model.dart';
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
    _rankedController = TextEditingController(
      text: detail.powerPerformaRanked.toString(),
    );
    _peakPerfController = TextEditingController(
      text: detail.powerPerformaPeak.toString(),
    );
    _kemenanganController = TextEditingController(
      text: detail.powerKemenangan.toString(),
    );
    _poinPeakController = TextEditingController(
      text: detail.poinPeakSaatIni > 1200
          ? detail.poinPeakSaatIni.toString()
          : '',
    );
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Hasil Perhitungan Utama (Gameland Neon Ambient Glow)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: const Color(0xFF0C120C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1E2D1E)),
              boxShadow: [
                BoxShadow(
                  color: HokTheme.neonLime.withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: HokTheme.neonLime.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: HokTheme.neonLime.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'Power Hero = Power Total × Pengali Total',
                    style: TextStyle(
                      color: HokTheme.neonLime,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      HOKUtils.formatNumber(detail.finalHeroPower),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Power',
                      style: TextStyle(
                        color: HokTheme.neonLime,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildFormulaBadge(
                      'Power Total',
                      HOKUtils.formatNumber(detail.powerTotal),
                    ),
                    const Text(
                      '×',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildFormulaBadge(
                      'Pengali Total',
                      '${(detail.pengaliTotal * 100).toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SEKSI 1: POWER TOTAL
          const Text(
            '1. Komponen Power Total',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 1. Power Performa Ranked
          _buildItemCard(
            title: 'Power Performa Ranked',
            currentValueText:
                '${HOKUtils.formatNumber(detail.powerPerformaRanked)} / 2.500',
            description:
                'Standar: 900. Bertambah lebih cepat jika di bawah standar. Maksimal 2.500 poin.',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: detail.powerPerformaRanked.toDouble().clamp(
                      0.0,
                      2500.0,
                    ),
                    min: 0,
                    max: 2500,
                    divisions: 250,
                    activeColor: HokTheme.neonLime,
                    inactiveColor: const Color(0xFF1B2A1B),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      fillColor: const Color(0xFF141E14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
            currentValueText:
                '${HOKUtils.formatNumber(detail.powerPerformaPeak)} / ${HOKUtils.formatNumber(detail.peakPowerCap)}',
            description:
                'Setiap bracket Poin Peak memiliki batas maksimal (Cap). Pilih tier Poin Peak untuk mengatur batas maksimal Power Performa Peak.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Pilihan Poin Peak
                Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 14,
                      color: HokTheme.neonLime,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Pilih Poin Peak & Batas Cap:',
                      style: TextStyle(
                        color: HokTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Dropdown Poin Peak & Batas Cap
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141E14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF223022)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: detail.selectedPeakPointsTier,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF0F150F),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: HokTheme.neonLime,
                      ),
                      items: kPeakCapTiers.map((tier) {
                        return DropdownMenuItem<int>(
                          value: tier.peakPoints,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.military_tech_rounded,
                                    color: HokTheme.neonLime,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${HOKUtils.formatNumber(tier.peakPoints)} Poin Peak',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: HokTheme.neonLime.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: HokTheme.neonLime.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cap: +${HOKUtils.formatNumber(tier.capPower)}',
                                  style: const TextStyle(
                                    color: HokTheme.neonLime,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newTier) {
                        if (newTier != null) {
                          provider.updateSelectedPeakTier(newTier);
                          _peakPerfController.text = provider
                              .heroDetail
                              .powerPerformaPeak
                              .toString();
                          _poinPeakController.text = newTier > 1200
                              ? newTier.toString()
                              : '';
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Slider & Input Angka Power Performa Peak
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: detail.powerPerformaPeak.toDouble().clamp(
                          0.0,
                          detail.peakPowerCap.toDouble(),
                        ),
                        min: 0,
                        max: detail.peakPowerCap.toDouble(),
                        divisions: detail.peakPowerCap > 0
                            ? (detail.peakPowerCap <= 400
                                  ? (detail.peakPowerCap ~/ 5)
                                  : (detail.peakPowerCap ~/ 20))
                            : 1,
                        activeColor: HokTheme.neonLime,
                        inactiveColor: const Color(0xFF1B2A1B),
                        onChanged: (val) {
                          provider.updatePerformaPeak(val.round());
                          _peakPerfController.text = val.round().toString();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 84,
                      child: TextField(
                        controller: _peakPerfController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          fillColor: const Color(0xFF141E14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (val) {
                          final n = int.tryParse(val) ?? 0;
                          provider.updatePerformaPeak(n);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Power Kemenangan
          _buildItemCard(
            title: 'Power Kemenangan',
            currentValueText: '${detail.powerKemenangan} / 3.000',
            description:
                'Menangkan Ranked Match atau Peak Tournament untuk meningkatkan (Maksimal 3.000 poin).',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: detail.powerKemenangan.toDouble(),
                    min: 0,
                    max: 3000,
                    divisions: 150,
                    activeColor: HokTheme.neonLime,
                    inactiveColor: const Color(0xFF1B2A1B),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      fillColor: const Color(0xFF141E14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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

          // SEKSI 2: PENGALI TOTAL
          const Text(
            '2. Komponen Pengali Total',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Pengali Peak
          _buildItemCard(
            title: 'Pengali Peak',
            currentValueText:
                '${detail.pengaliPeakPercent.toStringAsFixed(0)}%',
            description:
                'Poin Peak saat ini: ${detail.poinPeakSaatIni}. Dihitung otomatis: +1% setiap kelipatan 20 poin di atas 1.200 (Minimal 1.200 poin).',
            child: Row(
              children: [
                const Icon(
                  Icons.military_tech_rounded,
                  color: HokTheme.neonLime,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Poin Peak Tourney:',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _poinPeakController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '1200',
                      hintStyle: const TextStyle(
                        color: HokTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixText: 'Poin',
                      fillColor: const Color(0xFF141E14),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.trim().isEmpty) {
                        provider.updatePoinPeak(1200);
                      } else {
                        final n = int.tryParse(val) ?? 1200;
                        provider.updatePoinPeak(n < 1200 ? 1200 : n);
                      }
                      _peakPerfController.text = provider
                          .heroDetail
                          .powerPerformaPeak
                          .toString();
                    },
                    onEditingComplete: () {
                      final val = _poinPeakController.text.trim();
                      final n = int.tryParse(val);
                      if (n != null && n < 1200) {
                        _poinPeakController.text = '1200';
                        provider.updatePoinPeak(1200);
                      }
                      FocusScope.of(context).unfocus();
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
            currentValueText:
                '${detail.pengaliKeaktifanPercent.toStringAsFixed(0)}%',
            description:
                'Keaktifan hero (${detail.pengaliKeaktifanPercent < 50 ? 'Tidak/Kurang Aktif' : 'Aktif'}). Menurun setiap minggu jika tidak dimainkan, dapat dipulihkan dengan bermain & MVP.',
            child: Slider(
              value: detail.pengaliKeaktifanPercent,
              min: 10,
              max: 100,
              divisions: 18,
              activeColor: HokTheme.neonLime,
              inactiveColor: const Color(0xFF1B2A1B),
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
                backgroundColor: HokTheme.neonLime,
                foregroundColor: HokTheme.darkText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.assignment_turned_in_rounded),
              label: Text(
                'Terapkan Power ${HOKUtils.formatNumber(detail.finalHeroPower)} ke Slot Lane',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFormulaBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141C14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF223022)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: HokTheme.textSecondary, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: HokTheme.neonLime,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D130D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1C281C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF182418),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentValueText,
                  style: const TextStyle(
                    color: HokTheme.neonLime,
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
            style: const TextStyle(
              color: HokTheme.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  void _showApplyToSlotSheet(
    BuildContext context,
    CalculatorProvider provider,
  ) {
    final laneData = provider.currentLaneData;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F150F),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Nilai power ${HOKUtils.formatNumber(provider.heroDetail.finalHeroPower)} akan disalin ke slot:',
                style: const TextStyle(
                  color: HokTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Top 1-5 Hero Utama (100%):',
                      style: TextStyle(
                        color: HokTheme.neonLime,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(5, (idx) {
                      final h = laneData.heroUtama[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF1D2A1D),
                          child: Text(
                            '#${idx + 1}',
                            style: const TextStyle(
                              color: HokTheme.neonLime,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          h.heroName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Text(
                          '${h.power} Power',
                          style: const TextStyle(
                            color: HokTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          provider.applyHeroPowerToSlot(
                            isUtama: true,
                            index: idx,
                          );
                          Navigator.pop(ctx);
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text(
                      'Top 6-10 Hero OP (20%):',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(5, (idx) {
                      final h = laneData.heroOP[idx];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF1D2A1D),
                          child: Text(
                            '#${idx + 6}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          h.heroName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Text(
                          '${h.power} Power',
                          style: const TextStyle(
                            color: HokTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          provider.applyHeroPowerToSlot(
                            isUtama: false,
                            index: idx,
                          );
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
