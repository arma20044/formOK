
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state_data.dart';
import 'package:form/model/login_model.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
    


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

  // Copia local del NIS seleccionado para actualizar el valor visual
  SuministrosList? _localSelectedNIS;

  @override
  void initState() {
    super.initState();
    _localSelectedNIS = widget.selectedNIS;
  }

  /// Llama al backend para bloquear/desbloquear
  Future<BloqueoSuministroResponse> _fetchBloqueoSuministro(
    AuthStateData authStateData,
    bool newValue,
  ) async {
    try {
      setState(() => _isLoadingBloqueoSuministro = true);

      return await repoBloqueoSuministro.getBloqueoSuministro(
        _localSelectedNIS!.nisRad.toString(),
        newValue ? 1 : 2,
        widget.token!,
      );
    } catch (e) {
      debugPrint("Error en _fetchBloqueoSuministro: $e");
      CustomSnackbar.show(
        context,
        message: "No se pudo comunicar con el servidor. Intente más tarde.",
        type: MessageType.error,
      );
      return BloqueoSuministroResponse(
        error: true,
        mensaje: "Error al comunicarse con el servidor",
        mensajeList: [],
        errorValList: [],
        resultado: null,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingBloqueoSuministro = false);
      }
    }
  }

  /// Bloquea o desbloquea el suministro
  Future<void> bloquearDesloquearSuministro(
    AuthStateData authStateData,
    bool newValue,
  ) async {
    final result = await _fetchBloqueoSuministro(authStateData, newValue);
    if (!mounted) return;

    if (result.error) {
      CustomSnackbar.show(
        context,
        message: result.mensaje,
        type: MessageType.error,
      );
      return;
    }

    // Éxito → actualiza el local y muestra mensaje
    setState(() {
      _localSelectedNIS = _localSelectedNIS?.copyWith(
        indicadorBloqueoWeb: newValue ? 1 : 2,
      );
    });

    CustomSnackbar.show(context, message: result.mensaje);

    // Actualiza el estado global (si lo necesitás para otros tabs)
    await ref
        .read(authProvider.notifier)
        .actualizarBloqueoWeb(nis: _localSelectedNIS!.nisRad!, valor: newValue);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authState = ref.watch(authProvider);
    final isSwitched = _localSelectedNIS?.indicadorBloqueoWeb == 1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Bloquear Suministro: ${isSwitched ? 'Sí' : 'No'}",
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Con el bloqueo del suministro no se podrán consultar ni descargar las facturas desde el acceso público en la Página Web ni desde la APP de la ANDE.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(width: 20),
                _isLoadingBloqueoSuministro
                    ? const CircularProgressIndicator()
                    : Switch(
                        value: isSwitched ?? false,
                        onChanged: (newValue) async {
                          await bloquearDesloquearSuministro(
                              authState.value!, newValue);
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
