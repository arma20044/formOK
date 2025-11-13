class RegistroNumeroCelularResponse {
  final bool error;
  final bool? errorValidacion;
  final List<String?>? errorValList;
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;

  RegistroNumeroCelularResponse({
    required this.error,
    this.errorValidacion,
    this.errorValList,
    this.resultado,
    this.mensajeList,
    this.mensaje,
  });

  factory RegistroNumeroCelularResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return RegistroNumeroCelularResponse(
      error: json['error'],
      errorValidacion: json['errorValidacion'],
       errorValList: json['errorValList'] != null ? List<String>.from(json['errorValList'].map((item) => item)) : null,
      resultado: json['resultado'],
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorValidacion': errorValidacion,
      'errorValList': errorValList?.map((item) => item).toList(),
      'resultado': resultado,
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
    };
  }

  RegistroNumeroCelularResponse copyWith({
    bool? error,
    bool? errorValidacion,
    List<String?>? errorValList,
    required dynamic resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
  }) {
    return RegistroNumeroCelularResponse(
      error: error ?? this.error,
      errorValidacion: errorValidacion ?? this.errorValidacion,
      errorValList: errorValList ?? this.errorValList,
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}
