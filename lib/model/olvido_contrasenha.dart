class OlvidoContrasenhaResponse {
  final dynamic resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool error;
  final List<dynamic>? errorValList;

  OlvidoContrasenhaResponse({
    this.resultado,
    required this.mensajeList,
    this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory OlvidoContrasenhaResponse.fromJson(Map<String, dynamic> json) {
    final bool esError = json['error'] ?? false;

    if (esError) {
      // 🔴 Caso de error
      return OlvidoContrasenhaResponse(
        resultado: null,
        mensajeList: [],
        mensaje: json['mensaje'] ?? 'Error en validación',
        error: true,
        errorValList: List<dynamic>.from(json['errorValList'] ?? []),
      );
    } else {
      // 🟢 Caso sin error
      return OlvidoContrasenhaResponse(
        resultado: json['resultado'],
        mensajeList: List<String>.from(json['mensajeList'] ?? []),
        mensaje: json['mensaje'],
        error: false,
        errorValList: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    if (error) {
      // 🔴 Caso error
      return {'error': error, 'mensaje': mensaje, 'errorValList': errorValList};
    } else {
      // 🟢 Caso sin error
      return {
        'resultado': resultado,
        'error': error,
        'mensajeList': mensajeList,
      };
    }
  }

  OlvidoContrasenhaResponse copyWith({
    dynamic resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    required bool error,
    List<dynamic>? errorValList,
  }) {
    return OlvidoContrasenhaResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}
