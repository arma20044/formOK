class FacturaGraficoResponse {
  final Resultado? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  FacturaGraficoResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory FacturaGraficoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FacturaGraficoResponse(
      resultado: json['resultado'] != null ? Resultado.fromJson(json['resultado']) : null,
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

  FacturaGraficoResponse copyWith({
    Resultado? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return FacturaGraficoResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class Resultado {
  final List<ListaFacturaGrafico?>? lista;

  Resultado({
    this.lista,
  });

  factory Resultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Resultado(
       lista: json['lista'] != null ? List<ListaFacturaGrafico>.from(json['lista'].map((item) => ListaFacturaGrafico.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lista': lista?.map((item) => item?.toJson()).toList(),
    };
  }

  Resultado copyWith({
    List<ListaFacturaGrafico?>? lista,
  }) {
    return Resultado(
      lista: lista ?? this.lista,
    );
  }
}

class ListaFacturaGrafico {
  final String? fechaFacturacion;
  final String? fechaFacturacionMask;
  final num? consumoFacturado;
  final num? importeFacturado;
  final num? nisRad;

  ListaFacturaGrafico({
    this.fechaFacturacion,
    this.fechaFacturacionMask,
    this.consumoFacturado,
    this.importeFacturado,
    this.nisRad,
  });

  factory ListaFacturaGrafico.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ListaFacturaGrafico(
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

  ListaFacturaGrafico copyWith({
    String? fechaFacturacion,
    String? fechaFacturacionMask,
    num? consumoFacturado,
    num? importeFacturado,
    num? nisRad,
  }) {
    return ListaFacturaGrafico(
      fechaFacturacion: fechaFacturacion ?? this.fechaFacturacion,
      fechaFacturacionMask: fechaFacturacionMask ?? this.fechaFacturacionMask,
      consumoFacturado: consumoFacturado ?? this.consumoFacturado,
      importeFacturado: importeFacturado ?? this.importeFacturado,
      nisRad: nisRad ?? this.nisRad,
    );
  }
}
