import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/provider/theme_provider.dart';

class AuthHeaderSection extends ConsumerWidget {
  const AuthHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeState = ref.watch(themeNotifierProvider);

    return DrawerHeader(
      //decoration: const BoxDecoration(color: Colors.blue),
      child: authState.when(
        data: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.state == AuthState.authenticated)
              Text(
                '${state.user?.nombre} ${state.user?.apellido}',
                style: const TextStyle(
                  //color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Mi Cuenta',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (_, __) => const Text(
          'Error cargando usuario',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
