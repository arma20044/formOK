import 'package:flutter/material.dart';

import '../../core/api/mi_ande_api.dart';
import '../../infrastructure/departamento_datasource_impl.dart';
import '../../model/departamento.dart';
import '../../repositories/departamento_repository_impl.dart';
import 'widgets/dropdown_custom.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  Tab1State createState() => Tab1State();
}

class Tab1State extends State<Tab1> {
  String? selectedDept;
  String? selectedCiudad;
  String? selectedBarrio;
  final TextEditingController telefonoController = TextEditingController();

  //List<String> departamentos = [];
  List<String> ciudades = [];
  List<String> barrios = [];

    final repoDepartamento = DepartamentoRepositoryImpl(DepartamentoDatasourceImpl(MiAndeApi()));

  @override
  void initState() {
    super.initState();
    _fetchDepartamentos();
  }

  /*Future<void> fetchDepartamentos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      departamentos = ["Depto 1", "Depto 2"];
    });
  }*/
  bool isLoadingDepartamentos = false;
  List<Departamento> listaDepartamentos = [];

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

  Future<void> fetchCiudades(String depto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      ciudades = depto == "Depto 1"
          ? ["Ciudad 1A", "Ciudad 1B"]
          : ["Ciudad 2A", "Ciudad 2B"];
    });
  }

  Future<void> fetchBarrios(String ciudad) async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      barrios = ciudad == "Ciudad 1A"
          ? ["Barrio 1A-1", "Barrio 1A-2"]
          : ciudad == "Ciudad 1B"
          ? ["Barrio 1B-1"]
          : ciudad == "Ciudad 2A"
          ? ["Barrio 2A-1"]
          : ["Barrio 2B-1", "Barrio 2B-2"];
    });
  }

  void limpiar() {
    setState(() {
      selectedDept = null;
      selectedCiudad = null;
      selectedBarrio = null;
      ciudades = [];
      barrios = [];
      telefonoController.clear();
    });
  }

  @override
  void dispose() {
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Número de teléfono",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El teléfono es obligatorio";
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return "Solo se permiten números";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownCustom(
              label: "Departamento",
              items: listaDepartamentos,
              value: selectedDept,
              onChanged: (val) {
                setState(() {
                  selectedDept = val;
                  selectedCiudad = null;
                  selectedBarrio = null;
                  ciudades = [];
                  barrios = [];
                });
                if (val != null) fetchCiudades(val);
              },
            ),
            const SizedBox(height: 20),
            DropdownCustom(
              label: "Ciudad",
              items: ciudades,
              value: selectedCiudad,
              onChanged: (val) {
                setState(() {
                  selectedCiudad = val;
                  selectedBarrio = null;
                  barrios = [];
                });
                if (val != null) fetchBarrios(val);
              },
            ),
            const SizedBox(height: 20),
            DropdownCustom(
              label: "Barrio",
              items: barrios,
              value: selectedBarrio,
              onChanged: (val) {
                setState(() {
                  selectedBarrio = val;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
