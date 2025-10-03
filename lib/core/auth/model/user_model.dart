class UserModel {
  final String nombre;
  final String apellido;
  final String token;

  const UserModel({
    required this.nombre,
    required this.apellido,
    required this.token,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'apellido': apellido,
        'token': token,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        nombre: map['nombre'],
        apellido: map['apellido'],
        token: map['token'],
      );
}
