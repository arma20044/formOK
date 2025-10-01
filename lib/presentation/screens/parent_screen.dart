import 'package:flutter/material.dart';

import '../../core/validators/validators.dart';
import '../components/tab1.dart';
import '../components/tab2.dart';

class ParentScreen extends StatefulWidget {
  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<Tab1State> tab1Key = GlobalKey();
  final GlobalKey<Tab2State> tab2Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void limpiarTodo() {
    tab1Key.currentState?.limpiar();
    tab2Key.currentState?.limpiar();
  }

   bool validar() {
    return Validators.allValid([
      Validators.notNull(tab1Key.currentState?.selectedDept),
      Validators.notNull(tab1Key.currentState?.selectedCiudad),
      Validators.notNull(tab1Key.currentState?.selectedBarrio),
      Validators.notEmpty(tab1Key.currentState?.telefonoController.text),
      Validators.isNumeric(tab1Key.currentState?.telefonoController.text),
      Validators.notNull(tab2Key.currentState?.archivoSeleccionado)
    ]);
  }

  void _enviar() {
      
      bool esValido = validar();

      if(esValido){
        print('TODO bien');
      }
      else{
        print('falta algo');
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
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Tab1(key: tab1Key),
          Tab2(key: tab2Key),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _enviar(),
          child: const Text("Enviar Formulario"),
        ),
      ),
    );
  }
}
