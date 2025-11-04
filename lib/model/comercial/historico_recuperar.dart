class RecuperarHistorico {
  final ResultadoRecuperarHistorico resultado;
  final List<dynamic> mensajeList;
  final String mensaje;
  final bool error;
  final List<dynamic> errorValList;

  RecuperarHistorico({
    required this.resultado,
    required this.mensajeList,
    required this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory RecuperarHistorico.fromJson(Map<String, dynamic> json) {
    return RecuperarHistorico(
      resultado: ResultadoRecuperarHistorico.fromJson(json['resultado']),
       mensajeList: List<dynamic>.from(json['mensajeList'].map((item) => item)),
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: List<dynamic>.from(json['errorValList'].map((item) => item)),
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

  RecuperarHistorico copyWith({
    required ResultadoRecuperarHistorico resultado,
    required List<dynamic> mensajeList,
    required String mensaje,
    required bool error,
    required List<dynamic> errorValList,
  }) {
    return RecuperarHistorico(
      resultado: resultado,
      mensajeList: mensajeList,
      mensaje: mensaje,
      error: error,
      errorValList: errorValList,
    );
  }
}

class ResultadoRecuperarHistorico {
  final List<ListaRecuperarHistorico> lista;

  ResultadoRecuperarHistorico({
    required this.lista,
  });

  factory ResultadoRecuperarHistorico.fromJson(Map<String, dynamic> json) {
    return ResultadoRecuperarHistorico(
       lista: List<ListaRecuperarHistorico>.from(json['lista'].map((item) => ListaRecuperarHistorico.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lista': lista.map((item) => item.toJson()).toList(),
    };
  }

  ResultadoRecuperarHistorico copyWith({
    required List<ListaRecuperarHistorico> lista,
  }) {
    return ResultadoRecuperarHistorico(
      lista: lista,
    );
  }
}

class ListaRecuperarHistorico {
  final String fechaFacturacion;
  final String fechaFacturacionMask;
  final num consumoFacturado;
  final num importeFacturado;
  final num nisRad;

  ListaRecuperarHistorico({
    required this.fechaFacturacion,
    required this.fechaFacturacionMask,
    required this.consumoFacturado,
    required this.importeFacturado,
    required this.nisRad,
  });

  factory ListaRecuperarHistorico.fromJson(Map<String, dynamic> json) {
    return ListaRecuperarHistorico(
      fechaFacturacion: json['fechaFacturacion'],
      fechaFacturacionMask: json['fechaFacturacionMask'],
      consumoFacturado: json['consumoFacturado'],
      importeFacturado: json['importeFacturado'],
      nisRad: json['nisRad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaFacturacion': fechaFacturacion,
      'fechaFacturacionMask': fechaFacturacionMask,
      'consumoFacturado': consumoFacturado,
      'importeFacturado': importeFacturado,
      'nisRad': nisRad,
    };
  }

  ListaRecuperarHistorico copyWith({
    required String fechaFacturacion,
    required String fechaFacturacionMask,
    required num consumoFacturado,
    required num importeFacturado,
    required num nisRad,
  }) {
    return ListaRecuperarHistorico(
      fechaFacturacion: fechaFacturacion,
      fechaFacturacionMask: fechaFacturacionMask,
      consumoFacturado: consumoFacturado,
      importeFacturado: importeFacturado,
      nisRad: nisRad,
    );
  }
}
