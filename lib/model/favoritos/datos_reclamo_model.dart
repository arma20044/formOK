class DatosReclamo {
  final String grupoReclamo;
  final String numeroReclamo;
  final String fechaReclamo;
  final int idDepartamento;
  final String departamentoDescripcion;
  final int idCiudad;
  final String ciudadDescripcion;
  final int idBarrio;
  final String barrioDescripcion;
  final int idTipoReclamoCliente;
  final String telefono;
  final String nombreApellido;
  final String direccion;
  final String correo;
  final String nis;
  final String adjuntoObligatorio;
  final String referencia;
  final String? observacion;
  final dynamic latitud;   // puede ser number o string
  final dynamic longitud;  // puede ser number o string

  DatosReclamo({
    required this.grupoReclamo,
    required this.numeroReclamo,
    required this.fechaReclamo,
    required this.idDepartamento,
    required this.departamentoDescripcion,
    required this.idCiudad,
    required this.ciudadDescripcion,
    required this.idBarrio,
    required this.barrioDescripcion,
    required this.idTipoReclamoCliente,
    required this.telefono,
    required this.nombreApellido,
    required this.direccion,
    required this.correo,
    required this.nis,
    required this.adjuntoObligatorio,
    required this.referencia,
    this.observacion,
    this.latitud,
    this.longitud,
  });

  factory DatosReclamo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return throw Exception("DatosReclamo vacío");

    return DatosReclamo(
      grupoReclamo: json["grupoReclamo"],
      numeroReclamo: json["numeroReclamo"],
      fechaReclamo: json["fechaReclamo"],
      idDepartamento: json["idDepartamento"],
      departamentoDescripcion: json["departamentoDescripcion"],
      idCiudad: json["idCiudad"],
      ciudadDescripcion: json["ciudadDescripcion"],
      idBarrio: json["idBarrio"],
      barrioDescripcion: json["barrioDescripcion"],
      idTipoReclamoCliente: json["idTipoReclamoCliente"],
      telefono: json["telefono"],
      nombreApellido: json["nombreApellido"],
      direccion: json["direccion"],
      correo: json["correo"],
      nis: json["nis"],
      adjuntoObligatorio: json["adjuntoObligatorio"],
      referencia: json["referencia"],
      observacion: json["observacion"],
      latitud: json["latitud"],
      longitud: json["longitud"],
    );
  }

  Map<String, dynamic> toJson() => {
        "grupoReclamo": grupoReclamo,
        "numeroReclamo": numeroReclamo,
        "fechaReclamo": fechaReclamo,
        "idDepartamento": idDepartamento,
        "departamentoDescripcion": departamentoDescripcion,
        "idCiudad": idCiudad,
        "ciudadDescripcion": ciudadDescripcion,
        "idBarrio": idBarrio,
        "barrioDescripcion": barrioDescripcion,
        "idTipoReclamoCliente": idTipoReclamoCliente,
        "telefono": telefono,
        "nombreApellido": nombreApellido,
        "direccion": direccion,
        "correo": correo,
        "nis": nis,
        "adjuntoObligatorio": adjuntoObligatorio,
        "referencia": referencia,
        "observacion": observacion,
        "latitud": latitud,
        "longitud": longitud,
      };
}
