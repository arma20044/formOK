import 'package:flutter/material.dart';

class RegistroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const RegistroAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Mi Cuenta - Registrate"),
      bottom: TabBar(
        controller: controller,
        tabs: const [
          Tab(text: "Paso 1"),
          Tab(text: "Paso 2"),
          Tab(text: "Paso 3"),
          Tab(text: "Paso 4"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}
