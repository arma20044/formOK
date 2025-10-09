import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:go_router/go_router.dart';

class AuthDrawerSection extends ConsumerWidget {
  const AuthDrawerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (state) {
        if (state.state == AuthState.authenticated) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.electric_meter_outlined),
                title: const Text('Suministros'),
                onTap: () async {
                  Navigator.pop(context); // cerrar Drawer primero
                  //await ref.read(authProvider.notifier).logout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text('Solicitudes'),
                onTap: () async {
                  Navigator.pop(context); // cerrar Drawer primero
                  //await ref.read(authProvider.notifier).logout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_copy_outlined),
                title: const Text('Expedientes'),
                onTap: () async {
                  Navigator.pop(context); // cerrar Drawer primero
                  GoRouter.of(context).push('/expediente');
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  Navigator.pop(context); // cerrar Drawer primero
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          );
        } else {
          return ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Acceder'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          );
        }
      },
      loading: () => const ListTile(
        title: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}
