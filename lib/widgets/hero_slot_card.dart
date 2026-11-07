import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../providers/calculator_provider.dart';
import 'hero_picker_dialog.dart';

class HeroSlotCard extends StatelessWidget {
  final int rankNumber; // 1 s/d 10
  final bool isUtama;   // true = Top 5 (100%), false = Top 6-10 (20%)
  final int slotIndex;  // 0 s/d 4

  const HeroSlotCard({
    super.key,
    required this.rankNumber,
    required this.isUtama,
    required this.slotIndex,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final laneData = provider.currentLaneData;
    final slotData = isUtama
        ? laneData.heroUtama[slotIndex]
        : laneData.heroOP[slotIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF14213B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUtama
              ? const Color(0xFF2E4675)
              : const Color(0xFF1F3255),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Ranking Badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isUtama
                  ? HokTheme.goldAccent.withValues(alpha: 0.2)
                  : const Color(0xFF1B2E50),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isUtama ? HokTheme.goldAccent : const Color(0xFF2C4372),
              ),
            ),
            child: Center(
              child: Text(
                '#$rankNumber',
                style: TextStyle(
                  color: isUtama ? HokTheme.goldAccent : HokTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Avatar & Hero Name (Clickable to change hero)
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => HeroPickerDialog(
                    initialLane: laneData.lane,
                    onSelected: (selectedHero) {
                      provider.updateHeroName(
                        isUtama: isUtama,
                        index: slotIndex,
                        newName: selectedHero.name,
                      );
                      // Jika power masih 0, isi otomatis default power
                      if (slotData.power == 0) {
                        if (isUtama) {
                          provider.updateHeroUtamaPower(slotIndex, selectedHero.defaultPower);
                        } else {
                          provider.updateHeroOPPower(slotIndex, selectedHero.defaultPower);
                        }
                      }
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isUtama
                          ? const Color(0xFF263D69)
                          : const Color(0xFF192A47),
                      child: Text(
                        slotData.heroName.isNotEmpty
                            ? slotData.heroName.substring(0, slotData.heroName.length >= 2 ? 2 : 1).toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: isUtama ? HokTheme.blueCyan : HokTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slotData.heroName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Klik ganti hero',
                            style: TextStyle(
                              color: HokTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Input Power Field
          SizedBox(
            width: 110,
            child: _PowerInputField(
              initialValue: slotData.power,
              onChanged: (newPower) {
                if (isUtama) {
                  provider.updateHeroUtamaPower(slotIndex, newPower);
                } else {
                  provider.updateHeroOPPower(slotIndex, newPower);
                }
              },
            ),
          ),

          const SizedBox(width: 6),

          // Quick Delta Buttons (+100, +500)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuickButton(
                label: '+100',
                onTap: () => provider.quickDeltaPower(
                  isUtama: isUtama,
                  index: slotIndex,
                  delta: 100,
                ),
              ),
              const SizedBox(width: 4),
              _buildQuickButton(
                label: '+500',
                onTap: () => provider.quickDeltaPower(
                  isUtama: isUtama,
                  index: slotIndex,
                  delta: 500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2C4E),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF28406E)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: HokTheme.blueCyan,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PowerInputField extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const _PowerInputField({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_PowerInputField> createState() => _PowerInputFieldState();
}

class _PowerInputFieldState extends State<_PowerInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(covariant _PowerInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue.toString() != _controller.text) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        prefixIcon: Icon(Icons.diamond_outlined, color: HokTheme.goldAccent, size: 14),
        prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val) ?? 0;
        widget.onChanged(parsed);
      },
    );
  }
}
