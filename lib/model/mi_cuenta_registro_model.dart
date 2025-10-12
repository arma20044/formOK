class MiCuentaRegistroResponse {
  final dynamic resultado;
  final List<String> mensajeList;
  final String? mensaje;
  final bool error;
  final List<dynamic> errorValList;

  MiCuentaRegistroResponse({
    required this.resultado,
    required this.mensajeList,
     this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory MiCuentaRegistroResponse.fromJson(Map<String, dynamic> json) {
    return MiCuentaRegistroResponse(
      resultado: json['resultado'],
       mensajeList: List<String>.from(json['mensajeList'].map((item) => item)),
      mensaje: json['mensaje'],
      error: json['error'],
       errorValList: List<dynamic>.from(json['errorValList'].map((item) => item)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultado': resultado,
      'mensajeList': mensajeList.map((item) => item).toList(),
      'mensaje': mensaje,
      'error': error,
      'errorValList': errorValList.map((item) => item).toList(),
    };
  }

  MiCuentaRegistroResponse copyWith({
    required dynamic resultado,
    required List<String> mensajeList,
    required String mensaje,
    required bool error,
    required List<dynamic> errorValList,
  }) {
    return MiCuentaRegistroResponse(
      resultado: resultado,
      mensajeList: mensajeList,
      mensaje: mensaje,
      error: error,
      errorValList: errorValList,
    );
  }
}
