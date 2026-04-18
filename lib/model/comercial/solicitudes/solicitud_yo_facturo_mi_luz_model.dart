class SolicitudYoFacturoMiLuzResponse {
  final YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado? resultado;
  final bool? error;
  final bool? errorValidacion;
  final List<String?>? errorValList;
  final String? mensaje;

  SolicitudYoFacturoMiLuzResponse({
    this.resultado,
    this.error,
    this.errorValidacion,
    this.errorValList,
    this.mensaje,
  });

  factory SolicitudYoFacturoMiLuzResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SolicitudYoFacturoMiLuzResponse(
      resultado: json['resultado'] != null
          ? YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado.fromJson(
              json['resultado'],
            )
          : null,
      error: json['error'],
      errorValidacion: json['errorValidacion'],
      errorValList: json['errorValList'] != null
          ? List<String>.from(json['errorValList'].map((item) => item))
          : null,
      mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado?.toJson(),
      'error': error,
      'errorValidacion': errorValidacion,
      'errorValList': errorValList?.map((item) => item).toList(),
      'mensaje': mensaje,
    };
  }

  SolicitudYoFacturoMiLuzResponse copyWith({
    YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado? resultado,
    bool? error,
    bool? errorValidacion,
    List<String?>? errorValList,
    String? mensaje,
  }) {
    return SolicitudYoFacturoMiLuzResponse(
      resultado: resultado ?? this.resultado,
      error: error ?? this.error,
      errorValidacion: errorValidacion ?? this.errorValidacion,
      errorValList: errorValList ?? this.errorValList,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

class YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado {
  final String? confirmarConMultimedia;

  YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado({this.confirmarConMultimedia});

  factory YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado.fromJson(
    Map<String, dynamic>? json,
  ) {
    json ??= {};
    return YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado(
      confirmarConMultimedia: json['confirmarConMultimedia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'confirmarConMultimedia': confirmarConMultimedia};
  }

  YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado copyWith({
    String? confirmarConMultimedia
  }) {
    return YoFacturoMiLuzSolicitudYoFacturoMiLuzResultado(
      confirmarConMultimedia:
          confirmarConMultimedia ?? this.confirmarConMultimedia,
    );
  }
}
