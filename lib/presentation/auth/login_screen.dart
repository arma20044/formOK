import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/auth_state_data.dart';

class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}

final List<DropdownItem> dropDownItems = [
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
  DropdownItem? selectedTipoDocumento;

  @override
  void dispose() {
    numeroController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ ref.listen para manejar navegación y mensajes
    ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (authData) {
          if (authData.state == AuthState.authenticated) {
            // Navegación segura después del build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/');
            });
          } else if (authData.state == AuthState.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login fallido')),
              );
            });
          }
        },
      );
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Cuenta - Acceder")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<DropdownItem>(
              value: selectedTipoDocumento,
              hint: const Text("Seleccionar Tipo de Documento"),
              items: dropDownItems
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedTipoDocumento = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numeroController,
              decoration: const InputDecoration(labelText: 'Número de Documento'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // ✅ Spinner en el botón
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading || selectedTipoDocumento == null
                    ? null
                    : () {
                        ref.read(authProvider.notifier).login(
                              numeroController.text.trim(),
                              passwordController.text.trim(),
                              selectedTipoDocumento!.id,
                            );
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
