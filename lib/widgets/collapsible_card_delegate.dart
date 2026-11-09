import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../core/theme.dart';

class CollapsibleCardDelegate extends SliverPersistentHeaderDelegate {
  CollapsibleCardDelegate({
    required this.expandedHeight,
    required this.expandedBuilder,
    required this.collapsedBuilder,
    this.collapsedHeight = 52,
    this.topGap = 8,
    this.expandedHMargin = 16,
    this.collapsedHMargin = 48,
    this.expandedRadius = 20,
    this.collapsedRadius = 32,
    this.background = const Color(0xFF0C140D),
    this.border = const Color(0xFF1E2E1F),
    this.glow = HokTheme.neonLime,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final double topGap;
  final double expandedHMargin;
  final double collapsedHMargin;
  final double expandedRadius;
  final double collapsedRadius;
  final Color background;
  final Color border;
  final Color glow;
  final WidgetBuilder expandedBuilder;
  final WidgetBuilder collapsedBuilder;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight + topGap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final range = maxExtent - minExtent;
    final t = range <= 0 ? 0.0 : (shrinkOffset / range).clamp(0.0, 1.0);
    final h = lerpDouble(expandedHMargin, collapsedHMargin, t)!;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(h, lerpDouble(0, topGap, t)!, h, 0),
        child: Container(
          width: double.infinity,
          height: lerpDouble(expandedHeight, collapsedHeight, t),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              lerpDouble(expandedRadius, collapsedRadius, t)!,
            ),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: glow.withValues(alpha: 0.08 + 0.12 * t),
                blurRadius: 24,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Konten Expanded (fade out saat scroll ke bawah)
              IgnorePointer(
                ignoring: t > 0.5,
                child: Opacity(
                  opacity: (1 - t * 1.8).clamp(0.0, 1.0),
                  child: OverflowBox(
                    maxHeight: expandedHeight,
                    alignment: Alignment.topCenter,
                    child: expandedBuilder(context),
                  ),
                ),
              ),
              // Konten Collapsed Pill (fade in saat menyusut)
              IgnorePointer(
                ignoring: t < 0.5,
                child: Opacity(
                  opacity: ((t - 0.5) / 0.5).clamp(0.0, 1.0),
                  child: Center(child: collapsedBuilder(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CollapsibleCardDelegate oldDelegate) => true;
}

