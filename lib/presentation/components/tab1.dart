import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/UI/custom_dialog.dart';
import 'package:form/presentation/components/common/UI/custom_dialog_confirm.dart';
import 'package:form/utils/utils.dart';

import '../../core/api/mi_ande_api.dart';
import '../../core/validators/validators.dart';
import '../../infrastructure/infrastructure.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import '../../repositories/tipo_reclamo_repository_impl.dart';
import 'widgets/dropdown_custom.dart';

class Tab1 extends StatefulWidget {
  //final GlobalKey<FormState> formKey;

  final String tipoReclamo; // FE, CO, AP

  const Tab1({super.key, required this.tipoReclamo});

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
  final TextEditingController nombreApellidoController =
      TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController referenciaController = TextEditingController();

  final repoDepartamento = DepartamentoRepositoryImpl(
    DepartamentoDatasourceImpl(MiAndeApi()),
  );
  final repoCiudad = CiudadRepositoryImpl(CiudadDatasourceImpl(MiAndeApi()));
  final repoBarrio = BarrioRepositoryImpl(BarrioDatasourceImpl(MiAndeApi()));
  final repoTipoReclamo = TipoReclamoRepositoryImpl(
    TipoReclamoDatasourceImpl(MiAndeApi()),
  );
  final repoUltimosReclamos = ReclamoRecuperadoRepositoryImpl(
    ReclamoRecuperadoDatasourceImpl(MiAndeApi()),
  );

  List<Departamento> departamentos = [];
  List<Ciudad> ciudades = [];
  List<Barrio> barrios = [];

  bool isLoadingDepartamentos = false;
  bool isLoadingCiudades = false;
  bool isLoadingBarrios = false;
  bool isLoadingTipoReclamo = false;

  bool isLoadingUltimosReclamos = false;

  List<Departamento> listaDepartamentos = [];
  List<Ciudad> listaCiudades = [];
  List<Barrio> listaBarrios = [];
  List<TipoReclamo> listaTipoReclamo = [];

  late ReclamoRecuperadoResponse listaUltimosReclamos;

  late Map<String, String? Function(String?)> validators;

  @override
  void initState() {
    super.initState();
    _fetchDepartamentos();
    _fetchTipoReclamo();

    validators = {
      //VALIDA PARA TODOS
      'direccion': (val) {
        if (val == null || val.isEmpty) return "Ingrese una Dirección";
        return null;
      },

      //SOLO FALTA DE ENERGIA FE
      'telefono': (val) {
        if ((selectedTipoReclamo!.nisObligatorio == 'S') &&
            (val == null || val.isEmpty)) {
          return "Ingrese un teléfono";
        }
        if (!RegExp(r'^\d+$').hasMatch(val!)) return "Solo números";
        return null;
      },
      'referencia': (val) {
        // solo obligatorio si tipoReclamo es "FE"
        if (widget.tipoReclamo != "CX" && (val == null || val.isEmpty)) {
          return "Ingrese Referencia";
        }
        return null;
      },

      //SOLO ALUMBRADO PUBLIC AP
      'nombreApellido': (val) {
        // solo obligatorio si tipoReclamo es "CO"
        if ((widget.tipoReclamo == "FE" ||
                widget.tipoReclamo == "CO" ||
                widget.tipoReclamo == "AP") &&
            (val == null || val.isEmpty)) {
          return "Ingrese Nombre y Apellido";
        }
        return null;
      },

      // más campos condicionales según tipoReclamo...
    };
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
      listaTipoReclamo = await repoTipoReclamo.getTipoReclamo(
        widget.tipoReclamo,
      );
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

  Future<void> recuperarUltimoReclamo(String telefono) async {
    if (telefono.length != 10) return;
    setState(() => isLoadingUltimosReclamos = true);
    try {
      listaUltimosReclamos = await repoUltimosReclamos.getReclamoRecuperado(
        telefonoController.text,
      );
final datos = listaUltimosReclamos.respuesta?.datos?[0];

if (datos != null) {
      showConfirmDialog(
        type: DialogType.info,
        context: context,
        message:
            "Con el teléfono ingresado se encontró:" +
            "\n"
            "\n✓ Teléfono:${listaUltimosReclamos.respuesta!.datos![0]!.telefono.toString()}" +
            "\n✓ Nombre y Apellido:${listaUltimosReclamos.respuesta!.datos![0]!.nombreApellido.toString()}" +
            "\n✓ NIS:${listaUltimosReclamos.respuesta!.datos![0]!.nis.toString()}" +
            "\n✓ Departamento:${listaUltimosReclamos.respuesta!.datos![0]!.departamentoNombre.toString()}" +
            "\n✓ Ciudad:${listaUltimosReclamos.respuesta!.datos![0]!.ciudadNombre.toString()}" +
            "\n✓ Barrio:${listaUltimosReclamos.respuesta!.datos![0]!.barrioNombre.toString()}" +
            "\n✓ Correo:${listaUltimosReclamos.respuesta!.datos![0]!.correo.toString()}" +
            "\n✓ Dirección:${listaUltimosReclamos.respuesta!.datos![0]!.direccion.toString()}" +
            "\n✓ Referencia:${listaUltimosReclamos.respuesta!.datos![0]!.referencia.toString()}" +
            "\n" +
            "" +
            "" +
            "\nCargar reclamo con los datos obtenidos?",
      onConfirm: () async {
  final datos = listaUltimosReclamos.respuesta?.datos?[0];
  if (datos == null) return;

  setState(() {
    telefonoController.text = formatTelefono(datos.telefono!) ?? '';
    nombreApellidoController.text = datos.nombreApellido ?? '';
    nisController.text = datos.nis.toString() ?? '';
    correoController.text = datos.correo ?? '';
    direccionController.text = datos.direccion ?? '';
    referenciaController.text = datos.referencia ?? '';
  });

  // Seleccionar departamento
  selectedDept = listaDepartamentos.firstWhere(
    (d) => d.idDepartamento == datos.departamentoIdDepartamento,
   // orElse: () => null,
  );

  if (selectedDept != null) {
    // Cargar ciudades del departamento seleccionado
    await _fetchCiudades(selectedDept!.idDepartamento);

    // Seleccionar ciudad
    selectedCiudad = listaCiudades.firstWhere(
      (c) => c.idCiudad == datos.ciudadIdCiudad,
      //orElse: () => null,
    );

    if (selectedCiudad != null) {
      // Cargar barrios de la ciudad seleccionada
      await _fetchBarrios(selectedCiudad!.idCiudad);

      // Seleccionar barrio
      selectedBarrio = listaBarrios.firstWhere(
        (b) => b.idBarrio == datos.barrioIdBarrio,
       // orElse: () => null,
      );
    }
  }

  setState(() {}); // Actualiza la UI con los valores cargados
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
          //TELEFONO
          TextFormField(
            onChanged: (value) {
              print("Hola $value");
              recuperarUltimoReclamo(value);
            },
            controller: telefonoController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Teléfono",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (selectedTipoReclamo?.nisObligatorio == 'S') {
                if (val == null || val.isEmpty) return "Ingrese un teléfono";
                if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                return null;
              }
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
          const SizedBox(height: 20),
          //NIS
          TextFormField(
            controller: nisController,
            keyboardType: TextInputType.number,
            maxLength: 7,
            decoration: const InputDecoration(
              labelText: "NIS",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (selectedTipoReclamo?.nisObligatorio == 'S') {
                if (val == null || val.isEmpty) return "Ingrese NIS";
                if (val.length != 7) return "NIS debe ser de 7 dígitos";
                if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                return null;
              }
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
            // validator: (val) {
            //   if (val == null || val.isEmpty)
            //     return "Ingrese Nombre y Apellido";

            //   return null;
            // },
            validator: validators['nombreApellido'],
          ),
          const SizedBox(height: 20),
          DropdownCustom<Departamento>(
            label: "Departamento",
            items: listaDepartamentos,
            value: selectedDept,
            displayBuilder: (d) => d.nombre!,
            validator: (val) =>
                val == null ? "Seleccione un Departamento" : null,
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
              labelText: "Correo Electrónico",
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (selectedTipoReclamo?.correoObligatorio == 'S') {
                if (val == null || val.isEmpty)
                  return "Ingrese Correo Electrónico";
                if (!emailRegex.hasMatch(val))
                  return "Ingrese formato de correo válido.";

                return null;
              }
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
            validator: validators['referencia'],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
