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
import 'package:form/presentation/components/common/custom_snackbar.dart' hide MessageType;

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
  bool _isSwitched = false; // Initial state of the switch

  final repoBloqueoSuministro = BloqueoSuministroRepositoryImpl(
    BloqueoSuministroDatasourceImpl(MiAndeApi()),
  );
  bool _isLoadingBloqueoSuministro = false;

  void bloquearDesloquearSuministro(AuthStateData authStateData) async {
    BloqueoSuministroResponse result = await _fetchBloqueoSuministro(
      authStateData,
    );
    if (!mounted) return;
    if (result.error) {
      _isSwitched = !_isSwitched;

      CustomSnackbar.show(context, message: result.mensaje, type: MessageType.error);

      return;
    } else {
      //mostrar snackbar

      CustomSnackbar.show(context, message: result.mensaje);

      await ref
          .read(authProvider.notifier)
          .actualizarIndicadorBloqueoNIS(_isSwitched);
    }
  }

  Future<BloqueoSuministroResponse> _fetchBloqueoSuministro(
    AuthStateData authStateData,
  ) async {
    BloqueoSuministroResponse? bloqueoSuministro;
    try {
      setState(() {
        _isLoadingBloqueoSuministro = true; // ← mostrar spinner
      });

      bloqueoSuministro = await repoBloqueoSuministro.getBloqueoSuministro(
        widget.selectedNIS!.nisRad.toString(),
        _isSwitched ? 1 : 2,
        widget.token!,
      );
    } catch (e) {
      debugPrint("Error en _fetchBloqueoSuministro: $e");
      bloqueoSuministro = BloqueoSuministroResponse(
        error: true,
        mensaje: "Ocurrió un error al comunicarse con el servidor",
        mensajeList: [],
        errorValList: [],
        resultado: null,
      );
    } finally {
      setState(() {
        _isLoadingBloqueoSuministro = false; // ← ocultar spinner
      });
    }

    return bloqueoSuministro;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get the full screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Bloquear Suministro ${_isSwitched}",
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // 👈 centra verticalmente
              children: [
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,

                    "Con el bloqueo del suministro no se podrán consultar ni descargar las facturas desde el acceso público en la Página Web ni desde la APP de la ANDE",
                  ),
                ),
                SizedBox(width: 20),
                Switch(
                  value: _isSwitched,
                  onChanged: (newValue) {
                    setState(() {
                      _isSwitched = newValue;
                    });
                    bloquearDesloquearSuministro(authState.value!);
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
