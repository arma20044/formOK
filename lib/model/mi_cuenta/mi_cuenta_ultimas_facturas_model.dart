class MiCuentaUltimasFacturasResponse {
  final MiCuentaUltimasFacturasResultado? micuentaultimasfacturasresultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  MiCuentaUltimasFacturasResponse({
    this.micuentaultimasfacturasresultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory MiCuentaUltimasFacturasResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MiCuentaUltimasFacturasResponse(
      micuentaultimasfacturasresultado: json['micuentaultimasfacturasresultado'] != null ? MiCuentaUltimasFacturasResultado.fromJson(json['micuentaultimasfacturasresultado']) : null,
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'micuentaultimasfacturasresultado': micuentaultimasfacturasresultado?.toJson(),
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

  MiCuentaUltimasFacturasResponse copyWith({
    MiCuentaUltimasFacturasResultado? micuentaultimasfacturasresultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return MiCuentaUltimasFacturasResponse(
      micuentaultimasfacturasresultado: micuentaultimasfacturasresultado ?? this.micuentaultimasfacturasresultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class MiCuentaUltimasFacturasResultado {
  final List<MiCuentaUltimasFacturasLista?>? lista;

  MiCuentaUltimasFacturasResultado({
    this.lista,
  });

  factory MiCuentaUltimasFacturasResultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MiCuentaUltimasFacturasResultado(
       lista: json['lista'] != null ? List<MiCuentaUltimasFacturasLista>.from(json['lista'].map((item) => MiCuentaUltimasFacturasLista.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lista': lista?.map((item) => item?.toJson()).toList(),
    };
  }

  MiCuentaUltimasFacturasResultado copyWith({
    List<MiCuentaUltimasFacturasLista?>? lista,
  }) {
    return MiCuentaUltimasFacturasResultado(
      lista: lista ?? this.lista,
    );
  }
}

class MiCuentaUltimasFacturasLista {
  final String? fechaFacturacion;
  final num? nirSecuencial;
  final String? estado;
  final num? secRec;
  final String? fechaVencimiento;
  final String? estadoFactura;
  final String? fechaEmision;
  final bool? esPagado;
  final String? codigoEstado;
  final num? secNis;
  final num? importe;
  final num? cantidadImpresion;
  final String? numeroTimbrado;
  final bool? facturaElectronica;
  final num? importeCuenta;

  MiCuentaUltimasFacturasLista({
    this.fechaFacturacion,
    this.nirSecuencial,
    this.estado,
    this.secRec,
    this.fechaVencimiento,
    this.estadoFactura,
    this.fechaEmision,
    this.esPagado,
    this.codigoEstado,
    this.secNis,
    this.importe,
    this.cantidadImpresion,
    this.numeroTimbrado,
    this.facturaElectronica,
    this.importeCuenta,
  });

  factory MiCuentaUltimasFacturasLista.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MiCuentaUltimasFacturasLista(
      fechaFacturacion: json['fechaFacturacion'],
      nirSecuencial: json['nirSecuencial'],
      estado: json['estado'],
      secRec: json['sec_rec'],
      fechaVencimiento: json['fechaVencimiento'],
      estadoFactura: json['estadoFactura'],
      fechaEmision: json['fechaEmision'],
      esPagado: json['esPagado'],
      codigoEstado: json['codigoEstado'],
      secNis: json['sec_nis'],
      importe: json['importe'],
      cantidadImpresion: json['cantidadImpresion'],
      numeroTimbrado: json['numeroTimbrado'],
      facturaElectronica: json['facturaElectronica'],
      importeCuenta: json['importeCuenta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaFacturacion': fechaFacturacion,
      'nirSecuencial': nirSecuencial,
      'estado': estado,
      'sec_rec': secRec,
      'fechaVencimiento': fechaVencimiento,
      'estadoFactura': estadoFactura,
      'fechaEmision': fechaEmision,
      'esPagado': esPagado,
      'codigoEstado': codigoEstado,
      'sec_nis': secNis,
      'importe': importe,
      'cantidadImpresion': cantidadImpresion,
      'numeroTimbrado': numeroTimbrado,
      'facturaElectronica': facturaElectronica,
      'importeCuenta': importeCuenta,
    };
  }

  MiCuentaUltimasFacturasLista copyWith({
    String? fechaFacturacion,
    num? nirSecuencial,
    String? estado,
    num? secRec,
    String? fechaVencimiento,
    String? estadoFactura,
    String? fechaEmision,
    bool? esPagado,
    String? codigoEstado,
    num? secNis,
    num? importe,
    num? cantidadImpresion,
    String? numeroTimbrado,
    bool? facturaElectronica,
    num? importeCuenta,
  }) {
    return MiCuentaUltimasFacturasLista(
      fechaFacturacion: fechaFacturacion ?? this.fechaFacturacion,
      nirSecuencial: nirSecuencial ?? this.nirSecuencial,
      estado: estado ?? this.estado,
      secRec: secRec ?? this.secRec,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      estadoFactura: estadoFactura ?? this.estadoFactura,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      esPagado: esPagado ?? this.esPagado,
      codigoEstado: codigoEstado ?? this.codigoEstado,
      secNis: secNis ?? this.secNis,
      importe: importe ?? this.importe,
      cantidadImpresion: cantidadImpresion ?? this.cantidadImpresion,
      numeroTimbrado: numeroTimbrado ?? this.numeroTimbrado,
      facturaElectronica: facturaElectronica ?? this.facturaElectronica,
      importeCuenta: importeCuenta ?? this.importeCuenta,
    );
  }
}
