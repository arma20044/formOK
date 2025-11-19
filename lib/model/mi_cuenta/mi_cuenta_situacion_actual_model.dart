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
      resultado: json['resultado'] != null
          ? SituacionActualResultado.fromJson(json['resultado'])
          : null,
      mensajeList: json['mensajeList'] != null
          ? List<dynamic>.from(json['mensajeList'].map((item) => item))
          : null,
      mensaje: json['mensaje'],
      error: json['error'],
      errorValList: json['errorValList'] != null
          ? List<dynamic>.from(json['errorValList'].map((item) => item))
          : null,
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
  final FacturaDatos? facturaDatos;
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
    required this.facturaDatos,
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
      facturaPagada: json['facturaPagada'] != null
          ? FacturaPagada.fromJson(json['facturaPagada'])
          : null,
      tieneLecTelem: json['tieneLecTelem'],
      numeroAparato: json['numeroAparato'],
      codigoMarcaAparato: json['codigoMarcaAparato'],
      facturaPenultima: json['facturaPenultima'],
      apellido: json['apellido'],
      tieneVideo: json['tieneVideo'],
      facturaDatos: json['facturaDatos'] != null
          ? FacturaDatos.fromJson(json['facturaDatos'])
          : FacturaDatos(recibo: json['recibo']),
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
      habilitarAporteLectura:
          habilitarAporteLectura ?? this.habilitarAporteLectura,
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

class Conceptos {
  final num? importeConcepto;
  final String? codigoConcepto;

  Conceptos({this.importeConcepto, this.codigoConcepto});

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
}

class ConceptosSinIVA {
  final num? importeConcepto;
  final String? codigoConcepto;

  ConceptosSinIVA({this.importeConcepto, this.codigoConcepto});

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
}

class ConceptosConIVA {
  final num? importeConcepto;
  final String? codigoConcepto;

  ConceptosConIVA({this.importeConcepto, this.codigoConcepto});

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
}

class Lectura {
  final String? tipoConsumo;
  final num? consumo;
  final String? numeroAparato;
  final num? lecturaAnterior;
  final num? constanteAparato;
  final num? csmoMin;
  final num? lecturaActual;

  Lectura({
    this.tipoConsumo,
    this.consumo,
    this.numeroAparato,
    this.lecturaAnterior,
    this.constanteAparato,
    this.csmoMin,
    this.lecturaActual,
  });

  factory Lectura.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Lectura(
      tipoConsumo: json['tipoConsumo'],
      consumo: json['consumo'],
      numeroAparato: json['numeroAparato'],
      lecturaAnterior: json['lecturaAnterior'],
      constanteAparato: json['constanteAparato'],
      csmoMin: json['csmoMin'],
      lecturaActual: json['lecturaActual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoConsumo': tipoConsumo,
      'consumo': consumo,
      'numeroAparato': numeroAparato,
      'lecturaAnterior': lecturaAnterior,
      'constanteAparato': constanteAparato,
      'csmoMin': csmoMin,
      'lecturaActual': lecturaActual,
    };
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
}

class FacturaDatos {
  final Recibo recibo;
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
    required this.recibo,
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
      recibo: Recibo.fromJson(json['recibo']),
      tipoTension: json['tipoTension'],
      informacionComplementaria: json['informacionComplementaria'] != null
          ? List<InformacionComplementaria>.from(
              json['informacionComplementaria'].map(
                (item) => InformacionComplementaria.fromJson(item),
              ),
            )
          : null,
      numMedidor: json['numMedidor'],
      conceptos: json['conceptos'] != null
          ? List<Conceptos>.from(
              json['conceptos'].map((item) => Conceptos.fromJson(item)),
            )
          : null,
      conceptosSinIVA: json['conceptosSinIVA'] != null
          ? List<ConceptosSinIVA>.from(
              json['conceptosSinIVA'].map(
                (item) => ConceptosSinIVA.fromJson(item),
              ),
            )
          : null,
      cargosVariosInspeccionTransformador:
          json['cargosVariosInspeccionTransformador'] != null
          ? List<dynamic>.from(
              json['cargosVariosInspeccionTransformador'].map((item) => item),
            )
          : null,
      facturaElectronica: json['facturaElectronica'],
      cabecera: json['cabecera'] != null
          ? Cabecera.fromJson(json['cabecera'])
          : null,
      conceptosConIVA: json['conceptosConIVA'] != null
          ? List<ConceptosConIVA>.from(
              json['conceptosConIVA'].map(
                (item) => ConceptosConIVA.fromJson(item),
              ),
            )
          : null,
      otrosImportes: json['otrosImportes'] != null
          ? OtrosImportes.fromJson(json['otrosImportes'])
          : null,
      lectura: json['lectura'] != null
          ? List<Lectura>.from(
              json['lectura'].map((item) => Lectura.fromJson(item)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recibo': recibo?.toJson(),
      'tipoTension': tipoTension,
      'informacionComplementaria': informacionComplementaria
          ?.map((item) => item?.toJson())
          .toList(),
      'numMedidor': numMedidor,
      'conceptos': conceptos?.map((item) => item?.toJson()).toList(),
      'conceptosSinIVA': conceptosSinIVA
          ?.map((item) => item?.toJson())
          .toList(),
      'cargosVariosInspeccionTransformador': cargosVariosInspeccionTransformador
          ?.map((item) => item)
          .toList(),
      'facturaElectronica': facturaElectronica,
      'cabecera': cabecera?.toJson(),
      'conceptosConIVA': conceptosConIVA
          ?.map((item) => item?.toJson())
          .toList(),
      'otrosImportes': otrosImportes?.toJson(),
      'lectura': lectura?.map((item) => item?.toJson()).toList(),
    };
  }
}

class Recibo {
  final num? nirSecuencial;
  final bool? liquidacionParaPago;
  final String? estado;
  final num? pendientesAnteriores;
  final dynamic cdc;
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
  final dynamic urlQR;
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
