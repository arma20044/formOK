// lib/presentation/components/menu/main_menu.dart
import 'package:flutter/material.dart';
import 'menu_models.dart';

class MenuButton extends StatelessWidget {
  final MenuItemModel item;
  final double iconSize;
  final TextStyle? labelStyle;

  const MenuButton({
    super.key,
    required this.item,
    this.iconSize = 36,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = item.enabled && item.onTap != null;
    final iconColor = enabled ? theme.colorScheme.primary : theme.disabledColor;
    final textStyle = labelStyle ?? theme.textTheme.bodySmall;

    Widget icon = Icon(item.icon, size: iconSize, color: iconColor);

    if (item.badge != null && item.badge!.isNotEmpty) {
      icon = Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 16),
              child: Text(
                item.badge!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: item.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap != null ? () => item.onTap!(context) : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: textStyle?.copyWith(
                  color: enabled ? textStyle.color : theme.disabledColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final List<MenuGroup> groups;
  final double iconSize;
  final TextStyle? itemLabelStyle;

  const MainMenu({
    super.key,
    required this.groups,
    this.iconSize = 36,
    this.itemLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: groups.map((group) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.title != null) ...[
                Text(group.title!, style: Theme.of(context).textTheme.titleMedium),
                Divider(
                   //color: theme.dividerColor,
                  thickness: 1,
                  height: 16,
                ),
                //const SizedBox(height: 4),
              ],
              GridView.count(
                crossAxisCount: 3, // 👈 siempre 3 columnas
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: group.items.map((item) {
                  return MenuButton(
                    item: item,
                    iconSize: iconSize,
                    labelStyle: itemLabelStyle,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
