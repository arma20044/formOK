// lib/presentation/components/menu/menu_models.dart
import 'package:flutter/material.dart';

class MenuItemModel {
  final String id;
  final IconData icon;
  final String label;
  final bool enabled;
  final String? badge;
  final void Function(BuildContext context)? onTap;

  MenuItemModel({
    required this.id,
    required this.icon,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.badge,
  });
}

class MenuGroup {
  final String? title;
  final List<MenuItemModel> items;

  MenuGroup({this.title, required this.items});
}
