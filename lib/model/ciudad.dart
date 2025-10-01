

class CiudadResponse {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final CiudadRespuesta? respuesta;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  CiudadResponse({
    this.resultado,
    this.mensajeList,
    this.respuesta,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory CiudadResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CiudadResponse(
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      respuesta: json['respuesta'] != null ? CiudadRespuesta.fromJson(json['respuesta']) : null,
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado,
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'respuesta': respuesta?.toJson(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

}

class CiudadRespuesta {
  final dynamic pagina;
  final dynamic totalPaginas;
  final dynamic totalCiudad;
  final List<Ciudad?>? datos;

  CiudadRespuesta({
    this.pagina,
    this.totalPaginas,
    this.totalCiudad,
    this.datos,
  });

  factory CiudadRespuesta.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CiudadRespuesta(
      pagina: json['pagina'],
      totalPaginas: json['totalPaginas'],
      totalCiudad: json['totalCiudad'],
       datos: json['datos'] != null ? List<Ciudad>.from(json['datos'].map((item) => Ciudad.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagina': pagina,
      'totalPaginas': totalPaginas,
      'totalCiudad': totalCiudad,
      'datos': datos?.map((item) => item?.toJson()).toList(),
    };
  }

}

class Ciudad {
  final String? nombre;
  final num idCiudad;
  final dynamic observacion;
  final String? activo;

  Ciudad({
    this.nombre,
    required this.idCiudad,
    this.observacion,
    this.activo,
  });

  factory Ciudad.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Ciudad(
      nombre: json['nombre'],
      idCiudad: json['idCiudad'],
      observacion: json['observacion'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'idCiudad': idCiudad,
      'observacion': observacion,
      'activo': activo,
    };
  }

}
