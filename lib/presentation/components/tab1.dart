import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/model/favoritos/datos_reclamo_model.dart';
import 'package:form/model/favoritos/favoritos_model.dart';
import 'package:form/model/favoritos/favoritos_tipo_model.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_dialog_confirm.dart';
import 'package:form/presentation/components/common/custom_snackbar.dart';
import 'package:form/presentation/screens/favoritos/favoritos_screen.dart';
import 'package:form/utils/utils.dart';

import '../../core/api/mi_ande_api.dart';
import '../../core/validators/validators.dart';
import '../../infrastructure/infrastructure.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import '../../repositories/tipo_reclamo_repository_impl.dart';
import 'widgets/dropdown_custom.dart';

class Tab1 extends StatefulWidget {
  final String tipoReclamo; // FE, CO, AP
  final String? telefono;

  const Tab1({super.key, required this.tipoReclamo, this.telefono});

  @override
  Tab1State createState() => Tab1State();
}

class Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Departamento? selectedDept;
  Ciudad? selectedCiudad;
  Barrio? selectedBarrio;
  TipoReclamo? selectedTipoReclamo;

  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController nombreApellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController referenciaController = TextEditingController();

  final repoDepartamento = DepartamentoRepositoryImpl(DepartamentoDatasourceImpl(MiAndeApi()));
  final repoCiudad = CiudadRepositoryImpl(CiudadDatasourceImpl(MiAndeApi()));
  final repoBarrio = BarrioRepositoryImpl(BarrioDatasourceImpl(MiAndeApi()));
  final repoTipoReclamo = TipoReclamoRepositoryImpl(TipoReclamoDatasourceImpl(MiAndeApi()));
  final repoUltimosReclamos = ReclamoRecuperadoRepositoryImpl(ReclamoRecuperadoDatasourceImpl(MiAndeApi()));

  List<Departamento> listaDepartamentos = [];
  List<Ciudad> listaCiudades = [];
  List<Barrio> listaBarrios = [];
  List<TipoReclamo> listaTipoReclamo = [];

  bool isLoadingDepartamentos = false;
  bool isLoadingCiudades = false;
  bool isLoadingBarrios = false;
  bool isLoadingTipoReclamo = false;
  bool isLoadingUltimosReclamos = false;

  late ReclamoRecuperadoResponse listaUltimosReclamos;
  late Map<String, String? Function(String?)> validators;
  final FocusNode _focusNode = FocusNode();

  bool esFavorito = false;
  List<Favorito> favReclamos = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartamentos();
    _fetchTipoReclamo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final telefono = widget.telefono;
      if (telefono != null && telefono.isNotEmpty) {
        telefonoController.text = telefono;
        recuperarUltimoReclamo(telefono);
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        recuperarUltimoReclamo(telefonoController.text);
      }
    });

    validators = {
      'direccion': (val) => val == null || val.isEmpty ? "Ingrese una Dirección" : null,
      'telefono': (val) {
        if ((selectedTipoReclamo?.nisObligatorio ?? 'N') == 'S') {
          if (val == null || val.isEmpty) return "Ingrese un teléfono";
          if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
        }
        return null;
      },
      'referencia': (val) {
        if (widget.tipoReclamo != "CX" && (val == null || val.isEmpty)) return "Ingrese Referencia";
        return null;
      },
      'nombreApellido': (val) {
        if ((widget.tipoReclamo == "FE" || widget.tipoReclamo == "CO" || widget.tipoReclamo == "AP") &&
            (val == null || val.isEmpty)) return "Ingrese Nombre y Apellido";
        return null;
      },
    };

    obtenerFavoritos();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void limpiar() {
  setState(() {
    selectedDept = null;
    selectedCiudad = null;
    selectedBarrio = null;
    selectedTipoReclamo = null;

    listaCiudades = [];
    listaBarrios = [];

    telefonoController.clear();
    nisController.clear();
    nombreApellidoController.clear();
    direccionController.clear();
    correoController.clear();
    referenciaController.clear();

    esFavorito = false;
  });
}


  // -------------------- FETCH --------------------
  Future<void> _fetchDepartamentos() async {
    setState(() => isLoadingDepartamentos = true);
    try {
      listaDepartamentos = await repoDepartamento.getDepartamento();
    } catch (e) {
      print("Error al cargar departamentos: $e");
    } finally {
      setState(() => isLoadingDepartamentos = false);
    }
  }

  Future<void> _fetchCiudades(num idDepartamento) async {
    setState(() => isLoadingCiudades = true);
    try {
      listaCiudades = await repoCiudad.getCiudad(idDepartamento);
    } catch (e) {
      print("Error al cargar ciudad: $e");
    } finally {
      setState(() => isLoadingCiudades = false);
    }
  }

  Future<void> _fetchBarrios(num idCiudad) async {
    setState(() => isLoadingBarrios = true);
    try {
      listaBarrios = await repoBarrio.getBarrio(idCiudad);
    } catch (e) {
      print("Error al cargar barrio: $e");
    } finally {
      setState(() => isLoadingBarrios = false);
    }
  }

  Future<void> _fetchTipoReclamo() async {
    setState(() => isLoadingTipoReclamo = true);
    try {
      listaTipoReclamo = await repoTipoReclamo.getTipoReclamo(widget.tipoReclamo);
    } catch (e) {
      print("Error al cargar tipo reclamo: $e");
    } finally {
      setState(() => isLoadingTipoReclamo = false);
    }
  }

  // -------------------- FAVORITOS --------------------
  DatosReclamo obtenerDatosReclamo() {
    return DatosReclamo(
      grupoReclamo: widget.tipoReclamo,
      numeroReclamo: "", // Podés llenar con valor real
      fechaReclamo: DateTime.now().toIso8601String(),
      idDepartamento: selectedDept?.idDepartamento.toInt() ?? 0,
      departamentoDescripcion: selectedDept?.nombre ?? '',
      idCiudad: selectedCiudad?.idCiudad.toInt() ?? 0,
      ciudadDescripcion: selectedCiudad?.nombre ?? '',
      idBarrio: selectedBarrio?.idBarrio.toInt() ?? 0,
      barrioDescripcion: selectedBarrio?.nombre ?? '',
      idTipoReclamoCliente: selectedTipoReclamo?.idTipoReclamoCliente.toInt() ?? 0,
      telefono: telefonoController.text,
      nombreApellido: nombreApellidoController.text,
      direccion: direccionController.text,
      correoElectronico: correoController.text,
      nis: nisController.text,
      adjuntoObligatorio: "N",
      referencia: referenciaController.text,
      observacion: "",
      latitud: null,
      longitud: null,
    );
  }

  Future<void> toggleFavoritoReclamo(Favorito fav) async {
    final favoritos = await cargarDatosFacturas(); // tu función de carga
    final index = favoritos.indexWhere((f) => f.id == fav.id);

    if (index >= 0) {
      favoritos.removeAt(index); // elimina si ya existe
    } else {
      favoritos.add(fav); // agrega si no existe
    }

    await FavoritosStorage.saveLista(FavoritosStorage.keyReclamos, favoritos);

    setState(() {
      esFavorito = index < 0;
    });
  }

  Future<void> obtenerFavoritos() async {
    final favoritos = await cargarDatosFacturas();
    setState(() {
      favReclamos = favoritos;
    });

    if (telefonoController.text.isNotEmpty) {
      verificarFavorito(telefonoController.text);
    }
  }

  Favorito verificarFavorito(String nisBuscado) {
    Favorito? encontrado = favReclamos.firstWhere(
      (fav) => fav.title == nisBuscado,
      orElse: () => Favorito(id: "nada", title: "nada"),
    );

    setState(() {
      esFavorito = !encontrado.title.contains("nada");
    });

    return encontrado;
  }

  // -------------------- RECUPERAR ÚLTIMO RECLAMO --------------------
  Future<void> recuperarUltimoReclamo(String telefono) async {
    if (telefono.length != 10) return;
    setState(() => isLoadingUltimosReclamos = true);
    CustomSnackbar.show(
      context,
      message: "Obteniendo último reclamo...",
      type: MessageType.info,
      duration: Durations.long4,
    );

    try {
      listaUltimosReclamos = await repoUltimosReclamos.getReclamoRecuperado(telefono);
      final datos = listaUltimosReclamos.respuesta?.datos?[0];
      if (datos != null) {
        showConfirmDialog(
          type: DialogType.info,
          context: context,
          message:
              "Con el teléfono ingresado se encontró:" +
              "\n\n✓ Teléfono: ${datos.telefono}" +
              "\n✓ Nombre y Apellido: ${datos.nombreApellido}" +
              "\n✓ NIS: ${datos.nis}" +
              "\n✓ Departamento: ${datos.departamentoNombre}" +
              "\n✓ Ciudad: ${datos.ciudadNombre}" +
              "\n✓ Barrio: ${datos.barrioNombre}" +
              "\n✓ Correo: ${datos.correo}" +
              "\n✓ Dirección: ${datos.direccion}" +
              "\n✓ Referencia: ${datos.referencia}" +
              "\n\nCargar reclamo con los datos obtenidos?",
          onConfirm: () async {
            if (datos == null) return;

            setState(() {
              nombreApellidoController.text = datos.nombreApellido ?? '';
              nisController.text = datos.nis.toString();
              correoController.text = datos.correo ?? '';
              direccionController.text = datos.direccion ?? '';
              referenciaController.text = datos.referencia ?? '';
            });

            selectedDept = listaDepartamentos.firstWhere(
              (d) => d.idDepartamento == datos.departamentoIdDepartamento,
            );

            if (selectedDept != null) {
              await _fetchCiudades(selectedDept!.idDepartamento);
              selectedCiudad = listaCiudades.firstWhere(
                (c) => c.idCiudad == datos.ciudadIdCiudad,
              );

              if (selectedCiudad != null) {
                await _fetchBarrios(selectedCiudad!.idCiudad);
                selectedBarrio = listaBarrios.firstWhere(
                  (b) => b.idBarrio == datos.barrioIdBarrio,
                );
              }
            }
            setState(() {});
          },
        );
      }
    } catch (e) {
      print("Error al cargar UltimosReclamos: $e");
    } finally {
      setState(() => isLoadingUltimosReclamos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Teléfono",
                    border: OutlineInputBorder(),
                  ),
                  validator: validators['telefono'],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final telefono = telefonoController.text;
                  if (telefono.isEmpty) return;

                  final favorito = Favorito(
                    id: telefono,
                    title: telefono,
                    tipo: FavoritoTipo.datosReclamo,
                    datos: obtenerDatosReclamo(),
                  );

                  await toggleFavoritoReclamo(favorito);
                  await obtenerFavoritos();
                },
                icon: Icon(
                  esFavorito ? Icons.star : Icons.star_border_sharp,
                  color: esFavorito ? Colors.amber : Colors.green,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownCustom<TipoReclamo>(
            label: "Tipo Reclamo",
            items: listaTipoReclamo,
            value: selectedTipoReclamo,
            displayBuilder: (b) => b.nombre!,
            validator: (val) => val == null ? "Seleccione un tipo Reclamo" : null,
            onChanged: (val) => setState(() => selectedTipoReclamo = val),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nisController,
            keyboardType: TextInputType.number,
            maxLength: 7,
            decoration: const InputDecoration(
              labelText: "NIS",
              border: OutlineInputBorder(),
            ),
            validator: validators['telefono'],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: nombreApellidoController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Nombre y Apellido",
              border: OutlineInputBorder(),
            ),
            validator: validators['nombreApellido'],
          ),
          const SizedBox(height: 20),
          DropdownCustom<Departamento>(
            label: "Departamento",
            items: listaDepartamentos,
            value: selectedDept,
            displayBuilder: (d) => d.nombre!,
            validator: (val) => val == null ? "Seleccione un Departamento" : null,
            onChanged: (val) {
              setState(() {
                selectedDept = val;
                selectedCiudad = null;
                selectedBarrio = null;
                listaCiudades = [];
                listaBarrios = [];
              });
              if (val != null) _fetchCiudades(val.idDepartamento);
            },
          ),
          const SizedBox(height: 20),
          DropdownCustom<Ciudad>(
            label: "Ciudad",
            items: listaCiudades,
            value: selectedCiudad,
            displayBuilder: (c) => c.nombre!,
            validator: (val) => val == null ? "Seleccione una ciudad" : null,
            onChanged: (val) {
              setState(() {
                selectedCiudad = val;
                selectedBarrio = null;
                listaBarrios = [];
              });
              if (val != null) _fetchBarrios(val.idCiudad);
            },
          ),
          const SizedBox(height: 20),
          DropdownCustom<Barrio>(
            label: "Barrio",
            items: listaBarrios,
            value: selectedBarrio,
            displayBuilder: (b) => b.nombre!,
            validator: (val) => val == null ? "Seleccione un barrio" : null,
            onChanged: (val) => setState(() => selectedBarrio = val),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: direccionController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Direccion",
              border: OutlineInputBorder(),
            ),
            validator: validators['direccion'],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Correo Electrónico",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if ((selectedTipoReclamo?.correoObligatorio ?? 'N') == 'S') {
                if (val == null || val.isEmpty) return "Ingrese Correo Electrónico";
                if (!emailRegex.hasMatch(val)) return "Ingrese formato de correo válido.";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: referenciaController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Referencia",
              border: OutlineInputBorder(),
            ),
            validator: validators['referencia'],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
