import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/model.dart';
import 'package:form/provider/suministro_provider.dart';

import '../infrastructure/infrastructure.dart';
import '../repositories/repositories.dart';

final situacionActualProvider =
    FutureProvider.autoDispose<SituacionActualResultado>((ref) async {
      final nis = ref.watch(selectedNISProvider);
      if (nis == null) {
        throw Exception('No hay NIS seleccionado');
      }

      final authState = ref.watch(authProvider);
      final token = authState.value?.user?.token ?? '';

      final repo = MiCuentaSituacionActualRepositoryImpl(
        MiCuentaSituacionActualDatasourceImpl(MiAndeApi()),
      );

      final response = await repo.getMiCuentaSituacionActual(
        nis.nisRad!.toString(),
        token,
      );

      if (response.error == true) {
        throw Exception(response.errorValList?.first ?? 'Error desconocido');
      }

      final data = response.resultado;
      if (data == null) {
        throw Exception('No se obtuvo información de la situación actual');
      }

      return data;
    });
