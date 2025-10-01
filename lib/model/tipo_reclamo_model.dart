class TipoReclamo {
  final String adjuntoObligatorio;
  final num idTipoReclamoCliente;
  final String? correoObligatorio;
  final String? categoriaWebApp;
  final String? nisObligatorio;
  final String? nombre;
  final String? activo;

  TipoReclamo({
    required this.adjuntoObligatorio,
   required this.idTipoReclamoCliente,
    this.correoObligatorio,
    this.categoriaWebApp,
    this.nisObligatorio,
    this.nombre,
    this.activo,
  });

  factory TipoReclamo.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return TipoReclamo(
      adjuntoObligatorio: json['adjuntoObligatorio'],
      idTipoReclamoCliente: json['idTipoReclamoCliente'],
      correoObligatorio: json['correoObligatorio'],
      categoriaWebApp: json['categoriaWebApp'],
      nisObligatorio: json['nisObligatorio'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adjuntoObligatorio': adjuntoObligatorio,
      'idTipoReclamoCliente': idTipoReclamoCliente,
      'correoObligatorio': correoObligatorio,
      'categoriaWebApp': categoriaWebApp,
      'nisObligatorio': nisObligatorio,
      'nombre': nombre,
      'activo': activo,
    };
  }

}