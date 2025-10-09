class UserModel {
  final String nombre;
  final String apellido;
  final String numeroDocumento;
  final String tipoDocumento;
  final String password;
  final String cedulaRepresentante;
  final String tipoSolicitante;
  final String token;
  final String correo;
  final String direccion;
  final String pais;
  final String departamento;
  final String ciudad;
  final String telefonoCelular;
  final String tipoCliente;

  factory UserModel.empty() => const UserModel(
    nombre: '',
    apellido: '',
    numeroDocumento: '',
    tipoDocumento: '',
    password: '',
    cedulaRepresentante: '',
    tipoSolicitante: '',
    token: '',
    correo: '',
    direccion: '',
    pais: '',
    departamento: '',
    telefonoCelular: '',
    tipoCliente: '', ciudad: '',
  );

  const UserModel({
    required this.correo,
    required this.direccion,
    required this.pais,
    required this.departamento,
    required this.ciudad,
    required this.telefonoCelular,
    required this.tipoCliente,
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
    'correo': correo,
    'direccion': direccion,
    'pais': pais,
    'departamento': departamento,
    'cuidad': ciudad,
    'telefonoCelular': telefonoCelular,
    'tipoCliente': tipoCliente,
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
    correo: map['correo'],
    direccion: map['direccion'],
    pais: map['pais'],
    departamento: map['departamento'],
    ciudad: map['ciudad'],
    telefonoCelular: map['telefonoCelular'],
    tipoCliente: map['tipoCliente'],
  );
}
