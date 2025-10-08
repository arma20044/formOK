import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:go_router/go_router.dart';

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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final numeroController = TextEditingController();
  final passwordController = TextEditingController();
  DropdownItem? selectedTipDocumento;

  @override
  void dispose() {
    numeroController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ ref.listen dentro del build
    ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (authData) {
          if (authData.state == AuthState.authenticated) {
            GoRouter.of(context).go('/');
          } else if (authData.state == AuthState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login fallido')),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Cuenta - Acceder")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            DropdownButtonFormField<DropdownItem>(
              value: selectedTipDocumento,
              hint: const Text("Seleccionar Tipo de Documento"),
              items: dropDownItems
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item.name)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedTipDocumento = value);
              },
            ),
            TextField(controller: numeroController, decoration: const InputDecoration(labelText: 'Numero de Documento')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
              onPressed: selectedTipDocumento == null || authState.isLoading
                  ? null
                  : () {
                      ref.read(authProvider.notifier).login(
                            numeroController.text,
                            passwordController.text,
                            selectedTipDocumento!.id,
                          );
                    },
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
