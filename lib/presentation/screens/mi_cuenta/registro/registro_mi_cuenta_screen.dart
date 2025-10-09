import 'package:flutter/material.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

import 'registro.dart';




class RegistroMiCuentaScreen extends StatefulWidget {
  const RegistroMiCuentaScreen({super.key});

  @override
  State<RegistroMiCuentaScreen> createState() => _RegistroMiCuentaScreenState();
}

class _RegistroMiCuentaScreenState extends State<RegistroMiCuentaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoadingReclamo = false;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void enviarFormulario() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos obligatorios")),
      );
      return;
    }

    setState(() => _isLoadingReclamo = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulación de envío

    setState(() => _isLoadingReclamo = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Formulario enviado correctamente")),
    );
  }

  void _setLocation(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: RegistroAppBar(controller: _tabController),
      body: RegistroFormWrapper(
        formKey: formKey,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            Paso1Tab(),
            Paso2Tab(),
            Paso3Tab(),
            Paso4Tab(),
          ],
        ),
      ),
      bottomNavigationBar: RegistroBottomButton(
        isLoading: _isLoadingReclamo,
        onPressed: enviarFormulario,
      ),
    );
  }
}
