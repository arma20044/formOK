import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form/config/constantes.dart';
import 'package:form/model/favoritos/favoritos_model.dart';
import 'package:form/model/favoritos/favoritos_tipo_model.dart';
import 'package:form/presentation/components/common/UI/custom_card.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_dialog_confirm.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/components/common/custom_text.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/utils/utils.dart';
import 'package:go_router/go_router.dart';

//
// ==================================================
// ENUM – Tipo de favorito
// ==================================================
//

//
// ==================================================
// MODELO – Favorito
// ==================================================
//

//
// ==================================================
// STORAGE – Manejo de favoritos
// ==================================================
//
class FavoritosStorage {
  static const String keyFacturas = "fav_facturas";
  static const String keyReclamos = "fav_reclamos";

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Obtener lista limpia (sin duplicados)
  static Future<List<Favorito>> getLista(String key) async {
    final data = await _storage.read(key: key);
    if (data == null) return [];

    try {
      final List decoded = json.decode(data);

      final map = <String, Favorito>{
        for (var item in decoded)
          Favorito.fromJson(item).id: Favorito.fromJson(item),
      };

      return map.values.toList();
    } catch (_) {
      return [];
    }
  }

  /// Guardar lista, eliminando duplicados
  static Future<void> saveLista(String key, List<Favorito> lista) async {
    final map = <String, Favorito>{for (var f in lista) f.id: f};

    final encoded = json.encode(map.values.map((e) => e.toJson()).toList());

    await _storage.write(key: key, value: encoded);
  }
}

//
// ==================================================
// PANTALLA – FavoritosScreen
// ==================================================
//
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
    final favoritosFac = await FavoritosStorage.getLista(
      FavoritosStorage.keyFacturas,
    );
    final favoritosReclamos = await FavoritosStorage.getLista(
      FavoritosStorage.keyReclamos,
    );

    setState(() {
      favFacturas = favoritosFac;
      favReclamos = favoritosReclamos;
    });
  }

  //
  // ==================================================
  // AGREGAR / QUITAR FAVORITO – FACTURA
  // ==================================================
  //
  /*Future<void> toggleFavoritoFactura(Favorito fav) async {
    // Forzamos el tipo correcto
    fav = Favorito(id: fav.id, title: fav.title, tipo: FavoritoTipo.consultaFactura);

    final exists = favFacturas.any((e) => e.id == fav.id);

    if (exists) {
      favFacturas.removeWhere((e) => e.id == fav.id);
    } else {
      favFacturas.add(fav);
    }

    await FavoritosStorage.saveLista(FavoritosStorage.keyFacturas, favFacturas);
    setState(() {});

    CustomSnackbar.show(
      context,
      message: exists
          ? "${fav.title} eliminado de favoritos"
          : "${fav.title} agregado a favoritos",
      type: exists ? MessageType.error : MessageType.success,
    );
  }*/

  //
  // ==================================================
  // AGREGAR / QUITAR FAVORITO – RECLAMO
  // ==================================================
  //
  /*Future<void> toggleFavoritoReclamo(Favorito fav) async {
    fav = Favorito(id: fav.id, title: fav.title, tipo: FavoritoTipo.datosReclamo);

    final exists = favReclamos.any((e) => e.id == fav.id);

    if (exists) {
      favReclamos.removeWhere((e) => e.id == fav.id);
    } else {
      favReclamos.add(fav);
    }

    await FavoritosStorage.saveLista(FavoritosStorage.keyReclamos, favReclamos);
    setState(() {});
  }*/

  //
  // ==================================================
  // NAVEGACIÓN SEGÚN TIPO
  // ==================================================
  //
  Future<void> irA(Favorito fav) async {
    switch (fav.tipo) {
      case FavoritoTipo.consultaFactura:
        GoRouter.of(context).push('/consultaFacturas/${fav.id}');
        break;

      case FavoritoTipo.datosReclamo:
        GoRouter.of(
          context,
        ).push('/reclamosFaltaEnergia/${fav.datos!.telefono}');
        break;

      default:
        CustomSnackbar.show(
          context,
          message: "Tipo de favorito no reconocido",
          type: MessageType.error,
        );
        break;
    }
  }

  Future<void> borrar(Favorito fav) async {
    switch (fav.tipo) {
      case FavoritoTipo.consultaFactura:
        toggleFavoritoFactura(fav,context);
        obtenerFavoritos();
        break;

      case FavoritoTipo.datosReclamo:
        toggleFavoritoReclamo(fav);
        obtenerFavoritos();
        break;
      default:
        CustomSnackbar.show(
          context,
          message: "Tipo de favorito no reconocido",
          type: MessageType.error,
        );
        break;
    }
  }

  Widget queCardMuestro(Favorito fav) {
    switch (fav.tipo) {
      case FavoritoTipo.consultaFactura:
        return Column(
          children: [Text("NIS ${fav.title}. Consulta de Factura")],
        );

      case FavoritoTipo.datosReclamo:
        return Column(
          children: [
            CustomText(
              "Nro.: ${fav.datos?.numeroReclamo} ${fav.datos?.nombreApellido} Tel.: ${fav.datos?.telefono} ${fav.datos?.barrioDescripcion} ${fav.datos?.ciudadDescripcion}-${fav.datos?.departamentoDescripcion} ${fav.datos?.referencia} ${fav.datos?.fechaReclamo}",
              overflow: TextOverflow.clip,
            ),
          ],
        );

      default:
        CustomSnackbar.show(
          context,
          message: "Tipo de favorito no reconocido",
          type: MessageType.error,
        );
        return Text("data");
    }
  }

  //
  // ==================================================
  // ÍCONO SEGÚN TIPO
  // ==================================================
  //
  Icon _iconoSegunTipo(FavoritoTipo tipo) {
    switch (tipo) {
      case FavoritoTipo.consultaFactura:
        return const Icon(Icons.receipt_long, color: Colors.blue);
      case FavoritoTipo.datosReclamo:
        return const Icon(Icons.report_problem, color: Colors.orange);
      default:
        return const Icon(Icons.star_border);
    }
  }

  //
  // ==================================================
  // LISTA REUTILIZABLE
  // ==================================================
  //
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
                  child: Text("No se encontraron registros."),
                ),
              ]
            : lista.map((item) {
                return ListTile(
                  leading: _iconoSegunTipo(item.tipo),
                  title: queCardMuestro(item),

                  onTap: () => irA(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => showConfirmDialog(
                      context: context,
                      title: "¿Eliminar favorito?",
                      message: "Esta acción no se puede deshacer.",
                      type: DialogType.error,
                      onConfirm: () => borrar(item),
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }

  //
  // ==================================================
  // UI PRINCIPAL
  // ==================================================
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritos")),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildList(
              "Sevicios por NIS",
              favFacturas,
              (fav) => toggleFavoritoFactura(fav,context),
            ),
            buildList(
              "Últimos Reclamos Realizados",
              favReclamos,
              toggleFavoritoReclamo,
            ),
          ],
        ),
      ),
    );
  }
}
