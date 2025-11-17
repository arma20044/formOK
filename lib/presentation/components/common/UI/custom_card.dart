import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_title.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String titleSize;
  final Color? titleColor;
  final double borderWidth;
  final Color? borderColor;
  final Widget child;
  final BoxDecoration? styleAdd;

  const CustomCard({
    super.key,
    this.title,
    this.titleSize = 'large',
    this.titleColor,
    this.borderWidth = 1.0,
    required this.child,
    this.styleAdd, this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    //final borderColor = colors.outlineVariant; // equivalente a colors.tertiary
    final dividerColor = colors.surfaceContainerHighest; // equivalente a colors.neutral1

    return Container(
      decoration: styleAdd ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: borderWidth,
              color: borderColor != null ? borderColor! :colors.outlineVariant,
            ),
          ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Título opcional
          if (title != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitle(
                  text: title!,
                  size: titleSize,
                  color: titleColor ?? colors.primary,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 1,
                  color: dividerColor,
                ),
              ],
            ),

          // 📦 Contenido (children)
          Padding(
            padding: EdgeInsets.only(top: title != null ? 10 : 0),
            child: child,
          ),
        ],
      ),
    );
  }
}
