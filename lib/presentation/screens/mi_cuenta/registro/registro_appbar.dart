import 'package:flutter/material.dart';

class RegistroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final VoidCallback onNextTab;
  final VoidCallback onPreviousTab;

  const RegistroAppBar({
    super.key,
    required this.controller,
    required this.onNextTab,
    required this.onPreviousTab,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Mi Cuenta - Registrate"),
      bottom: TabBar(
        controller: controller,
        onTap: (index) {
          // Decidir si vamos al siguiente o anterior tab
          if (index > controller.index) {
            // Intento ir hacia adelante
            onNextTab();
          } else if (index < controller.index) {
            // Intento ir hacia atrás
            onPreviousTab();
          }
          // Si es el mismo index, no hacemos nada
        },
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
