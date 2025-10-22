class CambioContrasenhaResponse {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  CambioContrasenhaResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory CambioContrasenhaResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CambioContrasenhaResponse(
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado,
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

  CambioContrasenhaResponse copyWith({
    required dynamic resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return CambioContrasenhaResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}
