import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/main.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/model/auth_state.dart';

class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}

List<DropdownItem> dropDownItems = [
  DropdownItem(id: 'TD001', name: 'C.I. Civil'),
  DropdownItem(id: 'TD002', name: 'RUC'),
  DropdownItem(id: 'TD004', name: 'Pasaporte'),
];

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final numeroDocumentoController = TextEditingController();
    final passwordController = TextEditingController();
    DropdownItem? selectedTipDocumento;

    /* ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (state) {
          if (state == AuthState.authenticated) {
            // Navigate to home screen
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
          } else if (state == AuthState.error) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed')),
            );
          }
        },
      );
    }); */
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (state) {
          if (state == AuthState.authenticated) {
            // ✅ Navegación declarativa usando GoRouter
            GoRouter.of(context).go('/');
          } else if (state == AuthState.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login failed')));
          }
        },
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            DropdownButtonFormField<DropdownItem>(
              value: selectedTipDocumento,
              hint: const Text("Seleccionar Tipo de Documento"),
              items: dropDownItems
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text(item.name)),
                  )
                  .toList(),
              onChanged: (value) {
                selectedTipDocumento = value;
              },
            ),
            TextField(
              controller: numeroDocumentoController,
              decoration: const InputDecoration(
                labelText: 'Numero de Documento',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(authProvider.notifier)
                    .login(
                      numeroDocumentoController.text,
                      passwordController.text,
                      selectedTipDocumento!.id,
                    );
              },
              child: authState.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
