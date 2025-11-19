import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/infrastructure/infrastructure.dart';
import '../core/auth/auth_notifier.dart';
import '../repositories/repositories.dart';
import '../model/model.dart';
import 'suministro_provider.dart';


// FutureProvider que recibe el idHistorico
final recuperarHistoricoProvider =
    FutureProvider.autoDispose.family<RecuperarHistorico, String>((ref, idHistorico) async {

  final nis = ref.watch(selectedNISProvider);
  if (nis == null) throw "No se encontró el NIS seleccionado.";

  final authState = ref.watch(authProvider);
  final token = authState.value?.user?.token;
  if (token == null) throw "Usuario no autenticado";

  final repo = RecuperarHistoricoRepositoryImpl(
    RecuperarHistoricoDatasourceImpl(MiAndeApi()),
  );

  try {
    final response = await repo.getRecuperarHistorico(idHistorico, token);

    // Backend puede devolver error
    if (response.error) {
      throw response.errorValList?.first ?? response.mensaje ?? "Error desconocido";
    }

    return response;

  } on DioException catch (e) {
    // Si el interceptor de Dio ya transformó el error, usamos e.error
    if (e.error != null && e.error is String && e.error.toString().isNotEmpty) {
      throw e.error.toString();
    }

    // Fallback
    throw "Error de conexión con el servidor";
  } catch (e) {
    throw e.toString();
  }
});
