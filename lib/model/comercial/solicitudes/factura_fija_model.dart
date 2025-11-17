class FacturaFijaResponse {
  final ResultadoFacturaFija? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? error;
  final List<dynamic>? errorValList;

  FacturaFijaResponse({
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.error,
    this.errorValList,
  });

  factory FacturaFijaResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FacturaFijaResponse(
      resultado: json['resultado'] != null ? ResultadoFacturaFija.fromJson(json['resultado']) : null,
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

  FacturaFijaResponse copyWith({
    ResultadoFacturaFija? resultado,
    List<dynamic>? mensajeList,
    String? mensaje,
    bool? error,
    List<dynamic>? errorValList,
  }) {
    return FacturaFijaResponse(
      resultado: resultado ?? this.resultado,
      mensajeList: mensajeList ?? this.mensajeList,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
      errorValList: errorValList ?? this.errorValList,
    );
  }
}

class ResultadoFacturaFija {
  final num? iva;
  final num? precioTarifa;
  final num? importeConsumo;
  final String? habilitarFormulario;
  final String? apellido;
  final num? consumoPromedio;
  final num? importeAlumbrado;
  final num? consumoRedondeado;
  final String? nombre;

  ResultadoFacturaFija({
    this.iva,
    this.precioTarifa,
    this.importeConsumo,
    this.habilitarFormulario,
    this.apellido,
    this.consumoPromedio,
    this.importeAlumbrado,
    this.consumoRedondeado,
    this.nombre,
  });

  factory ResultadoFacturaFija.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ResultadoFacturaFija(
      iva: json['iva'],
      precioTarifa: json['precioTarifa'],
      importeConsumo: json['importeConsumo'],
      habilitarFormulario: json['habilitarFormulario'],
      apellido: json['apellido'],
      consumoPromedio: json['consumoPromedio'],
      importeAlumbrado: json['importeAlumbrado'],
      consumoRedondeado: json['consumoRedondeado'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iva': iva,
      'precioTarifa': precioTarifa,
      'importeConsumo': importeConsumo,
      'habilitarFormulario': habilitarFormulario,
      'apellido': apellido,
      'consumoPromedio': consumoPromedio,
      'importeAlumbrado': importeAlumbrado,
      'consumoRedondeado': consumoRedondeado,
      'nombre': nombre,
    };
  }

  ResultadoFacturaFija copyWith({
    num? iva,
    num? precioTarifa,
    num? importeConsumo,
    String? habilitarFormulario,
    String? apellido,
    num? consumoPromedio,
    num? importeAlumbrado,
    num? consumoRedondeado,
    String? nombre,
  }) {
    return ResultadoFacturaFija(
      iva: iva ?? this.iva,
      precioTarifa: precioTarifa ?? this.precioTarifa,
      importeConsumo: importeConsumo ?? this.importeConsumo,
      habilitarFormulario: habilitarFormulario ?? this.habilitarFormulario,
      apellido: apellido ?? this.apellido,
      consumoPromedio: consumoPromedio ?? this.consumoPromedio,
      importeAlumbrado: importeAlumbrado ?? this.importeAlumbrado,
      consumoRedondeado: consumoRedondeado ?? this.consumoRedondeado,
      nombre: nombre ?? this.nombre,
    );
  }
}
