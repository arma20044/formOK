import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/auth/model/user_model.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/repositories/cambio_contrasenha_repository_impl.dart';
import 'package:go_router/go_router.dart';

class CambioContrasenhaScreen extends ConsumerStatefulWidget {
  const CambioContrasenhaScreen({super.key});

  @override
  ConsumerState<CambioContrasenhaScreen> createState() =>
      _CambioContrasenhaScreenState();
}

class _CambioContrasenhaScreenState
    extends ConsumerState<CambioContrasenhaScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final passwordAnteriorController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmacionController = TextEditingController();

  final repoCambioContrasenha = CambioContrasenhaRepositoryImpl(
    CambioContrasenhaDatasourceImpl(MiAndeApi()),
  );

  void _enviarFormulario(UserModel user) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese todos los cambios')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final cambioContrasenhaResponse = await repoCambioContrasenha
          .getCambioContrasenha(
            passwordAnteriorController.text,
            passwordController.text,
            passwordConfirmacionController.text,
            user.tipoCliente,
            user.token,
          );

      if (!mounted) return;
      if (cambioContrasenhaResponse.error!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cambioContrasenhaResponse.errorValList![0])),
        );
        return;
      } else {
        // Si todo está correcto:
        // Actualiza contraseña en AuthNotifier
        await ref
            .read(authProvider.notifier)
            .actualizarPassword(passwordController.text);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) GoRouter.of(context).go('/');
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cambioContrasenhaResponse.mensaje!)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  bool passwordAnteriorInvisible = true;
  bool passwordNuevoInvisible = true;
  bool passwordNuevoConfirmarInvisible = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    UserModel? datosJson;

    if (authState.value?.state == AuthState.authenticated) {
      //datosJson = authState.value?.user;
      //print(datosJson!.apellido);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Cambiar Contraseña")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Text("data"),
               Visibility(
                visible: authState.value?.user?.modificarPassword == 'S',
                 child: InfoCardSimple(
                  title: "Debe cambiar la contraseña para continuar",
                  subtitle: "",
                  color: Colors.red,
                  size: 14,
                               ),
               ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordAnteriorController,
                decoration: InputDecoration(
                  labelText: 'Contraseña Anterior',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordAnteriorInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordAnteriorInvisible = !passwordAnteriorInvisible;
                      });
                    },
                  ),
                ),
                obscureText: passwordAnteriorInvisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña Anterior';
                  }
                  return null;
                },
                //enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña nueva',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordNuevoInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordNuevoInvisible = !passwordNuevoInvisible;
                      });
                    },
                  ),
                ),
                obscureText: passwordNuevoInvisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Contraseña nueva';
                  }
                  return null;
                },
                //enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordConfirmacionController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña nueva',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordNuevoConfirmarInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordNuevoConfirmarInvisible =
                            !passwordNuevoConfirmarInvisible;
                      });
                    },
                  ),
                ),
                obscureText: passwordNuevoConfirmarInvisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme la contraseña nueva';
                  }
                  return null;
                },
                // enabled: !isLoading,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _enviarFormulario(authState.value!.user!),
                  child: Text("Cambiar Contraseña"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
