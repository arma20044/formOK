import 'package:form/model/login_model.dart';

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
  final String modificarPassword;
  List<SuministrosList?>? userDatosAnexos;

  factory UserModel.empty() =>  UserModel(
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
    modificarPassword: '',    
  );

   UserModel({
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
    required this.modificarPassword,
    this.userDatosAnexos
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
    'modificarPassword':modificarPassword,
    'userDatosAnexos':userDatosAnexos
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
    modificarPassword:map['modificarPassword'],
    userDatosAnexos:map['userDatosAnexos']
  );


 
  UserModel copyWith({
    String? password,
    String? token,
    String? modificarPassword,
  }) {
    return UserModel(
      nombre: nombre,
      apellido: apellido,
      numeroDocumento: numeroDocumento,
      tipoDocumento: tipoDocumento,
      password: password ?? this.password,
      cedulaRepresentante: cedulaRepresentante,
      tipoSolicitante: tipoSolicitante,
      token: token ?? this.token,
      correo: correo,
      direccion: direccion,
      pais: pais,
      departamento: departamento,
      ciudad: ciudad,
      telefonoCelular: telefonoCelular,
      tipoCliente: tipoCliente,
      modificarPassword:modificarPassword ?? this.modificarPassword,
      userDatosAnexos:userDatosAnexos
    );
  
}

}
