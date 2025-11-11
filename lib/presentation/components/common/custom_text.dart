import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final bool? adaptToTheme;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.adaptToTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      //width: double.infinity, // ocupa todo el ancho disponible
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          color: color ??
              (adaptToTheme! ? theme.textTheme.bodyMedium?.color : Colors.black),
          fontWeight: fontWeight ?? FontWeight.normal,
          letterSpacing: letterSpacing,
          height: height,
        ),
      ),
    );
  }
}
