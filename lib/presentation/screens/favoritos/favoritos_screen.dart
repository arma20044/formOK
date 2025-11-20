import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/config/constantes.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_dialog_confirm.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/utils/utils.dart';
import 'package:go_router/go_router.dart';

class Favorito {
  final String id;
  final String title;

  Favorito({required this.id, required this.title});

  Map<String, dynamic> toJson() => {"id": id, "title": title};

  factory Favorito.fromJson(Map<String, dynamic> json) =>
      Favorito(id: json["id"], title: json["title"]);
}

class FavoritosStorage {
  static const String keyFacturas = "fav_facturas";
  static const String keyReclamos = "fav_reclamos";

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Obtener lista segura
  static Future<List<Favorito>> getLista(String key) async {
    final data = await _storage.read(key: key);

    if (data == null) return [];

    try {
      final List decoded = json.decode(data);
      // Convertir a Favorito y eliminar duplicados por id
      final List<Favorito> lista = decoded
          .map((e) => Favorito.fromJson(e))
          .toList();

      // Eliminar duplicados
      final ids = <String>{};
      final uniqueList = <Favorito>[];
      for (var f in lista) {
        if (!ids.contains(f.id)) {
          ids.add(f.id);
          uniqueList.add(f);
        }
      }
      return uniqueList;
    } catch (_) {
      return [];
    }
  }

  /// Guardar lista segura
  static Future<void> saveLista(String key, List<Favorito> lista) async {
    final encoded = json.encode(lista.map((e) => e.toJson()).toList());

    await _storage.write(key: key, value: encoded);
  }

  /// Borrar una lista completa
  static Future<void> clearLista(String key) async {
    await _storage.delete(key: key);
  }
}

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<Favorito> favFacturas = [];
  List<Favorito> favReclamos = [];

  @override
  void initState() {
    super.initState();

    obtenerFavoritos();
  }

  Future<void> obtenerFavoritos() async {
    final favoritosFac = await cargarDatos();
    setState(() {
      favFacturas = favoritosFac;
    });
  }

  Future<void> toggleFavoritoFactura(Favorito fav) async {
    final index = favFacturas.indexWhere((e) => e.id == fav.id);
    bool isFav;

    if (index != -1) {
      // Ya existe -> eliminar
      favFacturas.removeAt(index);
      isFav = false;
    } else {
      // Solo agregar si no existe
      favFacturas.add(fav);
      isFav = true;
    }

    // Guardar y eliminar duplicados antes de almacenar
    final ids = <String>{};
    final uniqueList = <Favorito>[];
    for (var f in favFacturas) {
      if (!ids.contains(f.id)) {
        ids.add(f.id);
        uniqueList.add(f);
      }
    }

    favFacturas = uniqueList;
    await FavoritosStorage.saveLista(FavoritosStorage.keyFacturas, favFacturas);
    setState(() {});

    CustomSnackbar.show(
      context,
      message: isFav
          ? "${fav.title} agregado a favoritos"
          : "${fav.title} eliminado de favoritos",
      type: isFav ? MessageType.success : MessageType.error,
    );
  }

  Future<void> toggleFavoritoReclamo(Favorito fav) async {
    if (!favReclamos.any((e) => e.id == fav.id)) {
      // Solo agregar si NO existe
      favReclamos.add(fav);
    } else {
      // Si ya existe, lo eliminamos
      favReclamos.removeWhere((e) => e.id == fav.id);
    }

    await FavoritosStorage.saveLista(FavoritosStorage.keyReclamos, favReclamos);
    setState(() {});
  }

  Future<void> irA(Favorito fav) async {
    GoRouter.of(context).push('/consultaFacturas/${fav.title}');
  }

  Widget buildList(
    String title,
    List<Favorito> lista,
    Function(Favorito) onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: lista.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("No hay favoritos."),
                ),
              ]
            : lista.map((item) {
                return ListTile(
                  title: Text(item.title),
                  onTap: () => irA(item), // 👈 Navega con el NIS
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => showConfirmDialog(
                      context: context,
                      title: "¿Eliminar factura?",
                      message: "Esta acción no se puede deshacer.",
                      type: DialogType.error,
                      onConfirm: () {
                        onTap(item);
                      },
                    ),
                    //onTap(item), // 👈 Esta función borra el favorito
                  ),
                );
              }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritos")),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildList(
              "Consulta de Facturas (NIS)",
              favFacturas,
              toggleFavoritoFactura,
            ),
            buildList("Reclamos", favReclamos, toggleFavoritoReclamo),
          ],
        ),
      ),
    );
  }
}
