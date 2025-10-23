import 'package:flutter/material.dart';

class InfoCardSimple extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? color; // color del icono
  final VoidCallback? onTap;
  final double? size;

  const InfoCardSimple({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = color ?? (isDark ? Colors.tealAccent : Colors.blue);

    // Color del borde según el tema
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1.5), // borde agregado
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          leading: icon != null
              ? CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.2),
                  child: Icon(icon, color: iconColor),
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontSize: size,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
