import 'package:form/model/favoritos/datos_reclamo_model.dart';
import 'package:form/model/favoritos/favoritos_tipo_model.dart';

class Favorito {
  final String id;
  final String title;
  final FavoritoTipo tipo;
  final DatosReclamo? datos; // SOLO para reclamo

  Favorito({
    required this.id,
    required this.title,
    this.tipo = FavoritoTipo.vacio,
    this.datos,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tipo": tipo.name,
        if (datos != null) "datos": datos!.toJson(), // solo si existe
      };

  factory Favorito.fromJson(Map<String, dynamic> json) => Favorito(
        id: json["id"],
        title: json["title"],
        tipo: FavoritoTipo.values.firstWhere(
          (e) => e.name == json["tipo"],
          orElse: () => FavoritoTipo.vacio,
        ),
        datos: json["datos"] != null
            ? DatosReclamo.fromJson(json["datos"])
            : null,
      );
}
