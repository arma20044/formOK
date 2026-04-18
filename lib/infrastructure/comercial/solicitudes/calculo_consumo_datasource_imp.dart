import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class CalculoConsumoDatasourceImp extends CalculoConsumoDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  CalculoConsumoDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<CalculoConsumoResponse> getCalculoConsumo(
    String nis,
    String? lecturaActual,
    String? tension,
    String? lecturaActualActiva,
    String? lecturaActualReactiva,
    String? lecturaActualPotencia,
  ) async {
    late Map<String, Object> formMap;
    if (tension!.contains('BT')) {
      formMap = {
        'nis': nis,
        'lecturaActual': lecturaActual!,
        'clientKey': environment.clientKey,
      };
    } else {
      formMap = {
        'nis': nis,
        'lecturaActualActiva': lecturaActualActiva!,
        'lecturaActualReactiva': lecturaActualReactiva!,
        'lecturaActualPotencia': lecturaActualPotencia!,
        'clientKey': environment.clientKey,
      };
    }

    // Crear FormData
    final data = FormData.fromMap(formMap);

    String urlFinal = tension!.contains("BT")
        ? "${environment.hostCtxOpen}/v4/suministro/calcularConsumo"
        : "${environment.hostCtxOpen}/v4/suministro/calcularConsumoMT";

    final response = await dio.post(
      urlFinal,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    //debugPrint('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      // Dio ya devuelve un Map
      final Map<String, dynamic> jsonData =
          response.data as Map<String, dynamic>;

      // Convierte todo a tu modelo
      final historico = CalculoConsumoResponse.fromJson(jsonData);

      return historico;
    } else {
      throw Exception('Error ${response.statusCode}');
    }

    /*if (response.statusCode == 200) {
    print('Datos: ${response.data}');
  } else {
    print('Error ${response.statusCode}: ${response.data}');
  }*/
  }
}
