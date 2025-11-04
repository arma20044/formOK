// lib/provider/facturas_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';

import '../infrastructure/infrastructure.dart';
import '../model/model.dart';
import '../repositories/repositories.dart';
import 'suministro_provider.dart';

final historicoConsumoMontoProvider = FutureProvider.autoDispose<HistoricoConsumoMonto>((
  ref,
) async {
  final nis = ref.watch(selectedNISProvider);
  if (nis == null) Exception("NO LLEGO NIS");

  final authState = ref.watch(authProvider);
  final token = authState.value?.user?.token;

  final repo = HistoricoConsumoMontoRepositoryImpl(
    HistoricoConsumoMontoDatasourceImpl(MiAndeApi()),
  );

  final response = await repo.getHistoricoConsumoMonto(
    nis!.nisRad!.toString(),
    "N",
    token ?? "",
  );

  if (response.error!) {
    throw Exception(response.errorValList![0] ?? 'Error desconocido');
  }

  final data = response;
  return data;
});
