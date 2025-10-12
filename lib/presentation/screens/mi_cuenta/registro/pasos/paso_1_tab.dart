import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';

import '../../../../../core/api/mi_ande_api.dart';
import '../../../../../infrastructure/infrastructure.dart';
import '../../../../../repositories/repositories.dart';

class Paso1Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?)? onTipoClienteChanged;

  const Paso1Tab({super.key, required this.formKey, this.onTipoClienteChanged});

  @override
  State<Paso1Tab> createState() => Paso1TabState();
}

final List<ModalModel> listaTipoTramite = dataTipoClienteArray;
final List<ModalModel> listaTipoSolicitante = dataTipoSolicitanteArray;
final List<ModalModel> listaTipoDocumento = dataTipoDocumentoArray;
final List<ModalModel> listaPais = dataPaisArray;

late ConsultaDocumentoResultado consultaDocumentoResponse;

bool isLoadingConsultaDocumento = false;
bool isLoadingDepartamentos = false;
bool isLoadingCiudades = false;

List<Departamento> listaDepartamentos = [];
List<Ciudad> listaCiudades = [];

class Paso1TabState extends State<Paso1Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic> getFormData() {
  return {
    "tipoTramite": selectedTipoTramite?.id,
    "tipoSolicitante": selectedTipoSolicitante?.id,
    "tipoDocumento": selectedTipoDocumento?.id,
    "numeroDocumento": numeroDocumentoController.text,
    "nombre": nombreObtenido,
    "apellido": apellidoObtenido,
    "pais": selectedPais?.descripcion,
    "departamento": selectedDept?.nombre,
    "ciudad": selectedCiudad?.nombre,
    "direccion": direccionController.text,
    "correo": correoController.text,
    "telefonoFijo": numeroTelefonoFijoController.text,
    "telefonoCelular": numeroTelefonoCelularController.text,
  };
}


  ModalModel? selectedTipoTramite;
  ModalModel? selectedTipoSolicitante;
  ModalModel? selectedTipoDocumento;
  ModalModel? selectedPais;
  Departamento? selectedDept;
  Ciudad? selectedCiudad;

  String nombreObtenido = "";
  String apellidoObtenido = "";

  List<Departamento> departamentos = [];
  List<Ciudad> ciudades = [];

  final TextEditingController numeroDocumentoController =
      TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController numeroTelefonoFijoController =
      TextEditingController();
  final TextEditingController numeroTelefonoCelularController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final repoConsultaDocumento = ConsultaDocumentoRepositoryImpl(
    ConsultaDocumentoDatasourceImpl(MiAndeApi()),
  );

  final repoDepartamento = DepartamentoRepositoryImpl(
    DepartamentoDatasourceImpl(MiAndeApi()),
  );

  final repoCiudad = CiudadRepositoryImpl(CiudadDatasourceImpl(MiAndeApi()));

  void consultarDocumento(String documento) async {
    setState(() => isLoadingConsultaDocumento = true);
    try {
      consultaDocumentoResponse = await repoConsultaDocumento
          .getConsultaDocumento(
            numeroDocumentoController.value.text,
            selectedTipoDocumento!.id ?? "",
          );

      setState(() {
        nombreObtenido = consultaDocumentoResponse.nombres;
        apellidoObtenido = consultaDocumentoResponse.apellido;
      });
    } catch (e) {
      print("Error al consultar Documento: $e");
    } finally {
      setState(() => isLoadingConsultaDocumento = false);
    }
  }

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

  Future<void> _fetchCiudades(num idDepartamento) async {
    setState(() => isLoadingCiudades = true);
    try {
      listaCiudades = await repoCiudad.getCiudad(idDepartamento);
    } catch (e) {
      print("Error al cargar ciudad: $e");
    } finally {
      setState(() => isLoadingCiudades = false);
    }
  }

  @override
  void initState() {
    super.initState();
    //_fetchDepartamentos();

    // Escuchamos cambios de foco
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Aquí el TextFormField perdió el foco
        //print('TextFormField perdió el foco');
        //print('Valor actual: ${numeroDocumentoController.text}');
        consultarDocumento(numeroDocumentoController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Información Personal",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownCustom<ModalModel>(
                label: "Tipo Trámite",
                items: listaTipoTramite,
                value: selectedTipoTramite,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Trámite" : null,
                onChanged: (val) => setState(() {selectedTipoTramite = val;
                      widget.onTipoClienteChanged?.call(val?.id);
                }
                ),
              ),
              const SizedBox(height: 20),
              DropdownCustom<ModalModel>(
                label: "Tipo Solicitante",
                items: listaTipoSolicitante,
                value: selectedTipoSolicitante,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Solicitante" : null,
                onChanged: (val) =>
                    setState(() => selectedTipoSolicitante = val),
              ),
              const SizedBox(height: 20),
              DropdownCustom<ModalModel>(
                label: "Tipo Documento",
                items: listaTipoDocumento,
                value: selectedTipoDocumento,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Documento" : null,
                onChanged: (val) => setState(() => selectedTipoDocumento = val),
              ),
              const SizedBox(height: 20),
              TextFormField(
                focusNode: _focusNode,
                controller: numeroDocumentoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de CI, RUC o Pasaporte",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  //if (selectedTipoReclamo?.nisObligatorio == 'S') {
                  if (val == null || val.isEmpty) {
                    return "Ingrese Número de CI, RUC o Pasaporte";
                  }
                  //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                  return null;
                  //}
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text("Nombre(s) o Razón Social"),
                    Text(nombreObtenido),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    isLoadingConsultaDocumento
                        ? CircularProgressIndicator()
                        : Text("Apellido(s)"),
                    Text(apellidoObtenido),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DropdownCustom<ModalModel>(
                label: "País",
                items: listaPais,
                value: selectedPais,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) => val == null ? "Seleccione un País" : null,
                onChanged: (val) => {
                  setState(() => selectedPais = val),

                  if (val?.descripcion?.compareTo("Paraguay") == 0)
                    {
                      selectedDept = null,
                      listaDepartamentos = [],
                      listaCiudades = [],
                      ciudades = [],
                      departamentos = [],
                      selectedCiudad = null,

                      _fetchDepartamentos(),
                    },

                  //if (val?.id != null && val?.descripcion?.compareTo("Paraguay") == 0) _fetchCiudades(val.id.toString())
                },
              ),
              const SizedBox(height: 20),
              selectedPais?.id == 'Paraguay'
                  ? Column(
                      children: [
                        IgnorePointer(
                          ignoring:
                              selectedPais?.descripcion?.compareTo(
                                    "Paraguay",
                                  ) ==
                                  0
                              ? false
                              : true,
                          child: DropdownCustom<Departamento>(
                            label: "Departamento",
                            items: listaDepartamentos,
                            value: selectedDept,
                            displayBuilder: (d) => d.nombre!,
                            validator: (val) => val == null
                                ? "Seleccione un Departamento"
                                : null,
                            onChanged: (val) {
                              setState(() {
                                selectedDept = val;
                                selectedCiudad = null;
                                ciudades = [];
                              });
                              if (val != null)
                                _fetchCiudades(val.idDepartamento);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : Text(""),

              selectedPais?.id == 'Paraguay'
                  ? Column(
                      children: [
                        DropdownCustom<Ciudad>(
                          label: "Ciudad",
                          items: listaCiudades,
                          value: selectedCiudad,
                          displayBuilder: (c) => c.nombre!,
                          validator: (val) =>
                              val == null ? "Seleccione una ciudad" : null,
                          onChanged: (val) {
                            setState(() {
                              selectedCiudad = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : Text(""),

              TextFormField(
                //focusNode: _focusNode,
                controller: direccionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Dirección",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  //if (selectedTipoReclamo?.nisObligatorio == 'S') {
                  if (val == null || val.isEmpty) {
                    return "Ingrese Dirección";
                  }
                  //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                  return null;
                  //}
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                //focusNode: _focusNode,
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  //if (selectedTipoReclamo?.nisObligatorio == 'S') {
                  if (val == null || val.isEmpty) {
                    return "Ingrese Correo";
                  }
                  //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                  return null;
                  //}
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                //focusNode: _focusNode,
                controller: numeroTelefonoFijoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Número de Teléfono Fijo",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  /*if (val == null || val.isEmpty) {
                    return "Ingrese Número Fijo";
                  }*/
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                //focusNode: _focusNode,
                controller: numeroTelefonoCelularController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Número Teléfono Celular",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Ingrese Número Teléfono Celular";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              InfoCardSimple(
                title: "Se utilizará para validar la cuenta vía SMS",
                subtitle: "",
                icon: Icons.info,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
