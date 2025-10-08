import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/auth/login_screen.dart';

class AuthDrawerSection extends ConsumerWidget {
  const AuthDrawerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (state) {
        if (state.state == AuthState.authenticated) {
          return ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              Navigator.pop(context); // cerrar Drawer primero
              await ref.read(authProvider.notifier).logout();
            },
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
