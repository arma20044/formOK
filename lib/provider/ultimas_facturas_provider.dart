// lib/provider/facturas_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/mi_cuenta/mi_cuenta_ultimas_facturas_datasource_impl.dart';
import 'package:form/model/mi_cuenta/mi_cuenta_ultimas_facturas_model.dart';
import 'package:form/repositories/mi_cuenta/mi_cuenta_ultimas_facturas_repository_impl.dart';
import 'suministro_provider.dart';

final facturasProvider =
    FutureProvider.autoDispose<List<MiCuentaUltimasFacturasLista>>((ref) async {
  final nis = ref.watch(selectedNISProvider);
  if (nis == null) return [];

  final authState = ref.watch(authProvider);
  final token = authState.value?.user?.token;

  final repo = MiCuentaUltimasFacturasRepositoryImpl(
    MiCuentaUltimasFacturasDatasourceImpl(MiAndeApi()),
  );

  final response = await repo.getMiCuentaUltimasFacturas(
    nis.nisRad!.toString(),
    "15",
    token ?? "",
  );

  if (response.error == true) {
    throw Exception(response.errorValList?.first ?? 'Error desconocido');
  }

  final data = response.micuentaultimasfacturasresultado?.lista ?? [];
  return data.whereType<MiCuentaUltimasFacturasLista>().toList();
});
