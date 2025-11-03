class MiCuentaSituacionActualResponse {
  final SituacionActualResultado? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  MiCuentaSituacionActualResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory MiCuentaSituacionActualResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MiCuentaSituacionActualResponse(
      resultado: json['resultado'] != null ? SituacionActualResultado.fromJson(json['resultado']) : null,
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

  MiCuentaSituacionActualResponse copyWith({
    SituacionActualResultado? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return MiCuentaSituacionActualResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class SituacionActualResultado {
  final String? codigoTension;
  final String? descripcionTension;
  final String? marcaAparato;
  final dynamic habilitarAporteLectura;
  final num? indicadorBloqueoWeb;
  final String? nombre;
  final dynamic calculoConsumo;
  final bool? tieneDeuda;
  final String? url;
  final String? lecturaTeorica;
  final FacturaPagada? facturaPagada;
  final bool? tieneLecTelem;
  final String? numeroAparato;
  final String? codigoMarcaAparato;
  final dynamic facturaPenultima;
  final String? apellido;
  final bool? tieneVideo;
  final dynamic facturaDatos;
  final bool? tieneNis;

  SituacionActualResultado({
    this.codigoTension,
    this.descripcionTension,
    this.marcaAparato,
    this.habilitarAporteLectura,
    this.indicadorBloqueoWeb,
    this.nombre,
    this.calculoConsumo,
    this.tieneDeuda,
    this.url,
    this.lecturaTeorica,
    this.facturaPagada,
    this.tieneLecTelem,
    this.numeroAparato,
    this.codigoMarcaAparato,
    this.facturaPenultima,
    this.apellido,
    this.tieneVideo,
    this.facturaDatos,
    this.tieneNis,
  });

  factory SituacionActualResultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SituacionActualResultado(
      codigoTension: json['codigoTension'],
      descripcionTension: json['descripcionTension'],
      marcaAparato: json['marcaAparato'],
      habilitarAporteLectura: json['habilitarAporteLectura'],
      indicadorBloqueoWeb: json['indicadorBloqueoWeb'],
      nombre: json['nombre'],
      calculoConsumo: json['calculoConsumo'],
      tieneDeuda: json['tieneDeuda'],
      url: json['url'],
      lecturaTeorica: json['lecturaTeorica'],
      facturaPagada: json['facturaPagada'] != null ? FacturaPagada.fromJson(json['facturaPagada']) : null,
      tieneLecTelem: json['tieneLecTelem'],
      numeroAparato: json['numeroAparato'],
      codigoMarcaAparato: json['codigoMarcaAparato'],
      facturaPenultima: json['facturaPenultima'],
      apellido: json['apellido'],
      tieneVideo: json['tieneVideo'],
      facturaDatos: json['facturaDatos'],
      tieneNis: json['tieneNis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoTension': codigoTension,
      'descripcionTension': descripcionTension,
      'marcaAparato': marcaAparato,
      'habilitarAporteLectura': habilitarAporteLectura,
      'indicadorBloqueoWeb': indicadorBloqueoWeb,
      'nombre': nombre,
      'calculoConsumo': calculoConsumo,
      'tieneDeuda': tieneDeuda,
      'url': url,
      'lecturaTeorica': lecturaTeorica,
      'facturaPagada': facturaPagada?.toJson(),
      'tieneLecTelem': tieneLecTelem,
      'numeroAparato': numeroAparato,
      'codigoMarcaAparato': codigoMarcaAparato,
      'facturaPenultima': facturaPenultima,
      'apellido': apellido,
      'tieneVideo': tieneVideo,
      'facturaDatos': facturaDatos,
      'tieneNis': tieneNis,
    };
  }

  SituacionActualResultado copyWith({
    String? codigoTension,
    String? descripcionTension,
    String? marcaAparato,
    required dynamic habilitarAporteLectura,
    num? indicadorBloqueoWeb,
    String? nombre,
    required dynamic calculoConsumo,
    bool? tieneDeuda,
    String? url,
    String? lecturaTeorica,
    FacturaPagada? facturaPagada,
    bool? tieneLecTelem,
    String? numeroAparato,
    String? codigoMarcaAparato,
    required dynamic facturaPenultima,
    String? apellido,
    bool? tieneVideo,
    required dynamic facturaDatos,
    bool? tieneNis,
  }) {
    return SituacionActualResultado(
      codigoTension: codigoTension ?? this.codigoTension,
      descripcionTension: descripcionTension ?? this.descripcionTension,
      marcaAparato: marcaAparato ?? this.marcaAparato,
      habilitarAporteLectura: habilitarAporteLectura ?? this.habilitarAporteLectura,
      indicadorBloqueoWeb: indicadorBloqueoWeb ?? this.indicadorBloqueoWeb,
      nombre: nombre ?? this.nombre,
      calculoConsumo: calculoConsumo ?? this.calculoConsumo,
      tieneDeuda: tieneDeuda ?? this.tieneDeuda,
      url: url ?? this.url,
      lecturaTeorica: lecturaTeorica ?? this.lecturaTeorica,
      facturaPagada: facturaPagada ?? this.facturaPagada,
      tieneLecTelem: tieneLecTelem ?? this.tieneLecTelem,
      numeroAparato: numeroAparato ?? this.numeroAparato,
      codigoMarcaAparato: codigoMarcaAparato ?? this.codigoMarcaAparato,
      facturaPenultima: facturaPenultima ?? this.facturaPenultima,
      apellido: apellido ?? this.apellido,
      tieneVideo: tieneVideo ?? this.tieneVideo,
      facturaDatos: facturaDatos ?? this.facturaDatos,
      tieneNis: tieneNis ?? this.tieneNis,
    );
  }
}

class FacturaPagada {
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

  FacturaPagada({
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

  factory FacturaPagada.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FacturaPagada(
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

  FacturaPagada copyWith({
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
    return FacturaPagada(
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
