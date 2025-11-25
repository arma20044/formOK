class SolicitarFraccionamientoResponse {
  final bool? error;
  final String? tokenError;
  final bool? errorValidacion;
  final String? mensaje;
  final List<String?>? errorValList;

  SolicitarFraccionamientoResponse({
    this.error,
    this.tokenError,
    this.errorValidacion,
    this.mensaje,
    this.errorValList,
  });

  factory SolicitarFraccionamientoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SolicitarFraccionamientoResponse(
      error: json['error'],
      tokenError: json['tokenError'],
      errorValidacion: json['errorValidacion'],
      mensaje: json['mensaje'],
       errorValList: json['errorValList'] != null ? List<String>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'tokenError': tokenError,
      'errorValidacion': errorValidacion,
      'mensaje': mensaje,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

  SolicitarFraccionamientoResponse copyWith({
    bool? error,
    String? tokenError,
    bool? errorValidacion,
    String? mensaje,
    List<String?>? errorValList,
  }) {
    return SolicitarFraccionamientoResponse(
      error: error ?? this.error,
      tokenError: tokenError ?? this.tokenError,
      errorValidacion: errorValidacion ?? this.errorValidacion,
      mensaje: mensaje ?? this.mensaje,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}
