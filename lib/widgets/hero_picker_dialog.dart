import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../models/hero_model.dart';

class HeroPickerDialog extends StatefulWidget {
  final HokLane? initialLane;
  final Function(HokHero hero) onSelected;

  const HeroPickerDialog({
    super.key,
    this.initialLane,
    required this.onSelected,
  });

  @override
  State<HeroPickerDialog> createState() => _HeroPickerDialogState();
}

class _HeroPickerDialogState extends State<HeroPickerDialog> {
  String _searchQuery = '';
  HokLane? _filterLane;

  @override
  void initState() {
    super.initState();
    _filterLane = widget.initialLane;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = AppConstants.allHeroes.where((hero) {
      final matchesQuery = hero.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLane = _filterLane == null || hero.lane == _filterLane;
      return matchesQuery && matchesLane;
    }).toList();

    return Dialog(
      backgroundColor: const Color(0xFF111D33),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 480,
        height: 560,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group, color: HokTheme.blueCyan),
                const SizedBox(width: 8),
                const Text(
                  'Pilih Hero Honor of Kings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: HokTheme.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama hero (misal: Dharma, Lam)...',
                prefixIcon: Icon(Icons.search, color: HokTheme.blueCyan),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 12),

            // Filter Chips per Lane
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: _filterLane == null,
                    onSelected: (sel) {
                      setState(() {
                        _filterLane = null;
                      });
                    },
                    selectedColor: HokTheme.blueCyan,
                    labelStyle: TextStyle(
                      color: _filterLane == null ? Colors.black : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ...HokLane.values.map((lane) {
                    final isSel = _filterLane == lane;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(lane.displayName),
                        selected: isSel,
                        onSelected: (sel) {
                          setState(() {
                            _filterLane = sel ? lane : null;
                          });
                        },
                        selectedColor: lane.accentColor,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.black : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // List Hero
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'Hero tidak ditemukan',
                        style: TextStyle(color: HokTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final hero = filtered[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: hero.lane.accentColor.withValues(alpha: 0.25),
                            child: Text(
                              hero.name.substring(0, hero.name.length >= 2 ? 2 : 1).toUpperCase(),
                              style: TextStyle(
                                color: hero.lane.accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          title: Text(
                            hero.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${hero.lane.displayName} (${hero.lane.chineseName})',
                            style: const TextStyle(
                              color: HokTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2E50),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${hero.defaultPower} Pwr',
                              style: const TextStyle(
                                color: HokTheme.goldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            widget.onSelected(hero);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
