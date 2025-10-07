class ConsultaFacturas {
  final Resultado? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  ConsultaFacturas({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory ConsultaFacturas.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ConsultaFacturas(
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

}

class Resultado {
  final List<Lista?>? lista;
  final DatosCliente? datosCliente;

  Resultado({
    this.lista,
    this.datosCliente,
  });

  factory Resultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Resultado(
       lista: json['lista'] != null ? List<Lista>.from(json['lista'].map((item) => Lista.fromJson(item))) : null,
      datosCliente: json['datosCliente'] != null ? DatosCliente.fromJson(json['datosCliente']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lista': lista?.map((item) => item?.toJson()).toList(),
      'datosCliente': datosCliente?.toJson(),
    };
  }

}

class DatosCliente {
  final String? ruc;
  final String? nombre;

  DatosCliente({
    this.ruc,
    this.nombre,
  });

  factory DatosCliente.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DatosCliente(
      ruc: json['ruc'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruc': ruc,
      'nombre': nombre,
    };
  }

}

class Lista {
  final String? fechaFacturacion;
  final String? estado;
  final num? nirSecuencial;
  final num? secRec;
  final String fechaVencimiento;
  final String? estadoFactura;
  final String? fechaEmision;
  final bool? esPagado;
  final String? codigoEstado;
  final num secNis;
  final num? importe;
  final num? cantidadImpresion;
  final String? numeroTimbrado;
  final bool? facturaElectronica;
  final num? importeCuenta;

  Lista({
    this.fechaFacturacion,
    this.estado,
    this.nirSecuencial,
    this.secRec,
    required this.fechaVencimiento,
    this.estadoFactura,
    this.fechaEmision,
    this.esPagado,
    this.codigoEstado,
    required this.secNis,
    this.importe,
    this.cantidadImpresion,
    this.numeroTimbrado,
    this.facturaElectronica,
    this.importeCuenta,
  });

  factory Lista.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Lista(
      fechaFacturacion: json['fechaFacturacion'],
      estado: json['estado'],
      nirSecuencial: json['nir_secuencial'],
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
      'estado': estado,
      'nir_secuencial': nirSecuencial,
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

}
