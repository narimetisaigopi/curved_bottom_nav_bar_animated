import 'package:flutter/material.dart';

/// A single item shown in a [CurvedBottomNavBar].
class CurvedBottomNavItem {
  /// Creates a navigation item.
  const CurvedBottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.iconSize,
    this.activeIconSize,
  });

  /// The icon shown when the item is inactive (and active, if [activeIcon] is
  /// not provided).
  final IconData icon;

  /// An optional icon shown when the item is active. Falls back to [icon].
  final IconData? activeIcon;

  /// An optional semantics label used for accessibility.
  final String? label;

  /// Optional size for this item's inactive icon.
  final double? iconSize;

  /// Optional size for this item's active icon.
  final double? activeIconSize;
}
