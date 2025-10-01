class ReclamoResponse {
  final Reclamo? reclamo;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool error;
  final List<dynamic>? errorValList;

  ReclamoResponse({
    this.reclamo,
    this.mensajeList,
    this.mensaje,
    required this.error,
    this.errorValList,
  });

  factory ReclamoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ReclamoResponse(
      reclamo: json['resultado'] != null ? Reclamo.fromJson(json['resultado']) : null,
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': reclamo?.toJson(),
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

}

class Reclamo {
  final num? idCentroAtencion;
  final String? numeroReclamo;

  Reclamo({
    this.idCentroAtencion,
    this.numeroReclamo,
  });

  factory Reclamo.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Reclamo(
      idCentroAtencion: json['idCentroAtencion'],
      numeroReclamo: json['numeroReclamo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCentroAtencion': idCentroAtencion,
      'numeroReclamo': numeroReclamo,
    };
  }

}
