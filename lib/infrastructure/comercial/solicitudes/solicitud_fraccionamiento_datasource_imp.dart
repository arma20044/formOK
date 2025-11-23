import 'package:dio/dio.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/datasources/datasources.dart';
import 'package:form/model/model.dart';

class SolicitudFraccionamientoDatasourceImp
    extends SolicitudFraccionamientoDatasource {
  late final Dio dio;

  //   OlicitudAbastecimiento(MiAndeApi api) : dio = api.dio;

  SolicitudFraccionamientoDatasourceImp(MiAndeApi api) : dio = api.dio;

  @override
  Future<SolicitudFraccionamientoResponse> getSolicitudFraccionamiento(
    String nis,
    String conCuenta,
    String cantidadCuotas,
    String entrega,
    String deuda,
    String tieneInteres,
    String tieneMultas,
    String simular,
    String token
  ) async {
    final Map<String, Object> formMap = {
      'nis': nis,
      'conCuenta':conCuenta,
      'cantidadCuotas':cantidadCuotas,      
      'entrega':entrega,
      'deuda':deuda,
      'tieneInteres':tieneInteres,
      'tieneMultas':tieneMultas,
      'simular':simular,
      'clientKey': Environment.clientKey,
      'kwfxtoken': token
    };

    // Crear FormData
    final data = FormData.fromMap(formMap);

    final response = await dio.post(
      "${Environment.hostCtxOpen}/v6/acuerdos/simular",
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // 👈 importante
      ),
    );

    print('URL llamada: ${response.requestOptions.uri}');

    if (response.statusCode == 200) {
      // Dio ya devuelve un Map
      final Map<String, dynamic> jsonData =
          response.data as Map<String, dynamic>;

      // Convierte todo a tu modelo
      final historico = SolicitudFraccionamientoResponse.fromJson(jsonData);

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
