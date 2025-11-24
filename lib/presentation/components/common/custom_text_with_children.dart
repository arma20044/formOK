import 'package:flutter/material.dart';
import 'package:form/utils/utils.dart';

class CustomTextWithChildren extends StatelessWidget {
  final String? text;
  final List<InlineSpan>? children; // <- nuevos hijos
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final bool? adaptToTheme;
  final bool? underline;
  final bool? separadorMiles;

  const CustomTextWithChildren({
    super.key,
    this.text,
    this.children,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.adaptToTheme = true,
    this.underline = false,
    this.separadorMiles = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle baseStyle = TextStyle(
      fontSize: fontSize ?? 14,
      color: color ?? (adaptToTheme! ? theme.textTheme.bodyMedium?.color : Colors.black),
      fontWeight: fontWeight ?? FontWeight.normal,
      letterSpacing: letterSpacing,
      height: height,
      decoration: underline! ? TextDecoration.underline : TextDecoration.none,
    );

    if (children != null && children!.isNotEmpty) {
      return Text.rich(
        TextSpan(
          text: separadorMiles == true && text != null
              ? formatMiles(int.parse(text!.replaceAll(r'\D+', '')))
              : text,
          style: baseStyle,
          children: children,
        ),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
      );
    }

    return Text(
      separadorMiles == true && text != null
          ? formatMiles(int.parse(text!.replaceAll(r'\D+', '')))
          : text ?? '',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: baseStyle,
    );
  }
}
