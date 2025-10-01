import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../core/api/mi_ande_api.dart';
import '../../infrastructure/reclamo_datasource_impl.dart';
import '../../model/archivo_adjunto_model.dart';
import '../../model/model.dart';
import '../../repositories/reclamo_repository_impl.dart';
import '../components/components.dart';
import '../forms/FormWrapper.dart';

class ParentScreen extends StatefulWidget {
  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<Tab1State> tab1Key = GlobalKey();
  final GlobalKey<MediaPickerState> tab2Key = GlobalKey();

  ArchivoAdjunto? _archivo;

  final repoReclamo = ReclamoRepositoryImpl(ReclamoDatasourceImpl(MiAndeApi()));
  bool _isLoadingReclamo = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void limpiarTodo() {
    //formKey.currentState?.reset();
    tab1Key.currentState?.limpiar();
    tab2Key.currentState?.limpiar();
  }

  void enviarFormulario() async {
    print(formKey);
    final isValid = formKey.currentState?.validate() ?? false;
    // Envía los datos
    if (isValid) {
      await _fetchReclamo();
      limpiarTodo();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado correctamente!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos obligatorios")),
      );
    }
  }

  Future<ReclamoResponse> _fetchReclamo() async {
    try {
      setState(() {
        _isLoadingReclamo = true; // ← mostrar spinner
      });
      final reclamoResponse = await repoReclamo.getReclamo(
        tab1Key.currentState!.telefonoController.text,
        tab1Key.currentState!.selectedTipoReclamo!.idTipoReclamoCliente,
        tab1Key.currentState!.nisController.text,
        tab1Key.currentState!.nombreApellidoController.text,

        tab1Key.currentState!.selectedDept!.idDepartamento,
        tab1Key.currentState!.selectedCiudad!.idCiudad,
        tab1Key.currentState!.selectedBarrio!.idBarrio,

        tab1Key.currentState!.direccionController.text,
        tab1Key.currentState!.correoController.text,
        tab1Key.currentState!.referenciaController.text,

        _archivo,
        tab1Key.currentState!.selectedTipoReclamo!.adjuntoObligatorio,

        20,
        20,
      );

      print(reclamoResponse);
      return reclamoResponse;
    } catch (e) {
      throw Exception();
    } finally {
      setState(() {
        _isLoadingReclamo = false; // ← mostrar spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario con Tabs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Ubicación"),
            Tab(text: "Archivo"),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: limpiarTodo),
        ],
      ),
      body: FormWrapper(
        formKey: formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            Tab1(key: tab1Key),
            Tab2(key: tab2Key, onSaved: (newValue) => {_archivo = newValue}),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: enviarFormulario,
          child: const Text("Enviar Reclamo"),
        ),
      ),
    );
  }
}
