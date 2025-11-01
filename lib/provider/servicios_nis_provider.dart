// number_list_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/model/login_model.dart';
import 'package:form/utils/utils.dart';

import '../infrastructure/infrastructure.dart';
import '../model/constans/constants_model.dart';
import '../repositories/repositories.dart';

// AsyncNotifier para manejar la lista de números
class NumberListAsyncNotifier extends AsyncNotifier<List<NumberItem>> {
  late final SuministrosList selectedNIS;
  late final String token;

  @override
  Future<List<NumberItem>> build() async {
    // Se ejecuta automáticamente al usar el provider por primera vez
    return fetchNumbers(selectedNIS, token);
  }

  // Método público para fetch / refresh de números
  Future<List<NumberItem>> fetchNumbers(
  SuministrosList selectedNIS,
  String token,
) async {
  state = const AsyncLoading(); // marca loading

  try {
    final repoServiciosNis = ServiciosNisRepositoryImpl(
      ServiciosNisDatasourceImpl(MiAndeApi()),
    );

    // Llamada al repositorio con NIS y token
    final serviciosNisResponse = await repoServiciosNis.getServiciosNis(
      selectedNIS.nisRad.toString(),
      token,
    );

    if (serviciosNisResponse != null && serviciosNisResponse.resultado != null) {
      // Procesamos la respuesta usando processServiciosClase
      final numbers = processServiciosClase(serviciosNisResponse.resultado!);

      // Actualizamos el state con los datos obtenidos
      state = AsyncData(numbers);
      return numbers;
    } else {
      // No se recibió resultado
      state = AsyncError('No se recibió resultado', StackTrace.current);
      return [];
    }
  } catch (e, st) {
    // Capturamos cualquier error de la llamada al API
    state = AsyncError(e, st);
    return [];
  }
}


  // Cambiar el estado de un switch
  void toggleService(int number, String serviceName, bool value) {
    final current = state.value;
    if (current == null) return;

    final updated = current.map((item) {
      if (item.number == number) {
        for (var s in item.services) {
          if (s.name == serviceName) s.isSelected = value;
        }
      }
      return item;
    }).toList();

    state = AsyncData(updated);
  }

  // Eliminar un número
  void deleteNumber(int number) {
    final current = state.value;
    if (current == null) return;

    final updated = current.where((item) => item.number != number).toList();
    state = AsyncData(updated);
  }

  // Agregar un nuevo número
  void addNumber(NumberItem item) {
    final current = state.value;
    if (current == null) return;

    final updated = [...current, item];
    state = AsyncData(updated);
  }
}

// Provider de Riverpod 3 usando AsyncNotifier
final numberListAsyncProvider =
    AsyncNotifierProvider<NumberListAsyncNotifier, List<NumberItem>>(
      () => NumberListAsyncNotifier(),
    );
