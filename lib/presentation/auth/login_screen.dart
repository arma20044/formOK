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
  final loginFormKey = GlobalKey<FormState>();

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
          if (!mounted) {
            return; // 🔹 Evita ejecutar si el widget ya fue desmontado
          }

          if (authData.state == AuthState.authenticated) {
            // Navegación segura después del build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

             context.go('/');
              //GoRouter.of(context).go('/');
            });
          } else if (authData.state == AuthState.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Login fallido')));
            });
          }
        },
      );
    });

    final isLoading = authState.isLoading;

    return Form(
      key: loginFormKey,
      child: Scaffold(
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
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item.name)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedTipoDocumento = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número de CI, RUC o Pasaporte',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Número de CI, RUC o Pasaporte';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ✅ Spinner en el botón
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isLoading || selectedTipoDocumento == null)
                      ? null
                      : () {
                          // Valida el formulario
                          if (loginFormKey.currentState!.validate()) {
                            // Llama al login solo si el formulario es válido
                            ref
                                .read(authProvider.notifier)
                                .login(
                                  numeroController.text.trim(),
                                  passwordController.text.trim(),
                                  selectedTipoDocumento!.id,
                                  false
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ), // botón ancho completo
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Acceder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
