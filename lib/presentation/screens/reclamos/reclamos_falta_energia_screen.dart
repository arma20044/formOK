import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/tab3.dart';

import '../../../core/api/mi_ande_api.dart';
import '../../../infrastructure/reclamo_datasource_impl.dart';
import '../../../model/archivo_adjunto_model.dart';
import '../../../model/model.dart';
import '../../../repositories/reclamo_repository_impl.dart';
import '../../components/components.dart';
import '../../forms/FormWrapper.dart';

class ReclamosScreen extends StatefulWidget {
  const ReclamosScreen({
    super.key,
    required this.tipoReclamo,
    //required String tipo
  });
  final String tipoReclamo; // FE, CO, AP

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ReclamosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<GlobalKey<FormState>> _formKeys = List.generate(
    3,
    (_) => GlobalKey<FormState>(),
  );

  final GlobalKey<Tab1State> tab1Key = GlobalKey();

  ArchivoAdjunto? _archivo;

  final repoReclamo = ReclamoRepositoryImpl(ReclamoDatasourceImpl(MiAndeApi()));
  bool _isLoadingReclamo = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void limpiarTodo() {
    //formKey.currentState?.reset();
    tab1Key.currentState?.limpiar();
    //tab2Key.currentState?.limpiar();
  }

  void enviarFormulario() async {
    //validar adjuntos si es el caso
    if (tab1Key.currentState?.selectedTipoReclamo?.adjuntoObligatorio == 'S') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Es necesario anexar foto o video.")),
      );
      return;
    }

    
      final isValid = _formKeys[0].currentState?.validate() ?? false;
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              //"Complete todos los campos obligatorios del paso ${i + 1}",
              "Complete todos los campos obligatorios del paso 1",
            ),
          ),
        );
        return;
      }
    

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
        String mensajeExitoso =
            'Reclamo creado correctamente. Reclamo Nro.: ${result.reclamo?.numeroReclamo}';

        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text(mensajeExitoso),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                _copyTextToClipboard(mensajeExitoso);
              },
              child: const Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  // Envía los datos

  void _copyTextToClipboard(String textToCopy) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    // Optionally, show a confirmation message to the user, like a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto copiado exitosamente!')),
    );
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
          title: const Text("Reclamos por Falta de Energía"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "DATOS"),
              Tab(text: "ADJUNTOS"),
              Tab(text: "MAPA"),
            ],
          ),
          /* actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: limpiarTodo),
          ], */
        ),
        body: SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Tab1(
                key: tab1Key,
                tipoReclamo: widget.tipoReclamo,
                formKey: _formKeys[0],
              ),
              Tab2(
                onSaved: (newValue) => {_archivo = newValue},

                validator: (archivo) {
                  if (archivo == null) return 'Debe adjuntar un archivo';
                  if (archivo.file.lengthSync() > 5 * 1024 * 1024) {
                    return 'El archivo no debe superar los 5 MB';
                  }
                  return null;
                },
              ),
              Tab3(
                lat: _lat,
                lng: _lng,
                onLocationSelected: _setLocation,
                formKey: _formKeys[2],
              ),
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
