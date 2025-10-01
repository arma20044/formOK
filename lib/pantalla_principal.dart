import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/components/tab1OLD.dart';
import 'presentation/components/tab2OLD.dart';
import 'provider/FormProvider.dart';


class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onSubmit() {
    final formProvider = context.read<FormProvider>();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      formProvider.reset();
      _formKey.currentState?.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado con éxito ✅")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Revise los campos obligatorios")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, formProvider, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Formulario con Tabs"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Datos"),
              Tab(text: "Adjuntar"),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            controller: _tabController,
            children: const [
              Tab1Widget(),
              Tab2Widget(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: formProvider.todosValidos ? _onSubmit : null,
            child: const Text("Enviar"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
