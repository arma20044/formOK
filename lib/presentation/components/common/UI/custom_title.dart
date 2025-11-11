import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final String size;
  final TextStyle? styleAdd;

  const CustomTitle({
    Key? key,
    required this.text,
    this.color,
    this.size = 'medium',
    this.styleAdd,
  }) : super(key: key);

  double _getFontSize(String size) {
    switch (size) {
      case 'extraSmall':
        return 12;
      case 'small':
        return 14;
      case 'medium':
        return 18;
      case 'large':
        return 24;
      default:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.colorScheme.primary;

    return Text(
      text,
      style: TextStyle(
        fontSize: _getFontSize(size),
        fontWeight: FontWeight.bold,
        color: textColor,
      ).merge(styleAdd),
    );
  }
}
