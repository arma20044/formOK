import 'package:flutter/material.dart';

import '../components/components.dart';
import '../forms/FormWrapper.dart';

class ParentScreen extends StatefulWidget {
  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<Tab1State> tab1Key = GlobalKey();
  final GlobalKey<Tab2State> tab2Key = GlobalKey();

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

  void enviarFormulario() {
    print(formKey);
    if (formKey.currentState!.validate() &&
        tab1Key.currentState!.validar() //&&
        //tab2Key.currentState?.validar()
        ) {
      // Envía los datos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado correctamente!")),
      );
      limpiarTodo();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos obligatorios")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario con Tabs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Ubicación"), Tab(text: "Archivo")],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: limpiarTodo,
          ),
        ],
      ),
      body: FormWrapper(
        formKey: formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            Tab1(key: tab1Key),
            Tab2(key: tab2Key),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: enviarFormulario,
          child: const Text("Enviar Formulario"),
        ),
      ),
    );
  }
}
