class SolicitudFraccionamientoResponse {
  final SolicitudFraccionamientoResultado? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  SolicitudFraccionamientoResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory SolicitudFraccionamientoResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SolicitudFraccionamientoResponse(
      resultado: json['resultado'] != null ? SolicitudFraccionamientoResultado.fromJson(json['resultado']) : null,
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

}

class SolicitudFraccionamientoResultado {
  final num? deuda;
  final num? multas;
  final String? nombreApellido;
  final num? importeUnaCuotasLey6524;
  final bool? tieneAcuerdoLey6524;
  final bool? bajaTension;
  final num? interesExonerado;
  final num? indicativoPromocionFraccionamientoValor1;
  final num? totalCuotasLey6524;
  final num? cantidadRecibosPendientes;
  final num? entrega;
  final double? porcentajeEntrega;
  final num? cantidadCuotasLey6524;
  final num? cantidadCuotas;
  final num? cuotas;

  SolicitudFraccionamientoResultado({
    this.deuda,
    this.multas,
    this.nombreApellido,
    this.importeUnaCuotasLey6524,
    this.tieneAcuerdoLey6524,
    this.bajaTension,
    this.interesExonerado,
    this.indicativoPromocionFraccionamientoValor1,
    this.totalCuotasLey6524,
    this.cantidadRecibosPendientes,
    this.entrega,
    this.porcentajeEntrega,
    this.cantidadCuotasLey6524,
    this.cantidadCuotas,
    this.cuotas,
  });

  factory SolicitudFraccionamientoResultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SolicitudFraccionamientoResultado(
      deuda: json['deuda'],
      multas: json['multas'],
      nombreApellido: json['nombreApellido'],
      importeUnaCuotasLey6524: json['importeUnaCuotasLey6524'],
      tieneAcuerdoLey6524: json['tieneAcuerdoLey6524'],
      bajaTension: json['bajaTension'],
      interesExonerado: json['interesExonerado'],
      indicativoPromocionFraccionamientoValor1: json['indicativoPromocionFraccionamientoValor1'],
      totalCuotasLey6524: json['totalCuotasLey6524'],
      cantidadRecibosPendientes: json['cantidadRecibosPendientes'],
      entrega: json['entrega'],
      porcentajeEntrega: json['porcentajeEntrega'] != null ? (json['porcentajeEntrega']) : null,
      cantidadCuotasLey6524: json['cantidadCuotasLey6524'],
      cantidadCuotas: json['cantidadCuotas'],
      cuotas: json['cuotas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deuda': deuda,
      'multas': multas,
      'nombreApellido': nombreApellido,
      'importeUnaCuotasLey6524': importeUnaCuotasLey6524,
      'tieneAcuerdoLey6524': tieneAcuerdoLey6524,
      'bajaTension': bajaTension,
      'interesExonerado': interesExonerado,
      'indicativoPromocionFraccionamientoValor1': indicativoPromocionFraccionamientoValor1,
      'totalCuotasLey6524': totalCuotasLey6524,
      'cantidadRecibosPendientes': cantidadRecibosPendientes,
      'entrega': entrega,
      'porcentajeEntrega': porcentajeEntrega,
      'cantidadCuotasLey6524': cantidadCuotasLey6524,
      'cantidadCuotas': cantidadCuotas,
      'cuotas': cuotas,
    };
  }

}

class PorcentajeEntrega {
  final String? source;
  final num? parsedValue;

  PorcentajeEntrega({
    this.source,
    this.parsedValue,
  });

  factory PorcentajeEntrega.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return PorcentajeEntrega(
      source: json['source'],
      parsedValue: json['parsedValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'parsedValue': parsedValue,
    };
  }

}
