class ReclamoRecuperadoResponse {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final RespuestaReclamoRecuperado? respuesta;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  ReclamoRecuperadoResponse({
    this.resultado,
    this.mensajeList,
    this.respuesta,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory ReclamoRecuperadoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ReclamoRecuperadoResponse(
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      respuesta: json['respuesta'] != null ? RespuestaReclamoRecuperado.fromJson(json['respuesta']) : null,
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

  ReclamoRecuperadoResponse copyWith({
    required dynamic resultado,
    List<dynamic>? mensajeList,
    RespuestaReclamoRecuperado? respuesta,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return ReclamoRecuperadoResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      respuesta: respuesta ?? this.respuesta,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class RespuestaReclamoRecuperado {
  final String? pagina;
  final String? totalPaginas;
  final String? totalDatos;
  final List<Datos?>? datos;

  RespuestaReclamoRecuperado({
    this.pagina,
    this.totalPaginas,
    this.totalDatos,
    this.datos,
  });

  factory RespuestaReclamoRecuperado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return RespuestaReclamoRecuperado(
      pagina: json['pagina'],
      totalPaginas: json['totalPaginas'],
      totalDatos: json['totalDatos'],
       datos: json['datos'] != null ? List<Datos>.from(json['datos'].map((item) => Datos.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagina': pagina,
      'totalPaginas': totalPaginas,
      'totalDatos': totalDatos,
      'datos': datos?.map((item) => item?.toJson()).toList(),
    };
  }

  RespuestaReclamoRecuperado copyWith({
    String? pagina,
    String? totalPaginas,
    String? totalDatos,
    List<Datos?>? datos,
  }) {
    return RespuestaReclamoRecuperado(
      pagina: pagina ?? this.pagina,
      totalPaginas: totalPaginas ?? this.totalPaginas,
      totalDatos: totalDatos ?? this.totalDatos,
      datos: datos ?? this.datos,
    );
  }
}

class Datos {
  final num? departamentoIdDepartamento;
  final dynamic latitud;
  final String? nombreApellido;
  final String? direccion;
  final num? idReclamo;
  final String? barrioNombre;
  final num? barrioIdBarrio;
  final num? ciudadIdCiudad;
  final dynamic longitud;
  final String? departamentoNombre;
  final dynamic correo;
  final num? nis;
  final String? numeroReclamo;
  final String? ciudadNombre;
  final String? telefono;
  final String? referencia;
  final dynamic observacion;

  Datos({
    this.departamentoIdDepartamento,
    this.latitud,
    this.nombreApellido,
    this.direccion,
    this.idReclamo,
    this.barrioNombre,
    this.barrioIdBarrio,
    this.ciudadIdCiudad,
    this.longitud,
    this.departamentoNombre,
    this.correo,
    this.nis,
    this.numeroReclamo,
    this.ciudadNombre,
    this.telefono,
    this.referencia,
    this.observacion,
  });

  factory Datos.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Datos(
      departamentoIdDepartamento: json['departamento\u002eidDepartamento'],
      latitud: json['latitud'],
      nombreApellido: json['nombreApellido'],
      direccion: json['direccion'],
      idReclamo: json['idReclamo'],
      barrioNombre: json['barrio\u002enombre'],
      barrioIdBarrio: json['barrio\u002eidBarrio'],
      ciudadIdCiudad: json['ciudad\u002eidCiudad'],
      longitud: json['longitud'],
      departamentoNombre: json['departamento\u002enombre'],
      correo: json['correo'],
      nis: json['nis'],
      numeroReclamo: json['numeroReclamo'],
      ciudadNombre: json['ciudad\u002enombre'],
      telefono: json['telefono'],
      referencia: json['referencia'],
      observacion: json['observacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departamento\u002eidDepartamento': departamentoIdDepartamento,
      'latitud': latitud,
      'nombreApellido': nombreApellido,
      'direccion': direccion,
      'idReclamo': idReclamo,
      'barrio\u002enombre': barrioNombre,
      'barrio\u002eidBarrio': barrioIdBarrio,
      'ciudad\u002eidCiudad': ciudadIdCiudad,
      'longitud': longitud,
      'departamento\u002enombre': departamentoNombre,
      'correo': correo,
      'nis': nis,
      'numeroReclamo': numeroReclamo,
      'ciudad\u002enombre': ciudadNombre,
      'telefono': telefono,
      'referencia': referencia,
      'observacion': observacion,
    };
  }

  Datos copyWith({
    num? departamentoIdDepartamento,
    required dynamic latitud,
    String? nombreApellido,
    String? direccion,
    num? idReclamo,
    String? barrioNombre,
    num? barrioIdBarrio,
    num? ciudadIdCiudad,
    required dynamic longitud,
    String? departamentoNombre,
    required dynamic correo,
    num? nis,
    String? numeroReclamo,
    String? ciudadNombre,
    String? telefono,
    String? referencia,
    required dynamic observacion,
  }) {
    return Datos(
      departamentoIdDepartamento: departamentoIdDepartamento ?? this.departamentoIdDepartamento,
      latitud: latitud ?? this.latitud,
      nombreApellido: nombreApellido ?? this.nombreApellido,
      direccion: direccion ?? this.direccion,
      idReclamo: idReclamo ?? this.idReclamo,
      barrioNombre: barrioNombre ?? this.barrioNombre,
      barrioIdBarrio: barrioIdBarrio ?? this.barrioIdBarrio,
      ciudadIdCiudad: ciudadIdCiudad ?? this.ciudadIdCiudad,
      longitud: longitud ?? this.longitud,
      departamentoNombre: departamentoNombre ?? this.departamentoNombre,
      correo: correo ?? this.correo,
      nis: nis ?? this.nis,
      numeroReclamo: numeroReclamo ?? this.numeroReclamo,
      ciudadNombre: ciudadNombre ?? this.ciudadNombre,
      telefono: telefono ?? this.telefono,
      referencia: referencia ?? this.referencia,
      observacion: observacion ?? this.observacion,
    );
  }
}
