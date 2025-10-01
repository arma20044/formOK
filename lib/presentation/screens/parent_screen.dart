import 'package:flutter/material.dart';

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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: limpiarTodo,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1(key: tab1Key),
          Tab2(key: tab2Key),
        ],
      ),
    );
  }
}
