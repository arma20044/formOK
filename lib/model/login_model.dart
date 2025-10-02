class Login {
  final String? jWTtoken;
  final Resultado? resultado;
  final List<dynamic>? mensajeList;
  final String? mensaje;
  final bool? login;
  final bool? error;
  final String? token;
  final List<dynamic>? errorValList;

  Login({
    this.jWTtoken,
    this.resultado,
    this.mensajeList,
    this.mensaje,
    this.login,
    this.error,
    this.token,
    this.errorValList,
  });

  factory Login.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Login(
      jWTtoken: json['JWTtoken'],
      resultado: json['resultado'] != null ? Resultado.fromJson(json['resultado']) : null,
       mensajeList: json['mensajeList'] != null ? List<dynamic>.from(json['mensajeList'].map((item) => item)) : null,
      mensaje: json['mensaje'],
      login: json['login'],
      error: json['error'],
      token: json['token'],
       errorValList: json['errorValList'] != null ? List<dynamic>.from(json['errorValList'].map((item) => item)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JWTtoken': jWTtoken,
      'resultado': resultado?.toJson(),
      'mensajeList': mensajeList?.map((item) => item).toList(),
      'mensaje': mensaje,
      'login': login,
      'error': error,
      'token': token,
      'errorValList': errorValList?.map((item) => item).toList(),
    };
  }

}

class Resultado {
  final String? verificado;
  final String? tipoSolicitante;
  final String? actualizacionDatos;
  final String? direccion;
  final String? nombre;
  final String? pais;
  final String? telefonoCelular;
  final String? tipoDocumento;
  final String? tipoCliente;
  final String? modificarPassword;
  final String? ciudad;
  final String? correoValido;
  final String? apellido;
  final String? correo;
  final String? departamento;
  final String? documentoIdentificacion;
  final List<SuministrosList?>? suministrosList;

  Resultado({
    this.verificado,
    this.tipoSolicitante,
    this.actualizacionDatos,
    this.direccion,
    this.nombre,
    this.pais,
    this.telefonoCelular,
    this.tipoDocumento,
    this.tipoCliente,
    this.modificarPassword,
    this.ciudad,
    this.correoValido,
    this.apellido,
    this.correo,
    this.departamento,
    this.documentoIdentificacion,
    this.suministrosList,
  });

  factory Resultado.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Resultado(
      verificado: json['verificado'],
      tipoSolicitante: json['tipoSolicitante'],
      actualizacionDatos: json['actualizacionDatos'],
      direccion: json['direccion'],
      nombre: json['nombre'],
      pais: json['pais'],
      telefonoCelular: json['telefonoCelular'],
      tipoDocumento: json['tipoDocumento'],
      tipoCliente: json['tipoCliente'],
      modificarPassword: json['modificarPassword'],
      ciudad: json['ciudad'],
      correoValido: json['correoValido'],
      apellido: json['apellido'],
      correo: json['correo'],
      departamento: json['departamento'],
      documentoIdentificacion: json['documentoIdentificacion'],
       suministrosList: json['suministrosList'] != null ? List<SuministrosList>.from(json['suministrosList'].map((item) => SuministrosList.fromJson(item))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verificado': verificado,
      'tipoSolicitante': tipoSolicitante,
      'actualizacionDatos': actualizacionDatos,
      'direccion': direccion,
      'nombre': nombre,
      'pais': pais,
      'telefonoCelular': telefonoCelular,
      'tipoDocumento': tipoDocumento,
      'tipoCliente': tipoCliente,
      'modificarPassword': modificarPassword,
      'ciudad': ciudad,
      'correoValido': correoValido,
      'apellido': apellido,
      'correo': correo,
      'departamento': departamento,
      'documentoIdentificacion': documentoIdentificacion,
      'suministrosList': suministrosList?.map((item) => item?.toJson()).toList(),
    };
  }

}

class SuministrosList {
  final num? indicadorAcuerdoLey6524;
  final num? indicadorBloqueoWeb;
  final num? indicadorLey6524;
  final num? nisRad;

  SuministrosList({
    this.indicadorAcuerdoLey6524,
    this.indicadorBloqueoWeb,
    this.indicadorLey6524,
    this.nisRad,
  });

  factory SuministrosList.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SuministrosList(
      indicadorAcuerdoLey6524: json['indicadorAcuerdoLey6524'],
      indicadorBloqueoWeb: json['indicadorBloqueoWeb'],
      indicadorLey6524: json['indicadorLey6524'],
      nisRad: json['nisRad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'indicadorAcuerdoLey6524': indicadorAcuerdoLey6524,
      'indicadorBloqueoWeb': indicadorBloqueoWeb,
      'indicadorLey6524': indicadorLey6524,
      'nisRad': nisRad,
    };
  }

}
