import 'package:flutter/material.dart';

import '../../core/api/mi_ande_api.dart';
import '../../core/validators/validators.dart';
import '../../infrastructure/infrastructure.dart';
import '../../model/model.dart';
import '../../repositories/repositories.dart';
import 'widgets/dropdown_custom.dart';



class Tab1 extends StatefulWidget {
  const Tab1({super.key});
  @override
  Tab1State createState() => Tab1State();
}

class Tab1State extends State<Tab1> {

  Departamento? selectedDept;
  Ciudad? selectedCiudad;
  Barrio? selectedBarrio;

  final TextEditingController telefonoController = TextEditingController();

    final repoDepartamento = DepartamentoRepositoryImpl(
    DepartamentoDatasourceImpl(MiAndeApi()),
  );
  final repoCiudad = CiudadRepositoryImpl(
    CiudadDatasourceImpl(MiAndeApi()),
  );
  final repoBarrio = BarrioRepositoryImpl(
    BarrioDatasourceImpl(MiAndeApi()),
  );

  List<Departamento> departamentos = [];
  List<Ciudad> ciudades = [];
  List<Barrio> barrios = [];

   bool isLoadingDepartamentos = false;
  bool isLoadingCiudades = false;
  bool isLoadingBarrios = false;

  List<Departamento> listaDepartamentos = [];
  List<Ciudad> listaCiudades = [];
  List<Barrio> listaBarrios = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartamentos();
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

 

  void limpiar() {
    setState(() {
      selectedDept = null;
      selectedCiudad = null;
      selectedBarrio = null;
      //listaDepartamentos = [];
      listaCiudades = [];
      listaBarrios = [];
      ciudades = [];
      barrios = [];
      telefonoController.clear();

      
        
        
        
        
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          DropdownCustom<Departamento>(
            label: "Departamento",
            items: listaDepartamentos,
            value: selectedDept,
            displayBuilder: (d) => d.nombre!,
            validator: (val) => val == null ? "Seleccione un departamento" : null,
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
        ],
      ),
    );
  }
}
