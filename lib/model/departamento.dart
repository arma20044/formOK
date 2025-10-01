class DepartamentoResult {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final _Respuesta? respuesta;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  DepartamentoResult({
    this.resultado,
    this.mensajeList,
    this.respuesta,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory DepartamentoResult.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DepartamentoResult(
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      respuesta: json['respuesta'] != null ? _Respuesta.fromJson(json['respuesta']) : null,
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

class _Respuesta {
  final dynamic pagina;
  final dynamic totalPaginas;
  final dynamic totalDepartamento;
  final List<Departamento?>? datos;

  _Respuesta({
    this.pagina,
    this.totalPaginas,
    this.totalDepartamento,
    this.datos,
  });

  factory _Respuesta.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return _Respuesta(
      pagina: json['pagina'],
      totalPaginas: json['totalPaginas'],
      totalDepartamento: json['totalDepartamento'],
       datos: json['datos'] != null ? List<Departamento>.from(json['datos'].map((item) => Departamento.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagina': pagina,
      'totalPaginas': totalPaginas,
      'totalDepartamento': totalDepartamento,
      'datos': datos?.map((item) => item?.toJson()).toList(),
    };
  }

}

class Departamento {
  final num idDepartamento;
  final String? nombre;
  final String? activo;

  Departamento({
    required this.idDepartamento,
    this.nombre,
    this.activo,
  });

  factory Departamento.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Departamento(
      idDepartamento: json['idDepartamento'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDepartamento': idDepartamento,
      'nombre': nombre,
      'activo': activo,
    };
  }

}
