class HistoricoConsumoMonto {
  final ResultadoHistoricoConsumoMonto resultado;
  final List<dynamic> mensajeList;
  final String mensaje;
  final bool error;
  final List<dynamic> errorValList;

  HistoricoConsumoMonto({
    required this.resultado,
    required this.mensajeList,
    required this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory HistoricoConsumoMonto.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return HistoricoConsumoMonto(
      resultado: ResultadoHistoricoConsumoMonto.fromJson(json['resultado']),
      mensajeList:List<dynamic>.from(json['mensajeList'].map((item) => item)) ,
      mensaje: json['mensaje'],
      error: json['error'],
      errorValList:  List<dynamic>.from(json['errorValList'].map((item) => item)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado.toJson(),
      'mensajeList': mensajeList.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList.map((item) => item).toList(),
    };
  }

  HistoricoConsumoMonto copyWith({
    ResultadoHistoricoConsumoMonto? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return HistoricoConsumoMonto(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class ResultadoHistoricoConsumoMonto {
  final String id;

  ResultadoHistoricoConsumoMonto({required this.id});

  factory ResultadoHistoricoConsumoMonto.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ResultadoHistoricoConsumoMonto(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  ResultadoHistoricoConsumoMonto copyWith({String? id}) {
    return ResultadoHistoricoConsumoMonto(id: id ?? this.id);
  }
}
