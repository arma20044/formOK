class EliminarCuentaResponse {
  final String? mensaje;
  final bool? error;
  final String? tokenerror;
  final bool? errorValidacion;
  final List<dynamic>? errorValList;

  EliminarCuentaResponse({
    this.mensaje,
    this.error,
    this.tokenerror,
    this.errorValidacion,
    this.errorValList,
  });

  factory EliminarCuentaResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return EliminarCuentaResponse(
      mensaje: json['mensaje'],
      error: json['error'],
      tokenerror: json['tokenerror'],
      errorValidacion: json['errorValidacion'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensaje': mensaje,
      'error': error,
      'tokenerror': tokenerror,
      'errorValidacion': errorValidacion,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

  EliminarCuentaResponse copyWith({
    String? mensaje,
    bool? error,
    String? tokenerror,
    bool? errorValidacion,
    List<dynamic>? errorValList,
  }) {
    return EliminarCuentaResponse(
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      tokenerror: tokenerror ?? this.tokenerror,
      errorValidacion: errorValidacion ?? this.errorValidacion,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}
