class ModalModel {
  final String? id;
  final String? descripcion;

  ModalModel({
    this.id,
    this.descripcion,
  });

  factory ModalModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ModalModel(
      id: json['id'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
    };
  }

  ModalModel copyWith({
    String? id,
    String? descripcion,
  }) {
    return ModalModel(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}
