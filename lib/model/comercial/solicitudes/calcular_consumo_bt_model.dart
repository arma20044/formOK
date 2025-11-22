class CalcularConsumoResponse {
  final ResultadoCalculoConsumo? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  CalcularConsumoResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory CalcularConsumoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CalcularConsumoResponse(
      resultado: json['resultado'] != null ? ResultadoCalculoConsumo.fromJson(json['resultado']) : null,
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

  CalcularConsumoResponse copyWith({
    ResultadoCalculoConsumo? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return CalcularConsumoResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class ResultadoCalculoConsumo {
  final bool? tieneCalculo;
  final num? consumo;
  final num? tarifa;
  final bool? tieneLectura;
  final num? monto;
  final num? cantidadDias;
  final num? consumoEstimado;
  final num? leturaAnterior;
  final String? ultimaFechaLectura;
  final bool? tienePrecio;
  final dynamic lecturaAnomala;
  final num? consumoFinal;

  ResultadoCalculoConsumo({
    this.tieneCalculo,
    this.consumo,
    this.tarifa,
    this.tieneLectura,
    this.monto,
    this.cantidadDias,
    this.consumoEstimado,
    this.leturaAnterior,
    this.ultimaFechaLectura,
    this.tienePrecio,
    this.lecturaAnomala,
    this.consumoFinal,
  });

  factory ResultadoCalculoConsumo.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ResultadoCalculoConsumo(
      tieneCalculo: json['tieneCalculo'],
      consumo: json['consumo'],
      tarifa: json['tarifa'],
      tieneLectura: json['tieneLectura'],
      monto: json['monto'],
      cantidadDias: json['cantidadDias'],
      consumoEstimado: json['consumoEstimado'],
      leturaAnterior: json['leturaAnterior'],
      ultimaFechaLectura: json['ultimaFechaLectura'],
      tienePrecio: json['tienePrecio'],
      lecturaAnomala: json['lecturaAnomala'],
      consumoFinal: json['consumoFinal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tieneCalculo': tieneCalculo,
      'consumo': consumo,
      'tarifa': tarifa,
      'tieneLectura': tieneLectura,
      'monto': monto,
      'cantidadDias': cantidadDias,
      'consumoEstimado': consumoEstimado,
      'leturaAnterior': leturaAnterior,
      'ultimaFechaLectura': ultimaFechaLectura,
      'tienePrecio': tienePrecio,
      'lecturaAnomala': lecturaAnomala,
      'consumoFinal': consumoFinal,
    };
  }

  ResultadoCalculoConsumo copyWith({
    bool? tieneCalculo,
    num? consumo,
    num? tarifa,
    bool? tieneLectura,
    num? monto,
    num? cantidadDias,
    num? consumoEstimado,
    num? leturaAnterior,
    String? ultimaFechaLectura,
    bool? tienePrecio,
    required dynamic lecturaAnomala,
    num? consumoFinal,
  }) {
    return ResultadoCalculoConsumo(
      tieneCalculo: tieneCalculo ?? this.tieneCalculo,
      consumo: consumo ?? this.consumo,
      tarifa: tarifa ?? this.tarifa,
      tieneLectura: tieneLectura ?? this.tieneLectura,
      monto: monto ?? this.monto,
      cantidadDias: cantidadDias ?? this.cantidadDias,
      consumoEstimado: consumoEstimado ?? this.consumoEstimado,
      leturaAnterior: leturaAnterior ?? this.leturaAnterior,
      ultimaFechaLectura: ultimaFechaLectura ?? this.ultimaFechaLectura,
      tienePrecio: tienePrecio ?? this.tienePrecio,
      lecturaAnomala: lecturaAnomala ?? this.lecturaAnomala,
      consumoFinal: consumoFinal ?? this.consumoFinal,
    );
  }
}
