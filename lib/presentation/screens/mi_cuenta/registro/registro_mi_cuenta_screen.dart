import 'package:flutter/material.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

import 'package:form/presentation/forms/FormWrapper.dart';


import 'registro.dart';


class RegistroMiCuentaScreen extends StatefulWidget {
  const RegistroMiCuentaScreen({super.key});

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<RegistroMiCuentaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final GlobalKey<Tab1State> tab1Key = GlobalKey();
  //final GlobalKey<MediaPickerState> tab2Key = GlobalKey();

  //ArchivoAdjunto? _archivo;

  //final repoReclamo = ReclamoRepositoryImpl(ReclamoDatasourceImpl(MiAndeApi()));
  bool _isLoadingReclamo = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void limpiarTodo() {
    //formKey.currentState?.reset();
   // tab1Key.currentState?.limpiar();
   // tab2Key.currentState?.limpiar();
  }

  void enviarFormulario() async {
    print(formKey);

    //validar adjuntos si es el caso
    /*if (tab1Key.currentState?.selectedTipoReclamo?.adjuntoObligatorio == 'S') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Es necesario anexar foto o video.")),
      );
      return;
    }*/

    final isValid = formKey.currentState?.validate() ?? false;
    // Envía los datos
    /*
    if (isValid) {
      ReclamoResponse result = await _fetchReclamo();
      if (!mounted) return;
      if (result.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.errorValList![0])));
        return;
      }

      limpiarTodo();
      //ScaffoldMessenger.of(context).showSnackBar(
      // const SnackBar(content: Text("Formulario enviado correctamente!")),
      //);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result.mensaje!.split('<h1>')[0]),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Cerrar el diálogo y devolver 'false' (cancelar)
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Cerrar el diálogo y devolver 'true' (confirmar)
                  Navigator.of(context).pop(true);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos obligatorios")),
      );
    }*/
  }
/*
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
        _lat,
        _lng,
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
*/
  double? _lat;
  double? _lng;

  void _setLocation(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //theme: ThemeProvider().themeData,
      body: Scaffold(
        endDrawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text("Mi Cuenta - Registrate"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Paso 1"),
              Tab(text: "Paso 2"),
              Tab(text: "Paso 3"),
              Tab(text: "Paso 4"),
            ],
          ),
          /* actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: limpiarTodo),
          ], */
        ),
        body: FormWrapper(
          formKey: formKey,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
             Paso1Tab(),
             Paso2Tab(),
             Paso3Tab(),
             Paso4Tab(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoadingReclamo ? null : enviarFormulario,
            child: _isLoadingReclamo
                ? const SizedBox(child: CircularProgressIndicator())
                : Text("Enviar Reclamo"),
          ),
        ),
      ),
    );
  }
}
