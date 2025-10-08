class DatosUser {
  final String nombre;
  final String apellido;
  final String numeroDocumento;
  final String tipoDocumento;
  final String password;
  final String cedulaRepresentante;
  final String tipoSolicitante;
  final String token;

  DatosUser({
    required this.nombre,
    required this.apellido,
    required this.numeroDocumento,
    required this.tipoDocumento,
    required this.password,
    required this.cedulaRepresentante,
    required this.tipoSolicitante,
    required this.token,
  });

  factory DatosUser.fromJson(Map<String, dynamic> json) {
    return DatosUser(
      nombre: json['nombre'],
      apellido: json['apellido'],
      numeroDocumento: json['numeroDocumento'],
      tipoDocumento: json['tipoDocumento'],
      password: json['password'],
      cedulaRepresentante: json['cedulaRepresentante'],
      tipoSolicitante: json['tipoSolicitante'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'numeroDocumento': numeroDocumento,
      'tipoDocumento': tipoDocumento,
      'password': password,
      'cedulaRepresentante': cedulaRepresentante,
      'tipoSolicitante': tipoSolicitante,
      'token': token,
    };
  }

  DatosUser copyWith({
    required String nombre,
    required String apellido,
    required String numeroDocumento,
    required String tipoDocumento,
    required String password,
    required String cedulaRepresentante,
    required String tipoSolicitante,
    required String token,
  }) {
    return DatosUser(
      nombre: nombre,
      apellido: apellido,
      numeroDocumento: numeroDocumento,
      tipoDocumento: tipoDocumento,
      password: password,
      cedulaRepresentante: cedulaRepresentante,
      tipoSolicitante: tipoSolicitante,
      token: token,
    );
  }
}
