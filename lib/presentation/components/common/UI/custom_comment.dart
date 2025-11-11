import 'package:flutter/material.dart';

class CustomComment extends StatelessWidget {
  final String? text;
  final Widget? child;
  final List<Widget>? children;
  final BoxDecoration? styleAdd;
  final String size;
  final bool bold;

  const CustomComment({
    Key? key,
    this.text,
    this.child,
    this.children,
    this.styleAdd,
    this.size = 'medium',
    this.bold = false,
  }) : super(key: key);

  double _getFontSize(String size) {
    switch (size) {
      case 'extraSmall':
        return 10;
      case 'small':
        return 12;
      case 'medium':
        return 14;
      case 'large':
        return 18;
      case 'extraLarge':
        return 22;
      default:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores y estilos del tema actual
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: styleAdd ??
          BoxDecoration(
            color: colors.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: _getFontSize(size),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          if (child != null) child!,
          if (children != null) ...children!,
        ],
      ),
    );
  }
}
