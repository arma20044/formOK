class UserModel {
  final String nombre;
  final String apellido;
  final String numeroDocumento;
  final String tipoDocumento;
  final String password;
  final String cedulaRepresentante;
  final String tipoSolicitante;
  final String token;

factory UserModel.empty() => const UserModel(
        nombre: '',
        apellido: '',
        numeroDocumento: '',
        tipoDocumento: '',
        password: '',
        cedulaRepresentante: '',
        tipoSolicitante: '',
        token: '',
      );
  
  const UserModel({
    required this.nombre,
    required this.apellido,
    required this.numeroDocumento,
    required this.tipoDocumento,
    required this.password,
    required this.cedulaRepresentante,
    required this.tipoSolicitante,
    required this.token,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'apellido': apellido,
        'numeroDocumento': numeroDocumento,
        'tipoDocumento': tipoDocumento,
        'password': password,
        'cedulaRepresentante': cedulaRepresentante,
        'tipoSolicitante': tipoSolicitante,
        'token': token,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        nombre: map['nombre'],
        apellido: map['apellido'],
        numeroDocumento: map['numeroDocumento'],
        tipoDocumento: map['tipoDocumento'],
        password: map['password'],
        cedulaRepresentante: map['cedulaRepresentante'],
        tipoSolicitante: map['tipoSolicitante'],        
        token: map['token'],
      );
}
