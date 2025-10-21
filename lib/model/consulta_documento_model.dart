class ConsultaDocumentoResponse {
  final ConsultaDocumentoResultado resultado;
  final String mensaje;
  final bool error;
  final List<dynamic> errorValList;

  ConsultaDocumentoResponse({
    required this.resultado,
    required this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory ConsultaDocumentoResponse.fromJson(Map<String, dynamic> json) {
    return ConsultaDocumentoResponse(
      resultado: ConsultaDocumentoResultado.fromJson(json['resultado']),
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: List<dynamic>.from(json['errorValList'].map((item) => item)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado.toJson(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList.map((item) => item).toList(),
    };
  }

  ConsultaDocumentoResponse copyWith({
    required ConsultaDocumentoResultado resultado,
    required String mensaje,
    required bool error,
    required List<dynamic> errorValList,
  }) {
    return ConsultaDocumentoResponse(
      resultado: resultado,
      mensaje: mensaje,
      error: error,
      errorValList: errorValList,
    );
  }
}

class ConsultaDocumentoResultado {
  final String nacionalidadBean;
  final String fechNacim;
  final num cedula;
  final String profesionBean;
  final String apellido;
  final String estadoCivil;
  final String sexo;
  final String nombres;
  final String razonSocial;

  ConsultaDocumentoResultado({
    required this.nacionalidadBean,
    required this.fechNacim,
    required this.cedula,
    required this.profesionBean,
    required this.apellido,
    required this.estadoCivil,
    required this.sexo,
    required this.nombres,
    required this.razonSocial,
  });

  factory ConsultaDocumentoResultado.fromJson(Map<String, dynamic> json) {
    return ConsultaDocumentoResultado(
      nacionalidadBean: json['nacionalidadBean'],
      fechNacim: json['fechNacim'],
      cedula: json['cedula'],
      profesionBean: json['profesionBean'],
      apellido: json['apellido'],
      estadoCivil: json['estadoCivil'],
      sexo: json['sexo'],
      nombres: json['nombres'],
      razonSocial: json['razonSocial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nacionalidadBean': nacionalidadBean,
      'fechNacim': fechNacim,
      'cedula': cedula,
      'profesionBean': profesionBean,
      'apellido': apellido,
      'estadoCivil': estadoCivil,
      'sexo': sexo,
      'nombres': nombres,
    };
  }

  ConsultaDocumentoResultado copyWith({
    required String nacionalidadBean,
    required String fechNacim,
    required num cedula,
    required String profesionBean,
    required String apellido,
    required String estadoCivil,
    required String sexo,
    required String nombres,
  }) {
    return ConsultaDocumentoResultado(
      nacionalidadBean: nacionalidadBean,
      fechNacim: fechNacim,
      cedula: cedula,
      profesionBean: profesionBean,
      apellido: apellido,
      estadoCivil: estadoCivil,
      sexo: sexo,
      nombres: nombres,
      razonSocial:razonSocial
    );
  }
}
