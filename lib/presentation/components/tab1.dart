

import 'package:flutter/material.dart';

import '../../core/api/mi_ande_api.dart';
import '../../core/validators/validators.dart';
import '../../infrastructure/infrastructure.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import '../../repositories/tipo_reclamo_repository_impl.dart';
import 'widgets/dropdown_custom.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});
  @override
  Tab1State createState() => Tab1State();
}

class Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin{

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

  final repoDepartamento = DepartamentoRepositoryImpl(
    DepartamentoDatasourceImpl(MiAndeApi()),
  );
  final repoCiudad = CiudadRepositoryImpl(CiudadDatasourceImpl(MiAndeApi()));
  final repoBarrio = BarrioRepositoryImpl(BarrioDatasourceImpl(MiAndeApi()));
  final repoTipoReclamo = TipoReclamoRepositoryImpl(
    TipoReclamoDatasourceImpl(),
  );

  List<Departamento> departamentos = [];
  List<Ciudad> ciudades = [];
  List<Barrio> barrios = [];

  bool isLoadingDepartamentos = false;
  bool isLoadingCiudades = false;
  bool isLoadingBarrios = false;
  bool isLoadingTipoReclamo = false;

  List<Departamento> listaDepartamentos = [];
  List<Ciudad> listaCiudades = [];
  List<Barrio> listaBarrios = [];
  List<TipoReclamo> listaTipoReclamo = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartamentos();
    _fetchTipoReclamo();
  }

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
      listaTipoReclamo = await repoTipoReclamo.getTipoReclamo();
    } catch (e) {
      print("Error al cargar tipo reclamo: $e");
    } finally {
      setState(() => isLoadingTipoReclamo = false);
    }
  }

  void limpiar() {
    setState(() {
      selectedDept = null;
      selectedCiudad = null;
      selectedBarrio = null;
      selectedTipoReclamo = null;
      // listaDepartamentos = [];
      listaCiudades = [];
      listaBarrios = [];
      ciudades = [];
      barrios = [];
      // listaTipoReclamo = [];
      telefonoController.clear();
      nisController.clear();
      nombreApellidoController.clear();
      direccionController.clear();
      correoController.clear();
      referenciaController.clear();

    });
  }

  bool validar() {
    return Validators.allValid([
      Validators.notNull(listaDepartamentos),
      Validators.notNull(listaCiudades),
      Validators.notNull(listaBarrios),
      Validators.notEmpty(telefonoController.text),
      Validators.isNumeric(telefonoController.text),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          //TELEFONO
          TextFormField(
            controller: telefonoController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Teléfono",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return "Ingrese un teléfono";
              if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
          const SizedBox(height: 20),
          //NIS
          TextFormField(
            controller: nisController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "NIS",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return "Ingrese NIS";
              if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
          const SizedBox(height: 20),
          //NOMBRE Y APELLIDO
          TextFormField(
            controller: nombreApellidoController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Nombre y Apellido",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty)
                return "Ingrese Nombre y Apellido";
              //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownCustom<Departamento>(
            label: "Departamento",
            items: listaDepartamentos,
            value: selectedDept,
            displayBuilder: (d) => d.nombre!,
            validator: (val) =>
                val == null ? "Seleccione un departamento" : null,
            onChanged: (val) {
              setState(() {
                selectedDept = val;
                selectedCiudad = null;
                selectedBarrio = null;
                ciudades = [];
                barrios = [];
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
                barrios = [];
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
          //DIRECCION
          TextFormField(
            controller: direccionController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Direccion",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return "Ingrese Dirección";
              //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
           const SizedBox(height: 20),
          //CORREO
          TextFormField(
            controller: correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Correo",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return "Ingrese Correo";
              //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
           const SizedBox(height: 20),
          //REFERENCIA
          TextFormField(
            controller: referenciaController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Referencia",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return "Ingrese Referencia";
              //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
              return null;
            },
          ),
           const SizedBox(height: 20),
          DropdownCustom<TipoReclamo>(
            label: "Tipo Reclamo",
            items: listaTipoReclamo,
            value: selectedTipoReclamo,
            displayBuilder: (b) => b.nombre!,
            validator: (val) =>
                val == null ? "Seleccione un tipo Reclamo" : null,
            onChanged: (val) => setState(() => selectedTipoReclamo = val),
          ),
        ],
      ),
    );
  }
}
