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
  final String? tipoTension;
  final String? codigoTension;
  final String? descripcionTension;
  final String? marcaAparato;
  final HabilitarAporteLectura? habilitarAporteLectura;
  final num? indicadorBloqueoWeb;
  final String? nombre;
  final CalculoConsumo? calculoConsumo;
  final bool? tieneDeuda;
  final String? url;
  final String? lecturaTeorica;
  final dynamic facturaPagada;
  final bool? tieneLecTelem;
  final String? numeroAparato;
  final String? codigoMarcaAparato;
  final dynamic facturaPenultima;
  final String? apellido;
  final bool? tieneVideo;
  final FacturaDatos? facturaDatos;
  final bool? tieneNis;

  SituacionActualResultado({
    this.tipoTension,
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
      tipoTension: json['tipoTension'],
      codigoTension: json['codigoTension'],
      descripcionTension: json['descripcionTension'],
      marcaAparato: json['marcaAparato'],
      habilitarAporteLectura: json['habilitarAporteLectura'] != null ? HabilitarAporteLectura.fromJson(json['habilitarAporteLectura']) : null,
      indicadorBloqueoWeb: json['indicadorBloqueoWeb'],
      nombre: json['nombre'],
      calculoConsumo: json['calculoConsumo'] != null ? CalculoConsumo.fromJson(json['calculoConsumo']) : null,
      tieneDeuda: json['tieneDeuda'],
      url: json['url'],
      lecturaTeorica: json['lecturaTeorica'],
      facturaPagada: json['facturaPagada'],
      tieneLecTelem: json['tieneLecTelem'],
      numeroAparato: json['numeroAparato'],
      codigoMarcaAparato: json['codigoMarcaAparato'],
      facturaPenultima: json['facturaPenultima'],
      apellido: json['apellido'],
      tieneVideo: json['tieneVideo'],
      facturaDatos: json['facturaDatos'] != null ? FacturaDatos.fromJson(json['facturaDatos']) : null,
      tieneNis: json['tieneNis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoTension': tipoTension,
      'codigoTension': codigoTension,
      'descripcionTension': descripcionTension,
      'marcaAparato': marcaAparato,
      'habilitarAporteLectura': habilitarAporteLectura?.toJson(),
      'indicadorBloqueoWeb': indicadorBloqueoWeb,
      'nombre': nombre,
      'calculoConsumo': calculoConsumo?.toJson(),
      'tieneDeuda': tieneDeuda,
      'url': url,
      'lecturaTeorica': lecturaTeorica,
      'facturaPagada': facturaPagada,
      'tieneLecTelem': tieneLecTelem,
      'numeroAparato': numeroAparato,
      'codigoMarcaAparato': codigoMarcaAparato,
      'facturaPenultima': facturaPenultima,
      'apellido': apellido,
      'tieneVideo': tieneVideo,
      'facturaDatos': facturaDatos?.toJson(),
      'tieneNis': tieneNis,
    };
  }

  SituacionActualResultado copyWith({
    String? tipoTension,
    String? codigoTension,
    String? descripcionTension,
    String? marcaAparato,
    HabilitarAporteLectura? habilitarAporteLectura,
    num? indicadorBloqueoWeb,
    String? nombre,
    CalculoConsumo? calculoConsumo,
    bool? tieneDeuda,
    String? url,
    String? lecturaTeorica,
    required dynamic facturaPagada,
    bool? tieneLecTelem,
    String? numeroAparato,
    String? codigoMarcaAparato,
    required dynamic facturaPenultima,
    String? apellido,
    bool? tieneVideo,
    FacturaDatos? facturaDatos,
    bool? tieneNis,
  }) {
    return SituacionActualResultado(
      tipoTension: tipoTension ?? this.tipoTension,
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

class FacturaDatos {
  final Recibo? recibo;
  final String? tipoTension;
  final List<InformacionComplementaria?>? informacionComplementaria;
  final String? numMedidor;
  final List<Conceptos?>? conceptos;
  final List<ConceptosSinIVA?>? conceptosSinIVA;
  final List<dynamic>? cargosVariosInspeccionTransformador;
  final bool? facturaElectronica;
  final Cabecera? cabecera;
  final List<ConceptosConIVA?>? conceptosConIVA;
  final OtrosImportes? otrosImportes;
  final List<Lectura?>? lectura;

  FacturaDatos({
    this.recibo,
    this.tipoTension,
    this.informacionComplementaria,
    this.numMedidor,
    this.conceptos,
    this.conceptosSinIVA,
    this.cargosVariosInspeccionTransformador,
    this.facturaElectronica,
    this.cabecera,
    this.conceptosConIVA,
    this.otrosImportes,
    this.lectura,
  });

  factory FacturaDatos.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FacturaDatos(
      recibo: json['recibo'] != null ? Recibo.fromJson(json['recibo']) : null,
      tipoTension: json['tipoTension'],
       informacionComplementaria: json['informacionComplementaria'] != null ? List<InformacionComplementaria>.from(json['informacionComplementaria'].map((item) => InformacionComplementaria.fromJson(item))) : null,
      numMedidor: json['numMedidor'],
       conceptos: json['conceptos'] != null ? List<Conceptos>.from(json['conceptos'].map((item) => Conceptos.fromJson(item))) : null,
       conceptosSinIVA: json['conceptosSinIVA'] != null ? List<ConceptosSinIVA>.from(json['conceptosSinIVA'].map((item) => ConceptosSinIVA.fromJson(item))) : null,
       cargosVariosInspeccionTransformador: json['cargosVariosInspeccionTransformador'] != null ? List<dynamic>.from(json['cargosVariosInspeccionTransformador'].map((item) => item)) : null,
      facturaElectronica: json['facturaElectronica'],
      cabecera: json['cabecera'] != null ? Cabecera.fromJson(json['cabecera']) : null,
       conceptosConIVA: json['conceptosConIVA'] != null ? List<ConceptosConIVA>.from(json['conceptosConIVA'].map((item) => ConceptosConIVA.fromJson(item))) : null,
      otrosImportes: json['otrosImportes'] != null ? OtrosImportes.fromJson(json['otrosImportes']) : null,
       lectura: json['lectura'] != null ? List<Lectura>.from(json['lectura'].map((item) => Lectura.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recibo': recibo?.toJson(),
      'tipoTension': tipoTension,
      'informacionComplementaria': informacionComplementaria?.map((item) => item?.toJson()).toList(),
      'numMedidor': numMedidor,
      'conceptos': conceptos?.map((item) => item?.toJson()).toList(),
      'conceptosSinIVA': conceptosSinIVA?.map((item) => item?.toJson()).toList(),
      'cargosVariosInspeccionTransformador': cargosVariosInspeccionTransformador?.map((item) => item).toList(),
      'facturaElectronica': facturaElectronica,
      'cabecera': cabecera?.toJson(),
      'conceptosConIVA': conceptosConIVA?.map((item) => item?.toJson()).toList(),
      'otrosImportes': otrosImportes?.toJson(),
      'lectura': lectura?.map((item) => item?.toJson()).toList(),
    };
  }

  FacturaDatos copyWith({
    Recibo? recibo,
    String? tipoTension,
    List<InformacionComplementaria?>? informacionComplementaria,
    String? numMedidor,
    List<Conceptos?>? conceptos,
    List<ConceptosSinIVA?>? conceptosSinIVA,
    List<dynamic>? cargosVariosInspeccionTransformador,
    bool? facturaElectronica,
    Cabecera? cabecera,
    List<ConceptosConIVA?>? conceptosConIVA,
    OtrosImportes? otrosImportes,
    List<Lectura?>? lectura,
  }) {
    return FacturaDatos(
      recibo: recibo ?? this.recibo,
      tipoTension: tipoTension ?? this.tipoTension,
      informacionComplementaria: informacionComplementaria ?? this.informacionComplementaria,
      numMedidor: numMedidor ?? this.numMedidor,
      conceptos: conceptos ?? this.conceptos,
      conceptosSinIVA: conceptosSinIVA ?? this.conceptosSinIVA,
      cargosVariosInspeccionTransformador: cargosVariosInspeccionTransformador ?? this.cargosVariosInspeccionTransformador,
      facturaElectronica: facturaElectronica ?? this.facturaElectronica,
      cabecera: cabecera ?? this.cabecera,
      conceptosConIVA: conceptosConIVA ?? this.conceptosConIVA,
      otrosImportes: otrosImportes ?? this.otrosImportes,
      lectura: lectura ?? this.lectura,
    );
  }
}

class Lectura {
  final String? tipoConsumo;
  final String? consumo;
  final String? numeroAparato;
  final String? constante;
  final String? lecturaAnterior;
  final num? constanteAparato;
  final String? fechaLectura;
  final String? csmoMin;
  final String? lecturaActual;

  Lectura({
    this.tipoConsumo,
    this.consumo,
    this.numeroAparato,
    this.constante,
    this.lecturaAnterior,
    this.constanteAparato,
    this.fechaLectura,
    this.csmoMin,
    this.lecturaActual,
  });

  factory Lectura.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Lectura(
      tipoConsumo: json['tipoConsumo'],
      consumo: json['consumo'],
      numeroAparato: json['numeroAparato'],
      constante: json['constante'],
      lecturaAnterior: json['lecturaAnterior'],
      constanteAparato: json['constanteAparato'],
      fechaLectura: json['fechaLectura'],
      csmoMin: json['csmoMin'],
      lecturaActual: json['lecturaActual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoConsumo': tipoConsumo,
      'consumo': consumo,
      'numeroAparato': numeroAparato,
      'constante': constante,
      'lecturaAnterior': lecturaAnterior,
      'constanteAparato': constanteAparato,
      'fechaLectura': fechaLectura,
      'csmoMin': csmoMin,
      'lecturaActual': lecturaActual,
    };
  }

  Lectura copyWith({
    String? tipoConsumo,
    String? consumo,
    String? numeroAparato,
    String? constante,
    String? lecturaAnterior,
    num? constanteAparato,
    String? fechaLectura,
    String? csmoMin,
    String? lecturaActual,
  }) {
    return Lectura(
      tipoConsumo: tipoConsumo ?? this.tipoConsumo,
      consumo: consumo ?? this.consumo,
      numeroAparato: numeroAparato ?? this.numeroAparato,
      constante: constante ?? this.constante,
      lecturaAnterior: lecturaAnterior ?? this.lecturaAnterior,
      constanteAparato: constanteAparato ?? this.constanteAparato,
      fechaLectura: fechaLectura ?? this.fechaLectura,
      csmoMin: csmoMin ?? this.csmoMin,
      lecturaActual: lecturaActual ?? this.lecturaActual,
    );
  }
}

class OtrosImportes {
  final num? deudaAnterior;
  final num? deudaTotal;
  final String? fechahoy;
  final String? codigoBarra;
  final num? comisionMasIva;
  final num? iva;
  final String? refdeCobro;
  final num? totalconComision;
  final num? comision;

  OtrosImportes({
    this.deudaAnterior,
    this.deudaTotal,
    this.fechahoy,
    this.codigoBarra,
    this.comisionMasIva,
    this.iva,
    this.refdeCobro,
    this.totalconComision,
    this.comision,
  });

  factory OtrosImportes.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return OtrosImportes(
      deudaAnterior: json['deudaAnterior'],
      deudaTotal: json['deudaTotal'],
      fechahoy: json['fechahoy'],
      codigoBarra: json['codigoBarra'],
      comisionMasIva: json['comisionMasIva'],
      iva: json['iva'],
      refdeCobro: json['refdeCobro'],
      totalconComision: json['totalconComision'],
      comision: json['comision'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deudaAnterior': deudaAnterior,
      'deudaTotal': deudaTotal,
      'fechahoy': fechahoy,
      'codigoBarra': codigoBarra,
      'comisionMasIva': comisionMasIva,
      'iva': iva,
      'refdeCobro': refdeCobro,
      'totalconComision': totalconComision,
      'comision': comision,
    };
  }

  OtrosImportes copyWith({
    num? deudaAnterior,
    num? deudaTotal,
    String? fechahoy,
    String? codigoBarra,
    num? comisionMasIva,
    num? iva,
    String? refdeCobro,
    num? totalconComision,
    num? comision,
  }) {
    return OtrosImportes(
      deudaAnterior: deudaAnterior ?? this.deudaAnterior,
      deudaTotal: deudaTotal ?? this.deudaTotal,
      fechahoy: fechahoy ?? this.fechahoy,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      comisionMasIva: comisionMasIva ?? this.comisionMasIva,
      iva: iva ?? this.iva,
      refdeCobro: refdeCobro ?? this.refdeCobro,
      totalconComision: totalconComision ?? this.totalconComision,
      comision: comision ?? this.comision,
    );
  }
}

class ConceptosConIVA {
  final num? importeConcepto;
  final String? codigoConcepto;

  ConceptosConIVA({
    this.importeConcepto,
    this.codigoConcepto,
  });

  factory ConceptosConIVA.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ConceptosConIVA(
      importeConcepto: json['importeConcepto'],
      codigoConcepto: json['codigoConcepto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'importeConcepto': importeConcepto,
      'codigoConcepto': codigoConcepto,
    };
  }

  ConceptosConIVA copyWith({
    num? importeConcepto,
    String? codigoConcepto,
  }) {
    return ConceptosConIVA(
      importeConcepto: importeConcepto ?? this.importeConcepto,
      codigoConcepto: codigoConcepto ?? this.codigoConcepto,
    );
  }
}

class Cabecera {
  final String? ruc;
  final String? cCC;
  final String? categoria;
  final String? titularContrato;
  final String? direccionCliente;
  final String? nombre;
  final String? agencia;
  final String? actividad;
  final String? tipoDocumento;
  final String? direccionSuministro;
  final String? llaveTM;
  final String? distribucion;
  final String? nir;
  final num? nis;

  Cabecera({
    this.ruc,
    this.cCC,
    this.categoria,
    this.titularContrato,
    this.direccionCliente,
    this.nombre,
    this.agencia,
    this.actividad,
    this.tipoDocumento,
    this.direccionSuministro,
    this.llaveTM,
    this.distribucion,
    this.nir,
    this.nis,
  });

  factory Cabecera.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Cabecera(
      ruc: json['ruc'],
      cCC: json['CCC'],
      categoria: json['categoria'],
      titularContrato: json['titularContrato'],
      direccionCliente: json['direccionCliente'],
      nombre: json['nombre'],
      agencia: json['agencia'],
      actividad: json['actividad'],
      tipoDocumento: json['tipoDocumento'],
      direccionSuministro: json['direccionSuministro'],
      llaveTM: json['llaveTM'],
      distribucion: json['distribucion'],
      nir: json['nir'],
      nis: json['nis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruc': ruc,
      'CCC': cCC,
      'categoria': categoria,
      'titularContrato': titularContrato,
      'direccionCliente': direccionCliente,
      'nombre': nombre,
      'agencia': agencia,
      'actividad': actividad,
      'tipoDocumento': tipoDocumento,
      'direccionSuministro': direccionSuministro,
      'llaveTM': llaveTM,
      'distribucion': distribucion,
      'nir': nir,
      'nis': nis,
    };
  }

  Cabecera copyWith({
    String? ruc,
    String? cCC,
    String? categoria,
    String? titularContrato,
    String? direccionCliente,
    String? nombre,
    String? agencia,
    String? actividad,
    String? tipoDocumento,
    String? direccionSuministro,
    String? llaveTM,
    String? distribucion,
    String? nir,
    num? nis,
  }) {
    return Cabecera(
      ruc: ruc ?? this.ruc,
      cCC: cCC ?? this.cCC,
      categoria: categoria ?? this.categoria,
      titularContrato: titularContrato ?? this.titularContrato,
      direccionCliente: direccionCliente ?? this.direccionCliente,
      nombre: nombre ?? this.nombre,
      agencia: agencia ?? this.agencia,
      actividad: actividad ?? this.actividad,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      direccionSuministro: direccionSuministro ?? this.direccionSuministro,
      llaveTM: llaveTM ?? this.llaveTM,
      distribucion: distribucion ?? this.distribucion,
      nir: nir ?? this.nir,
      nis: nis ?? this.nis,
    );
  }
}

class ConceptosSinIVA {
  final num? importeConcepto;
  final String? codigoConcepto;

  ConceptosSinIVA({
    this.importeConcepto,
    this.codigoConcepto,
  });

  factory ConceptosSinIVA.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ConceptosSinIVA(
      importeConcepto: json['importeConcepto'],
      codigoConcepto: json['codigoConcepto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'importeConcepto': importeConcepto,
      'codigoConcepto': codigoConcepto,
    };
  }

  ConceptosSinIVA copyWith({
    num? importeConcepto,
    String? codigoConcepto,
  }) {
    return ConceptosSinIVA(
      importeConcepto: importeConcepto ?? this.importeConcepto,
      codigoConcepto: codigoConcepto ?? this.codigoConcepto,
    );
  }
}

class Conceptos {
  final num? importeConcepto;
  final String? codigoConcepto;

  Conceptos({
    this.importeConcepto,
    this.codigoConcepto,
  });

  factory Conceptos.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Conceptos(
      importeConcepto: json['importeConcepto'],
      codigoConcepto: json['codigoConcepto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'importeConcepto': importeConcepto,
      'codigoConcepto': codigoConcepto,
    };
  }

  Conceptos copyWith({
    num? importeConcepto,
    String? codigoConcepto,
  }) {
    return Conceptos(
      importeConcepto: importeConcepto ?? this.importeConcepto,
      codigoConcepto: codigoConcepto ?? this.codigoConcepto,
    );
  }
}

class InformacionComplementaria {
  final num? consumo;
  final String? estado;
  final String? ciclo;
  final num? importe;

  InformacionComplementaria({
    this.consumo,
    this.estado,
    this.ciclo,
    this.importe,
  });

  factory InformacionComplementaria.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return InformacionComplementaria(
      consumo: json['consumo'],
      estado: json['estado'],
      ciclo: json['ciclo'],
      importe: json['importe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consumo': consumo,
      'estado': estado,
      'ciclo': ciclo,
      'importe': importe,
    };
  }

  InformacionComplementaria copyWith({
    num? consumo,
    String? estado,
    String? ciclo,
    num? importe,
  }) {
    return InformacionComplementaria(
      consumo: consumo ?? this.consumo,
      estado: estado ?? this.estado,
      ciclo: ciclo ?? this.ciclo,
      importe: importe ?? this.importe,
    );
  }
}

class Recibo {
  final num? nirSecuencial;
  final bool? liquidacionParaPago;
  final String? estado;
  final num? pendientesAnteriores;
  final String? cdc;
  final String? precioConcepto;
  final String? ciclo;
  final String? emision;
  final String? fechaVencimiento;
  final String? numeroFactura;
  final String? codigoEstado;
  final String? valTimbrado;
  final num? importeRecibo;
  final String? periodoConsumo;
  final num? diasConsumo;
  final String? urlQR;
  final String? numeroTimbrado;
  final String? numSerie;
  final num? cantidad;

  Recibo({
    this.nirSecuencial,
    this.liquidacionParaPago,
    this.estado,
    this.pendientesAnteriores,
    this.cdc,
    this.precioConcepto,
    this.ciclo,
    this.emision,
    this.fechaVencimiento,
    this.numeroFactura,
    this.codigoEstado,
    this.valTimbrado,
    this.importeRecibo,
    this.periodoConsumo,
    this.diasConsumo,
    this.urlQR,
    this.numeroTimbrado,
    this.numSerie,
    this.cantidad,
  });

  factory Recibo.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Recibo(
      nirSecuencial: json['nirSecuencial'],
      liquidacionParaPago: json['liquidacionParaPago'],
      estado: json['estado'],
      pendientesAnteriores: json['pendientesAnteriores'],
      cdc: json['cdc'],
      precioConcepto: json['precioConcepto'],
      ciclo: json['ciclo'],
      emision: json['emision'],
      fechaVencimiento: json['fechaVencimiento'],
      numeroFactura: json['numeroFactura'],
      codigoEstado: json['codigoEstado'],
      valTimbrado: json['valTimbrado'],
      importeRecibo: json['importeRecibo'],
      periodoConsumo: json['periodoConsumo'],
      diasConsumo: json['diasConsumo'],
      urlQR: json['urlQR'],
      numeroTimbrado: json['numeroTimbrado'],
      numSerie: json['num_serie'],
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nirSecuencial': nirSecuencial,
      'liquidacionParaPago': liquidacionParaPago,
      'estado': estado,
      'pendientesAnteriores': pendientesAnteriores,
      'cdc': cdc,
      'precioConcepto': precioConcepto,
      'ciclo': ciclo,
      'emision': emision,
      'fechaVencimiento': fechaVencimiento,
      'numeroFactura': numeroFactura,
      'codigoEstado': codigoEstado,
      'valTimbrado': valTimbrado,
      'importeRecibo': importeRecibo,
      'periodoConsumo': periodoConsumo,
      'diasConsumo': diasConsumo,
      'urlQR': urlQR,
      'numeroTimbrado': numeroTimbrado,
      'num_serie': numSerie,
      'cantidad': cantidad,
    };
  }

  Recibo copyWith({
    num? nirSecuencial,
    bool? liquidacionParaPago,
    String? estado,
    num? pendientesAnteriores,
    String? cdc,
    String? precioConcepto,
    String? ciclo,
    String? emision,
    String? fechaVencimiento,
    String? numeroFactura,
    String? codigoEstado,
    String? valTimbrado,
    num? importeRecibo,
    String? periodoConsumo,
    num? diasConsumo,
    String? urlQR,
    String? numeroTimbrado,
    String? numSerie,
    num? cantidad,
  }) {
    return Recibo(
      nirSecuencial: nirSecuencial ?? this.nirSecuencial,
      liquidacionParaPago: liquidacionParaPago ?? this.liquidacionParaPago,
      estado: estado ?? this.estado,
      pendientesAnteriores: pendientesAnteriores ?? this.pendientesAnteriores,
      cdc: cdc ?? this.cdc,
      precioConcepto: precioConcepto ?? this.precioConcepto,
      ciclo: ciclo ?? this.ciclo,
      emision: emision ?? this.emision,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      codigoEstado: codigoEstado ?? this.codigoEstado,
      valTimbrado: valTimbrado ?? this.valTimbrado,
      importeRecibo: importeRecibo ?? this.importeRecibo,
      periodoConsumo: periodoConsumo ?? this.periodoConsumo,
      diasConsumo: diasConsumo ?? this.diasConsumo,
      urlQR: urlQR ?? this.urlQR,
      numeroTimbrado: numeroTimbrado ?? this.numeroTimbrado,
      numSerie: numSerie ?? this.numSerie,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

class CalculoConsumo {
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
  final String? lecturaAnomala;
  final num? consumoFinal;

  CalculoConsumo({
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

  factory CalculoConsumo.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CalculoConsumo(
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

  CalculoConsumo copyWith({
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
    String? lecturaAnomala,
    num? consumoFinal,
  }) {
    return CalculoConsumo(
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

class HabilitarAporteLectura {
  final String? fechaActual;
  final num? lecturaMaxima;
  final String? fechaHasta;
  final String? fechaDesde;
  final num? lecturaAnterior;
  final String? habilitadoHora;
  final num? lecturaMinima;
  final String? habilitado;
  final dynamic mensaje;
  final dynamic mensajeHora;

  HabilitarAporteLectura({
    this.fechaActual,
    this.lecturaMaxima,
    this.fechaHasta,
    this.fechaDesde,
    this.lecturaAnterior,
    this.habilitadoHora,
    this.lecturaMinima,
    this.habilitado,
    this.mensaje,
    this.mensajeHora,
  });

  factory HabilitarAporteLectura.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return HabilitarAporteLectura(
      fechaActual: json['fechaActual'],
      lecturaMaxima: json['lecturaMaxima'],
      fechaHasta: json['fechaHasta'],
      fechaDesde: json['fechaDesde'],
      lecturaAnterior: json['lecturaAnterior'],
      habilitadoHora: json['habilitadoHora'],
      lecturaMinima: json['lecturaMinima'],
      habilitado: json['habilitado'],
      mensaje: json['mensaje'],
      mensajeHora: json['mensajeHora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fechaActual': fechaActual,
      'lecturaMaxima': lecturaMaxima,
      'fechaHasta': fechaHasta,
      'fechaDesde': fechaDesde,
      'lecturaAnterior': lecturaAnterior,
      'habilitadoHora': habilitadoHora,
      'lecturaMinima': lecturaMinima,
      'habilitado': habilitado,
      'mensaje': mensaje,
      'mensajeHora': mensajeHora,
    };
  }

  HabilitarAporteLectura copyWith({
    String? fechaActual,
    num? lecturaMaxima,
    String? fechaHasta,
    String? fechaDesde,
    num? lecturaAnterior,
    String? habilitadoHora,
    num? lecturaMinima,
    String? habilitado,
    required dynamic mensaje,
    required dynamic mensajeHora,
  }) {
    return HabilitarAporteLectura(
      fechaActual: fechaActual ?? this.fechaActual,
      lecturaMaxima: lecturaMaxima ?? this.lecturaMaxima,
      fechaHasta: fechaHasta ?? this.fechaHasta,
      fechaDesde: fechaDesde ?? this.fechaDesde,
      lecturaAnterior: lecturaAnterior ?? this.lecturaAnterior,
      habilitadoHora: habilitadoHora ?? this.habilitadoHora,
      lecturaMinima: lecturaMinima ?? this.lecturaMinima,
      habilitado: habilitado ?? this.habilitado,
      mensaje: mensaje ?? this.mensaje,
      mensajeHora: mensajeHora ?? this.mensajeHora,
    );
  }
}
