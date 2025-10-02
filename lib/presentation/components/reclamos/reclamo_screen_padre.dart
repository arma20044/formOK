import 'package:flutter/material.dart';
import 'package:form/presentation/components/reclamos/tabs_reclamos.dart';

class ReclamosScreen extends StatefulWidget {
  final String tipo; // "Caso1", "Caso2", etc.

  const ReclamosScreen({super.key, required this.tipo});

  @override
  State<ReclamosScreen> createState() => _ReclamosScreenState();
}

class _ReclamosScreenState extends State<ReclamosScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tab1Controller;
  late TextEditingController tab2Controller;
  late TextEditingController tab3Controller;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    tab1Controller = TextEditingController();
    tab2Controller = TextEditingController();
    tab3Controller = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tab1Controller.dispose();
    tab2Controller.dispose();
    tab3Controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes enviar todos los datos juntos
      print('Tab1: ${tab1Controller.text}');
      print('Tab2: ${tab2Controller.text}');
      print('Tab3: ${tab3Controller.text}');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Formulario enviado')));
      _formKey.currentState!.reset();
      tab1Controller.clear();
      tab2Controller.clear();
      tab3Controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamos - ${widget.tipo}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            Tab1(controller: tab1Controller),
            Tab2(controller: tab2Controller),
            Tab3(controller: tab3Controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.send),
      ),
    );
  }
}
