import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hitung_power_hero_hok/app/theme.dart';
import 'package:hitung_power_hero_hok/core/constants.dart';
import 'package:hitung_power_hero_hok/core/numeric_input_formatter.dart';
import 'package:hitung_power_hero_hok/core/utils.dart';
import 'package:hitung_power_hero_hok/data/models/hero_detail_model.dart';
import 'package:hitung_power_hero_hok/features/hero_detail/viewmodel/hero_detail_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/power_lane/viewmodel/power_lane_viewmodel.dart';
import 'package:hitung_power_hero_hok/features/shell/view/collapsible_card_delegate.dart';
import 'package:hitung_power_hero_hok/features/shell/view/gameland_footer.dart';
import 'package:hitung_power_hero_hok/features/shell/view/gameland_hero_header.dart';
import 'package:hitung_power_hero_hok/features/shell/viewmodel/shell_viewmodel.dart';

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
    final detail = context.read<HeroDetailViewModel>().heroDetail;
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
    final provider = context.watch<HeroDetailViewModel>();
    final detail = provider.heroDetail;

    return CustomScrollView(
      slivers: [
        // 1. HEADER: Judul + Badge (sama seperti Power Lane, tapi menampilkan "Rincian Hero")
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GamelandHeroHeader(),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // 2. KARTU POWER COLLAPSIBLE (Menyusut jadi pill melayang saat scroll)
        SliverPersistentHeader(
          pinned: true,
          delegate: CollapsibleCardDelegate(
            expandedHeight: 195,
            collapsedHeight: 52,
            topGap: 8,
            expandedHMargin: 16,
            collapsedHMargin: 64,
            expandedRadius: 20,
            collapsedRadius: 32,
            maxWidth: 960,
            expandedBuilder: (context) =>
                _buildHeroPowerExpanded(context, detail),
            collapsedBuilder: (context) =>
                _buildHeroPowerCollapsed(context, detail),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 18)),

        // SEKSI INPUT KOMPONEN (Ranked, Peak, Kemenangan, Pengali) & TOMBOL TERAPKAN
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              value: detail.powerPerformaRanked
                                  .toDouble()
                                  .clamp(0.0, 2500.0),
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
                              inputFormatters: [
                                NumericInputFormatter(context: context),
                              ],
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
                              border: Border.all(
                                color: const Color(0xFF223022),
                              ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: HokTheme.neonLime
                                                  .withValues(alpha: 0.3),
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
                                  value: detail.powerPerformaPeak
                                      .toDouble()
                                      .clamp(
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
                                    _peakPerfController.text = val
                                        .round()
                                        .toString();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 84,
                                child: TextField(
                                  controller: _peakPerfController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    NumericInputFormatter(context: context),
                                  ],
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
                                _kemenanganController.text = val
                                    .round()
                                    .toString();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _kemenanganController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                NumericInputFormatter(context: context),
                              ],
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
                              inputFormatters: [
                                NumericInputFormatter(context: context),
                              ],
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
                        onPressed: () =>
                            _showApplyToSlotSheet(context, provider),
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
                    const SizedBox(height: 20),

                    // Footer
                    const GamelandFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- KARTU POWER EXPANDED (TAMPIL PENUH) ---
  Widget _buildHeroPowerExpanded(BuildContext context, HeroPowerDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedFlipCounter(
                value: detail.finalHeroPower,
                thousandSeparator: '.',
                duration: const Duration(milliseconds: 300),
                textStyle: const TextStyle(
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
          const SizedBox(height: 10),
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
    );
  }

  // --- KARTU POWER COLLAPSED (PILL KECIL MELAYANG) ---
  Widget _buildHeroPowerCollapsed(
    BuildContext context,
    HeroPowerDetail detail,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedFlipCounter(
          value: detail.finalHeroPower,
          thousandSeparator: '.',
          duration: const Duration(milliseconds: 300),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Power',
          style: TextStyle(
            color: HokTheme.neonLime,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  /// Step 1 — Pilih Lane tujuan
  void _showApplyToSlotSheet(
    BuildContext context,
    HeroDetailViewModel provider,
  ) {
    final heroPower = provider.heroDetail.finalHeroPower;
    final powerLaneVM = context.read<PowerLaneViewModel>();
    final shellVM = context.read<ShellViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F150F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: HokTheme.neonLime.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: HokTheme.neonLime,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Lane Tujuan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Terapkan power ${HOKUtils.formatNumber(heroPower)} ke lane mana?',
                          style: const TextStyle(
                            color: HokTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Grid 5 Lane
              ...HokLane.values.map((lane) {
                final laneData = powerLaneVM.laneDataMap[lane]!;
                final isActive = lane == powerLaneVM.activeLane;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.pop(ctx);
                        // Buka step 2: pilih slot di lane yang dipilih
                        _showPickSlotSheet(
                          context,
                          provider,
                          powerLaneVM,
                          shellVM,
                          lane,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? lane.accentColor.withValues(alpha: 0.12)
                              : const Color(0xFF0D130D),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isActive
                                ? lane.accentColor.withValues(alpha: 0.5)
                                : const Color(0xFF1C2A1C),
                            width: isActive ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Warna aksen lane
                            Container(
                              width: 4,
                              height: 36,
                              decoration: BoxDecoration(
                                color: lane.accentColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lane.displayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (isActive) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: HokTheme.neonLime.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'Aktif',
                                            style: TextStyle(
                                              color: HokTheme.neonLime,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Total: ${HOKUtils.formatNumber(laneData.totalPowerLane)} Power  •  Tier ${laneData.currentTier}',
                                    style: const TextStyle(
                                      color: HokTheme.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: lane.accentColor.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Step 2 — Pilih Slot di lane yang sudah dipilih
  void _showPickSlotSheet(
    BuildContext context,
    HeroDetailViewModel provider,
    PowerLaneViewModel powerLaneVM,
    ShellViewModel shellVM,
    HokLane targetLane,
  ) {
    final heroPower = provider.heroDetail.finalHeroPower;
    final laneData = powerLaneVM.laneDataMap[targetLane]!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F150F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3A2A),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header step 2
                  Row(
                    children: [
                      // Tombol kembali ke step 1
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          _showApplyToSlotSheet(context, provider);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141E14),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF223022)),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: targetLane.accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  targetLane.displayName,
                                  style: TextStyle(
                                    color: targetLane.accentColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Pilih Slot Tujuan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge power
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: HokTheme.neonLime.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: HokTheme.neonLime.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '${HOKUtils.formatNumber(heroPower)} Power',
                          style: const TextStyle(
                            color: HokTheme.neonLime,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Daftar slot
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      children: [
                        // Seksi Hero Utama
                        _buildSlotSectionHeader(
                          'Hero Utama (Bobot 100%)',
                          HokTheme.neonLime,
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(5, (idx) {
                          final h = laneData.heroUtama[idx];
                          return _buildSlotTile(
                            ctx: ctx,
                            label: '#${idx + 1}',
                            labelColor: HokTheme.neonLime,
                            heroName: h.heroName,
                            currentPower: h.power,
                            newPower: heroPower,
                            onTap: () {
                              powerLaneVM.applyHeroPowerToSlot(
                                isUtama: true,
                                index: idx,
                                targetLane: targetLane,
                                power: heroPower,
                              );
                              shellVM.switchLane(targetLane);
                              shellVM.setTab(CalculatorTab.lane);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Power ${HOKUtils.formatNumber(heroPower)} diterapkan ke slot #${idx + 1} (${targetLane.displayName})!',
                                  ),
                                  backgroundColor: const Color(0xFF162416),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 14),

                        // Seksi Hero OP
                        _buildSlotSectionHeader(
                          'Hero OP Kamu (Bobot 20%)',
                          Colors.white54,
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(5, (idx) {
                          final h = laneData.heroOP[idx];
                          return _buildSlotTile(
                            ctx: ctx,
                            label: '#${idx + 6}',
                            labelColor: Colors.white54,
                            heroName: h.heroName,
                            currentPower: h.power,
                            newPower: heroPower,
                            onTap: () {
                              powerLaneVM.applyHeroPowerToSlot(
                                isUtama: false,
                                index: idx,
                                targetLane: targetLane,
                                power: heroPower,
                              );
                              shellVM.switchLane(targetLane);
                              shellVM.setTab(CalculatorTab.lane);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Power ${HOKUtils.formatNumber(heroPower)} diterapkan ke slot #${idx + 6} (${targetLane.displayName})!',
                                  ),
                                  backgroundColor: const Color(0xFF162416),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlotSectionHeader(String label, Color color) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotTile({
    required BuildContext ctx,
    required String label,
    required Color labelColor,
    required String heroName,
    required int currentPower,
    required int newPower,
    required VoidCallback onTap,
  }) {
    final diff = newPower - currentPower;
    final diffColor = diff > 0
        ? const Color(0xFF4ADE80)
        : diff < 0
        ? const Color(0xFFFF6B6B)
        : Colors.white38;
    final diffText = diff > 0
        ? '+${HOKUtils.formatNumber(diff)}'
        : HOKUtils.formatNumber(diff);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D130D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1C281C)),
            ),
            child: Row(
              children: [
                // Badge nomor slot
                CircleAvatar(
                  radius: 15,
                  backgroundColor: labelColor.withValues(alpha: 0.15),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nama hero
                Expanded(
                  child: Text(
                    heroName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Power lama
                Text(
                  HOKUtils.formatNumber(currentPower),
                  style: const TextStyle(
                    color: HokTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white24,
                    size: 14,
                  ),
                ),
                // Power baru
                Text(
                  HOKUtils.formatNumber(newPower),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                // Delta +/-
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    diffText,
                    style: TextStyle(
                      color: diffColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Backward compatibility typedef
typedef HeroDetailView = HeroDetailTabView;
