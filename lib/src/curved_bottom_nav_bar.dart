import 'package:flutter/material.dart';

import 'curved_bottom_nav_item.dart';

/// A curved bottom navigation bar with an animated floating bubble that
/// highlights the currently selected tab.
///
/// The bar paints a smooth notch behind the active item and lifts a circular
/// bubble containing the active icon above the bar. All sizes, colors and
/// animation timings are configurable.
class CurvedBottomNavBar extends StatelessWidget {
  /// Creates a curved bottom navigation bar.
  ///
  /// [items] must contain at least two entries and [currentIndex] must be a
  /// valid index into [items].
  const CurvedBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor = const Color(0xFFFF6A00),
    this.activeBubbleColor = Colors.white,
    this.activeIconColor = const Color(0xFFFF6A00),
    this.inactiveIconColor = Colors.white,
    this.barHeight = 58.0,
    this.bubbleSize = 58.0,
    this.bubbleLift = 24.0,
    this.notchWidth = 62.0,
    this.notchDepth = 40.0,
    this.iconSize = 24.0,
    this.activeIconSize = 26.0,
    this.bubbleShadow = const [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
    this.animationDuration = const Duration(milliseconds: 280),
    this.animationCurve = Curves.easeOutCubic,
  })  : assert(items.length >= 2, 'At least 2 items are required'),
        assert(barHeight > 0, 'barHeight must be positive'),
        assert(bubbleSize > 0, 'bubbleSize must be positive');

  /// The items displayed in the bar.
  final List<CurvedBottomNavItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is tapped, with the tapped item's index.
  final ValueChanged<int> onTap;

  /// The fill color of the bar.
  final Color backgroundColor;

  /// The color of the floating bubble behind the active icon.
  final Color activeBubbleColor;

  /// The color of the active icon inside the bubble.
  final Color activeIconColor;

  /// The color of inactive icons.
  final Color inactiveIconColor;

  /// The height of the bar (excluding bottom safe-area inset).
  final double barHeight;

  /// The diameter of the floating bubble.
  final double bubbleSize;

  /// How far the bubble is lifted above the top of the bar.
  final double bubbleLift;

  /// The half-width of the painted notch on each side of the active item.
  final double notchWidth;

  /// How deep the notch curves into the bar.
  final double notchDepth;

  /// The size of inactive icons.
  final double iconSize;

  /// The size of the active icon inside the bubble.
  final double activeIconSize;

  /// The shadow cast by the floating bubble.
  final List<BoxShadow> bubbleShadow;

  /// The duration of the bubble slide/fade animations.
  final Duration animationDuration;

  /// The curve of the bubble slide animation.
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final totalHeight = barHeight + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final itemWidth = width / items.length;
          final safeIndex = currentIndex.clamp(0, items.length - 1);
          final bubbleLeft =
              (itemWidth * safeIndex) + ((itemWidth - bubbleSize) / 2);
          final notchCenterX = bubbleLeft + (bubbleSize / 2);
          final activeItem = items[safeIndex];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(width, totalHeight),
                  painter: _CurvedBarPainter(
                    color: backgroundColor,
                    notchCenterX: notchCenterX,
                    notchWidth: notchWidth,
                    notchDepth: notchDepth,
                  ),
                  child: SizedBox(
                    height: totalHeight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: Semantics(
                                label: items[i].label,
                                selected: i == safeIndex,
                                button: true,
                                child: InkWell(
                                  onTap: () => onTap(i),
                                  child: SizedBox(
                                    height: barHeight,
                                    child: Center(
                                      child: AnimatedOpacity(
                                        duration: animationDuration,
                                        opacity: i == safeIndex ? 0.0 : 1.0,
                                        child: Icon(
                                          items[i].icon,
                                          color: inactiveIconColor,
                                          size: items[i].iconSize ?? iconSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: animationDuration,
                curve: animationCurve,
                left: bubbleLeft,
                top: -bubbleLift,
                child: GestureDetector(
                  onTap: () => onTap(safeIndex),
                  child: Container(
                    width: bubbleSize,
                    height: bubbleSize,
                    decoration: BoxDecoration(
                      color: activeBubbleColor,
                      shape: BoxShape.circle,
                      boxShadow: bubbleShadow,
                    ),
                    child: Icon(
                      activeItem.activeIcon ?? activeItem.icon,
                      color: activeIconColor,
                      size: activeItem.activeIconSize ?? activeIconSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CurvedBarPainter extends CustomPainter {
  const _CurvedBarPainter({
    required this.color,
    required this.notchCenterX,
    required this.notchWidth,
    required this.notchDepth,
  });

  final Color color;
  final double notchCenterX;
  final double notchWidth;
  final double notchDepth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final left = (notchCenterX - notchWidth).clamp(0.0, size.width);
    final right = (notchCenterX + notchWidth).clamp(0.0, size.width);
    final shoulder = notchWidth * 0.65;
    final inner = notchWidth * 0.48;
    final lip = notchDepth * 0.35;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(left, 0)
      ..quadraticBezierTo(notchCenterX - shoulder, 0, notchCenterX - inner, lip)
      ..quadraticBezierTo(notchCenterX - notchWidth * 0.26, notchDepth * 0.95,
          notchCenterX, notchDepth)
      ..quadraticBezierTo(notchCenterX + notchWidth * 0.26, notchDepth * 0.95,
          notchCenterX + inner, lip)
      ..quadraticBezierTo(notchCenterX + shoulder, 0, right, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedBarPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.notchCenterX != notchCenterX ||
        oldDelegate.notchWidth != notchWidth ||
        oldDelegate.notchDepth != notchDepth;
  }
}
