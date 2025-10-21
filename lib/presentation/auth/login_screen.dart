import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/model/constans/textos.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
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
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
      next.when(
        data: (authData) {
          if (!mounted) return;
          if (authData.state == AuthState.authenticated) {
            context.go('/'); // navegar solo cuando autenticado
          } else if (authData.state == AuthState.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login fallido')));
          }
        },
        error: (err, stack) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error inesperado: $err')));
        },
        loading: () {},
      );
    });

    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: const Text("Mi Cuenta - Acceder")),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<DropdownItem>(
                      value: selectedTipoDocumento,
                      hint: const Text("Seleccionar Tipo de Documento"),
                      items: dropDownItems
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (value) =>
                                setState(() => selectedTipoDocumento = value),
                      validator: (value) => value == null
                          ? 'Seleccione un tipo de documento'
                          : null,
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
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese Contraseña';
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (isLoading || selectedTipoDocumento == null)
                            ? null
                            : () {
                                if (loginFormKey.currentState!.validate()) {
                                  ref
                                      .read(authProvider.notifier)
                                      .login(
                                        numeroController.text.trim(),
                                        passwordController.text.trim(),
                                        selectedTipoDocumento!.id,
                                        false,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Acceder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Handle left button press
                          },
                          child: const Text('Olvido de Contraseña'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle right button press
                          },
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Text(estimadoCliente,style: TextStyle(
                        fontSize: 13
                      ),),
                    ),
                  ],
                ),
              ),
            ),

            // Overlay de bloqueo
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
