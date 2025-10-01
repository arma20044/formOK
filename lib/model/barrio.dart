class BarrioResponse {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final Respuesta? respuesta;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  BarrioResponse({
    this.resultado,
    this.mensajeList,
    this.respuesta,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory BarrioResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BarrioResponse(
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      respuesta: json['respuesta'] != null ? Respuesta.fromJson(json['respuesta']) : null,
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

class Respuesta {
  final dynamic pagina;
  final dynamic totalPaginas;
  final dynamic totalBarrio;
  final List<Barrio?>? datos;

  Respuesta({
    this.pagina,
    this.totalPaginas,
    this.totalBarrio,
    this.datos,
  });

  factory Respuesta.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Respuesta(
      pagina: json['pagina'],
      totalPaginas: json['totalPaginas'],
      totalBarrio: json['totalBarrio'],
       datos: json['datos'] != null ? List<Barrio>.from(json['datos'].map((item) => Barrio.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagina': pagina,
      'totalPaginas': totalPaginas,
      'totalBarrio': totalBarrio,
      'datos': datos?.map((item) => item?.toJson()).toList(),
    };
  }

}

class Barrio {
  final num idBarrio;
  final String? nombre;
  final dynamic observacion;
  final String? activo;

  Barrio({
    required this.idBarrio,
    this.nombre,
    this.observacion,
    this.activo,
  });

  factory Barrio.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Barrio(
      idBarrio: json['idBarrio'],
      nombre: json['nombre'],
      observacion: json['observacion'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBarrio': idBarrio,
      'nombre': nombre,
      'observacion': observacion,
      'activo': activo,
    };
  }

}
