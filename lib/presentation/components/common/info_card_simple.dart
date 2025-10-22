import 'package:flutter/material.dart';

class InfoCardSimple extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;
  final double? size;

  const InfoCardSimple({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    required this.color,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: icon != null ? CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ) : Text(""),
        title: Text(
          title,
          style:  TextStyle( fontSize: size  ),
        ),
        //subtitle: Text(subtitle),
        //trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
