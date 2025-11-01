class ServiciosNisTelefonoResponse {
  final ResultadoServiciosNisTelefono? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  ServiciosNisTelefonoResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory ServiciosNisTelefonoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ServiciosNisTelefonoResponse(
      resultado: json['resultado'] != null ? ResultadoServiciosNisTelefono.fromJson(json['resultado']) : null,
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado?.toJson(),
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

  ServiciosNisTelefonoResponse copyWith({
    ResultadoServiciosNisTelefono? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return ServiciosNisTelefonoResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class ResultadoServiciosNisTelefono {
  final List<ListaServiciosNisTelefono?>? lista;
  final ListaCodigoServicio? listaCodigoServicio;

  ResultadoServiciosNisTelefono({
    this.lista,
    this.listaCodigoServicio,
  });

  factory ResultadoServiciosNisTelefono.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ResultadoServiciosNisTelefono(
       lista: json['lista'] != null ? List<ListaServiciosNisTelefono>.from(json['lista'].map((item) => ListaServiciosNisTelefono.fromJson(item))) : null,
      listaCodigoServicio: json['listaCodigoServicio'] != null ? ListaCodigoServicio.fromJson(json['listaCodigoServicio']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lista': lista?.map((item) => item?.toJson()).toList(),
      'listaCodigoServicio': listaCodigoServicio?.toJson(),
    };
  }

  ResultadoServiciosNisTelefono copyWith({
    List<ListaServiciosNisTelefono?>? lista,
    ListaCodigoServicio? listaCodigoServicio,
  }) {
    return ResultadoServiciosNisTelefono(
      lista: lista ?? this.lista,
      listaCodigoServicio: listaCodigoServicio ?? this.listaCodigoServicio,
    );
  }
}

class ListaCodigoServicio {
  final String? cS010;
  final String? cS006;
  final String? cS007;
  final String? cS004;
  final String? cS005;
  final String? cS002;
  final String? cS013;
  final String? cS003;
  final String? cS011;
  final String? cS001;
  final String? cS012;
  final String? cS008;
  final String? cS009;

  ListaCodigoServicio({
    this.cS010,
    this.cS006,
    this.cS007,
    this.cS004,
    this.cS005,
    this.cS002,
    this.cS013,
    this.cS003,
    this.cS011,
    this.cS001,
    this.cS012,
    this.cS008,
    this.cS009,
  });

  factory ListaCodigoServicio.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ListaCodigoServicio(
      cS010: json['CS010'],
      cS006: json['CS006'],
      cS007: json['CS007'],
      cS004: json['CS004'],
      cS005: json['CS005'],
      cS002: json['CS002'],
      cS013: json['CS013'],
      cS003: json['CS003'],
      cS011: json['CS011'],
      cS001: json['CS001'],
      cS012: json['CS012'],
      cS008: json['CS008'],
      cS009: json['CS009'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CS010': cS010,
      'CS006': cS006,
      'CS007': cS007,
      'CS004': cS004,
      'CS005': cS005,
      'CS002': cS002,
      'CS013': cS013,
      'CS003': cS003,
      'CS011': cS011,
      'CS001': cS001,
      'CS012': cS012,
      'CS008': cS008,
      'CS009': cS009,
    };
  }

  ListaCodigoServicio copyWith({
    String? cS010,
    String? cS006,
    String? cS007,
    String? cS004,
    String? cS005,
    String? cS002,
    String? cS013,
    String? cS003,
    String? cS011,
    String? cS001,
    String? cS012,
    String? cS008,
    String? cS009,
  }) {
    return ListaCodigoServicio(
      cS010: cS010 ?? this.cS010,
      cS006: cS006 ?? this.cS006,
      cS007: cS007 ?? this.cS007,
      cS004: cS004 ?? this.cS004,
      cS005: cS005 ?? this.cS005,
      cS002: cS002 ?? this.cS002,
      cS013: cS013 ?? this.cS013,
      cS003: cS003 ?? this.cS003,
      cS011: cS011 ?? this.cS011,
      cS001: cS001 ?? this.cS001,
      cS012: cS012 ?? this.cS012,
      cS008: cS008 ?? this.cS008,
      cS009: cS009 ?? this.cS009,
    );
  }
}

class ListaServiciosNisTelefono {
  final String? codigoServicio;
  final String? estado;
  final num? numeroMovil;

  ListaServiciosNisTelefono({
    this.codigoServicio,
    this.estado,
    this.numeroMovil,
  });

  factory ListaServiciosNisTelefono.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ListaServiciosNisTelefono(
      codigoServicio: json['codigoServicio'],
      estado: json['estado'],
      numeroMovil: json['numeroMovil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoServicio': codigoServicio,
      'estado': estado,
      'numeroMovil': numeroMovil,
    };
  }

  ListaServiciosNisTelefono copyWith({
    String? codigoServicio,
    String? estado,
    num? numeroMovil,
  }) {
    return ListaServiciosNisTelefono(
      codigoServicio: codigoServicio ?? this.codigoServicio,
      estado: estado ?? this.estado,
      numeroMovil: numeroMovil ?? this.numeroMovil,
    );
  }
}
