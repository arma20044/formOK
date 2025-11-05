import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/model/constans/textos.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';
import 'package:form/provider/router_history_notifier.dart';
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
  final documentoIdentificacionRepresentanteController =
      TextEditingController();
  final passwordController = TextEditingController();
  DropdownItem? selectedTipoDocumento;
  final loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    numeroController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool passwordInvisible = true;

  final List<ModalModel> listaTipoSolicitante = dataTipoSolicitanteArray;

  ModalModel? selectedTipoSolicitante;
  bool _listenerAttached = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    // 🔹 Navegación inmediata si ya autenticado
    authState.whenOrNull(
      data: (authData) {
        if (!mounted) return;

        if (authData.state == AuthState.authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            GoRouter.of(context).go('/'); // navega al home
          });
        }
      },
    );

    // 🔹 Adjuntar listener una sola vez
    if (!_listenerAttached) {
      ref.listen<AsyncValue<AuthStateData>>(authProvider, (previous, next) {
        next.when(
          data: (authData) {
            if (!mounted) return;

            // Navegación post-frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (authData.state == AuthState.authenticated) {
                final previousUri = ref.read(routeHistoryProvider)['previous'];
                if (previousUri != null &&
                    previousUri.path != '/login' &&
                    previousUri.path != '/splash') {
                  // Volver a la ruta anterior
                  ref.read(goRouterProvider).go(previousUri.toString());
                } else {
                  // Si no hay historial válido → ir al home
                  ref.read(goRouterProvider).go('/');
                }

                //GoRouter.of(context).go('/'); // Login correcto → Home
              } else if (authData.state == AuthState.error) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Login fallido')));
              }
            });
          },
          error: (err, stack) {
            if (!mounted) return;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error inesperado: $err')));
            });
          },
          loading: () {},
        );
      });
      _listenerAttached = true;
    }

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
                      initialValue: selectedTipoDocumento,
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
                          : (value) {
                              setState(() => selectedTipoDocumento = value);
                              numeroController.text = "";
                            },

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
                    Visibility(
                      visible:
                          selectedTipoDocumento?.id.compareTo('TD002') == 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          DropdownCustom<ModalModel>(
                            label: "Tipo Solicitante",
                            items: listaTipoSolicitante,
                            value: selectedTipoSolicitante,
                            displayBuilder: (b) => b.descripcion!,
                            validator: (val) => val == null
                                ? "Seleccione un Tipo Solicitante"
                                : null,
                            onChanged: (val) => setState(() {
                              selectedTipoSolicitante = val;
                              //numeroController.text = "";
                            }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          selectedTipoSolicitante != null &&
                          selectedTipoSolicitante?.id?.compareTo(
                                "Particular",
                              ) !=
                              0,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          TextFormField(
                            controller:
                                documentoIdentificacionRepresentanteController,
                            decoration: const InputDecoration(
                              labelText: 'Número de CI, del Representante',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese Número de CI del Representante';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordInvisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordInvisible = !passwordInvisible;
                            });
                          },
                        ),
                      ),
                      obscureText: passwordInvisible,
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
                                        selectedTipoSolicitante != null &&
                                                selectedTipoSolicitante?.id !=
                                                    null
                                            ? selectedTipoSolicitante!.id!
                                            : "",
                                        documentoIdentificacionRepresentanteController
                                            .text
                                            .trim(),
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
                            GoRouter.of(context).push('/olvidoContrasenha');
                          },
                          child: const Text('Olvido de Contraseña'),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push('/registroMiCuenta');
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
                      child: Text(
                        estimadoCliente,
                        style: TextStyle(fontSize: 13),
                      ),
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
