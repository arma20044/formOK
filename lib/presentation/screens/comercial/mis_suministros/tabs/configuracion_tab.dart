import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/model/login_model.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/common/custom_message_dialog.dart';
import 'package:form/presentation/components/common/custom_show_dialog.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart'
    hide MessageType;

import '../../../../../core/auth/model/user_model.dart';
import '../../../../../infrastructure/infrastructure.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../components/common.dart';

class ConfiguracionTab extends ConsumerStatefulWidget {
  const ConfiguracionTab(this.selectedNIS, this.token, {super.key});

  final SuministrosList? selectedNIS;
  final String? token;

  @override
  ConsumerState<ConfiguracionTab> createState() => _ConfiguracionTabState();
}

class _ConfiguracionTabState extends ConsumerState<ConfiguracionTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final repoBloqueoSuministro = BloqueoSuministroRepositoryImpl(
    BloqueoSuministroDatasourceImpl(MiAndeApi()),
  );
  bool _isLoadingBloqueoSuministro = false;

  /// Bloquea o desbloquea el suministro
  void bloquearDesloquearSuministro(
    AuthStateData authStateData,
    bool newValue,
  ) async {
    BloqueoSuministroResponse result = await _fetchBloqueoSuministro(
      authStateData,
      newValue,
    );
    if (!mounted) return;

    if (result.error) {
      CustomSnackbar.show(
        context,
        message: result.mensaje,
        type: MessageType.error,
      );
      return;
    } else {
      CustomSnackbar.show(context, message: result.mensaje);
      await ref
          .read(authProvider.notifier)
          .actualizarIndicadorBloqueoNIS(newValue);
    }
  }

  /// Llama al backend para bloquear/desbloquear
  Future<BloqueoSuministroResponse> _fetchBloqueoSuministro(
    AuthStateData authStateData,
    bool newValue,
  ) async {
    try {
      setState(() {
        _isLoadingBloqueoSuministro = true;
      });

      return await repoBloqueoSuministro.getBloqueoSuministro(
        widget.selectedNIS!.nisRad.toString(),
        newValue ? 1 : 2,
        widget.token!,
      );
    } catch (e) {
      debugPrint("Error en _fetchBloqueoSuministro: $e");
      return BloqueoSuministroResponse(
        error: true,
        mensaje: "Ocurrió un error al comunicarse con el servidor",
        mensajeList: [],
        errorValList: [],
        resultado: null,
      );
    } finally {
      setState(() {
        _isLoadingBloqueoSuministro = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authState = ref.watch(authProvider);

    // Valor del switch tomado directamente del state global
    final isSwitched = widget.selectedNIS?.indicadorBloqueoWeb == 1
        ? true
        : false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Bloquear Suministro: $isSwitched",
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    "Con el bloqueo del suministro no se podrán consultar ni descargar las facturas desde el acceso público en la Página Web ni desde la APP de la ANDE",
                  ),
                ),
                const SizedBox(width: 20),
                _isLoadingBloqueoSuministro
                    ? const CircularProgressIndicator()
                    : Switch(
                        value: isSwitched,
                        onChanged: (newValue) async {
                          // Actualizamos el backend primero
                          
                          bloquearDesloquearSuministro(authState.value!, newValue);

                          // Actualizamos el state global
                          ref
                              .read(authProvider.notifier)
                              .actualizarBloqueoWeb(
                                nis: widget.selectedNIS!.nisRad!,
                                valor: newValue,
                              );
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
