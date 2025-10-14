import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:go_router/go_router.dart';

class AuthDrawerSection extends ConsumerWidget {
  const AuthDrawerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Obtener ruta actual de manera segura
    String? currentPath;
    try {
      currentPath = GoRouter.of(context).state.uri.path;
    } catch (_) {
      currentPath = null; // en caso de que el contexto no sea del router
    }

    return authState.when(
      data: (state) {
        if (state.state == AuthState.authenticated) {
          return Column(
            children: [
              _drawerItem(
                context,
                icon: Icons.electric_meter_outlined,
                title: 'Suministros',
                path: '/suministros',
                currentPath: currentPath,
              ),
              _drawerItem(
                context,
                icon: Icons.article_outlined,
                title: 'Solicitudes',
                path: '/solicitudes',
                currentPath: currentPath,
              ),
              _drawerItem(
                context,
                icon: Icons.folder_copy_outlined,
                title: 'Expedientes',
                path: '/expediente',
                currentPath: currentPath,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _drawerItem(
                context,
                icon: Icons.login,
                title: 'Acceder',
                path: '/login',
                currentPath: currentPath,
              ),
              _drawerItem(
                context,
                icon: Icons.person_add_alt_outlined,
                title: 'Regístrate',
                path: '/registroMiCuenta',
                currentPath: currentPath,
              ),
              const Divider(),
            ],
          );
        }
      },
      loading: () =>
          const ListTile(title: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String path,
    required String? currentPath,
  }) {
    final isActive = currentPath == path;

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue : null,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: isActive
          ? () => Navigator.pop(context)
          : () {
              Navigator.pop(context);
              context.push(path); // ✅ usa go, no push
            },
    );
  }
}
