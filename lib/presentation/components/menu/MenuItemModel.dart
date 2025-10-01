import 'package:flutter/material.dart';

/// Modelo que describe un item del menú.
class MenuItemModel {
  final String id;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final String? badge; // opcional, por ejemplo: "3", "Nuevo"

  MenuItemModel({
    required this.id,
    required this.icon,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.badge,
  });
}

/// Grupo de items en el menú (título opcional).
class MenuGroup {
  final String? title;
  final List<MenuItemModel> items;

  MenuGroup({this.title, required this.items});
}

/// Widget: botón del menú (ícono arriba, texto abajo).
class MenuButton extends StatelessWidget {
  final MenuItemModel item;
  final double iconSize;
  final TextStyle? labelStyle;
  final double spacing;
  final Color? activeColor;
  final Color? disabledColor;
  final double borderRadius;

  const MenuButton({
    Key? key,
    required this.item,
    this.iconSize = 36,
    this.labelStyle,
    this.spacing = 8,
    this.activeColor,
    this.disabledColor,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = item.enabled && item.onTap != null;
    final iconColor = enabled ? (activeColor ?? theme.colorScheme.primary) : (disabledColor ?? theme.disabledColor);
    final textStyle = labelStyle ?? theme.textTheme.bodySmall;

    Widget icon = Icon(item.icon, size: iconSize, color: iconColor);

    // badge (si existe)
    if (item.badge != null && item.badge!.isNotEmpty) {
      icon = Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            right: -8,
            top: -8,
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
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: enabled ? item.onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(height: spacing),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 80),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: textStyle?.copyWith(
                    color: enabled ? textStyle.color : (disabledColor ?? theme.disabledColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget: menú principal con grupos.
class MainMenu extends StatelessWidget {
  final List<MenuGroup> groups;
  final double iconSize;
  final TextStyle? itemLabelStyle;

  const MainMenu({
    Key? key,
    required this.groups,
    this.iconSize = 36,
    this.itemLabelStyle,
  }) : super(key: key);

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
                const SizedBox(height: 8),
              ],
              GridView.count(
                crossAxisCount: 3, // 👈 siempre 3 columnas
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1, // cuadrado (ajusta si querés más alto)
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
