class MiCuentaRegistroModel {
  final dynamic resultado;
  final List<String> mensajeList;
  final String mensaje;
  final bool error;
  final List<dynamic> errorValList;

  MiCuentaRegistroModel({
    required this.resultado,
    required this.mensajeList,
    required this.mensaje,
    required this.error,
    required this.errorValList,
  });

  factory MiCuentaRegistroModel.fromJson(Map<String, dynamic> json) {
    return MiCuentaRegistroModel(
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

  MiCuentaRegistroModel copyWith({
    required dynamic resultado,
    required List<String> mensajeList,
    required String mensaje,
    required bool error,
    required List<dynamic> errorValList,
  }) {
    return MiCuentaRegistroModel(
      resultado: resultado,
      mensajeList: mensajeList,
      mensaje: mensaje,
      error: error,
      errorValList: errorValList,
    );
  }
}
