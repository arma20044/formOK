import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/model/constans/listado_checks_registro_mi_cuenta.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/common/checkbox_group.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';

import 'package:form/provider/terminos.dart' hide FormState;
import 'package:form/utils/utils.dart';

import '../../../../../core/api/mi_ande_api.dart';
import '../../../../../infrastructure/infrastructure.dart';
import '../../../../../repositories/repositories.dart';

class Paso1Tab extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?)? onTipoClienteChanged;

  const Paso1Tab({super.key, required this.formKey, this.onTipoClienteChanged});

  @override
  ConsumerState<Paso1Tab> createState() => Paso1TabState();
}

final List<ModalModel> listaTipoTramite = dataTipoClienteArray;
final List<ModalModel> listaTipoSolicitante = dataTipoSolicitanteArray;
final List<ModalModel> listaTipoDocumento = dataTipoDocumentoArray;
final List<ModalModel> listaPais = dataPaisArray;

late ConsultaDocumentoResultado consultaDocumentoResponse;

bool isLoadingConsultaDocumento = false;
bool isLoadingDepartamentos = false;
bool isLoadingCiudades = false;
bool isLoadingConsultaDocumentoRepresentante = false;

List<Departamento> listaDepartamentos = [];
List<Ciudad> listaCiudades = [];

// Este archivo debe estar accesible donde lo uses (ej: checkboxes_data.dart)

/*final Map<String, List<CustomCheckbox>> checkboxesBySelection = {
  '1': checkboxesInicial(true),
  '2': checkboxesInicial(false),
};*/

// 🔹 Checkboxes iniciales desmarcados
Map<String, List<CustomCheckbox>> checkboxesBySelection = {};

class Paso1TabState extends ConsumerState<Paso1Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic> getFormData() {
    return {
      "tipoCliente": selectedTipoTramite?.id,
      "tipoSolicitante": selectedTipoSolicitante?.id,
      "tipoDocumento": selectedTipoDocumento?.id,
      "numeroDocumento": numeroDocumentoController.text,
      "nombre": nombreObtenido.text,
      "apellido": apellidoObtenido.text,
      "pais": selectedPais?.descripcion,
      "departamento": selectedDept?.nombre,
      "ciudad": selectedCiudad?.nombre,
      "direccion": direccionController.text,
      "correo": correoController.text,
      "telefonoFijo": numeroTelefonoFijoController.text,
      "telefonoCelular": numeroTelefonoCelularController.text,
       "documentoRepresentante": documentoRepresentanteController.text,
    "nombreRepresentante": nombreRepresentanteObtenido.text,
    "apellidoRepresentante": apellidoRepresentanteObtenido.text,
    };
  }

  ModalModel? selectedTipoTramite;
  ModalModel? selectedTipoSolicitante;
  ModalModel? selectedTipoDocumento;
  ModalModel? selectedPais;
  Departamento? selectedDept;
  Ciudad? selectedCiudad;

  final TextEditingController nombreObtenido = TextEditingController();
  final TextEditingController apellidoObtenido = TextEditingController();

  final TextEditingController nombreRepresentanteObtenido =
      TextEditingController();
  final TextEditingController apellidoRepresentanteObtenido =
      TextEditingController();

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

  final TextEditingController documentoRepresentanteController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeTipoDocumento = FocusNode();
  final FocusNode _focusNodeNumeroDocumentoRepresentante = FocusNode();

  final _tipoDocumentoFieldKey = GlobalKey<FormFieldState<String>>();
  final _numeroDocumentoFieldKey = GlobalKey<FormFieldState<String>>();

  final repoConsultaDocumento = ConsultaDocumentoRepositoryImpl(
    ConsultaDocumentoDatasourceImpl(MiAndeApi()),
  );

  final repoDepartamento = DepartamentoRepositoryImpl(
    DepartamentoDatasourceImpl(MiAndeApi()),
  );

  final repoCiudad = CiudadRepositoryImpl(CiudadDatasourceImpl(MiAndeApi()));

  void consultarDocumento(String documento) async {
    setState(() {
      isLoadingConsultaDocumento = true;
      nombreObtenido.text = "";
      apellidoObtenido.text = "";
    });
    try {
      consultaDocumentoResponse = await repoConsultaDocumento
          .getConsultaDocumento(
            numeroDocumentoController.text,
            selectedTipoDocumento?.id ?? "",
          );

      setState(() {
        if (consultaDocumentoResponse.razonSocial != null) {
          nombreObtenido.text = consultaDocumentoResponse.razonSocial!;
          apellidoObtenido.text = consultaDocumentoResponse.razonSocial!;
        } else {
          nombreObtenido.text = consultaDocumentoResponse.nombres!;
          apellidoObtenido.text = consultaDocumentoResponse.apellido!;
        }
      });
    } catch (e) {
      print("Error al consultar Documento: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e", style: TextStyle(color: Colors.white)),
        ),
      );
      return;
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

  void consultarRepresentante(String cedulaRepresenante) async {
    setState(() {
      isLoadingConsultaDocumentoRepresentante = true;
      nombreRepresentanteObtenido.text = "";
      apellidoRepresentanteObtenido.text = "";
    });
    try {
      consultaDocumentoResponse = await repoConsultaDocumento
          .getConsultaDocumento(documentoRepresentanteController.text, 'TD001');

      setState(() {
        nombreRepresentanteObtenido.text = consultaDocumentoResponse.nombres!;
        apellidoRepresentanteObtenido.text =
            consultaDocumentoResponse.apellido!;
      });
    } catch (e) {
      print("Error al consultar Documento Representante: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e", style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      setState(() => isLoadingConsultaDocumentoRepresentante = false);
    }
  }

  // 🔹 Inicializar todo el formulario
  void resetForm() {
    setState(() {
      selectedTipoTramite = null;
      selectedTipoSolicitante = null;
      selectedTipoDocumento = null;
      selectedPais = null;
      selectedDept = null;
      selectedCiudad = null;

      numeroDocumentoController.clear();
      nombreObtenido.clear();
      apellidoObtenido.clear();
      correoController.clear();
      direccionController.clear();
      numeroTelefonoFijoController.clear();
      numeroTelefonoCelularController.clear();
      documentoRepresentanteController.clear();
      nombreRepresentanteObtenido.clear();
      apellidoRepresentanteObtenido.clear();

      // 🔹 Checkboxes desmarcados
      checkboxesBySelection = {
        '1': checkboxesInicial(true)
            .map((c) => CustomCheckbox(fragments: c.fragments, value: false))
            .toList(),
        '2': checkboxesInicial(false)
            .map((c) => CustomCheckbox(fragments: c.fragments, value: false))
            .toList(),
      };

      // 🔹 Inicializar provider si hay tipo seleccionado
      if (selectedTipoTramite != null) {
        final options = getFreshCheckboxes(selectedTipoTramite!.id!);
        ref
            .read(formProvider.notifier)
            .updateDropdown(selectedTipoTramite!.id!, options);
      }
    });
  }

  // 🔹 Obtener checkboxes frescos desmarcados
  List<CustomCheckbox> getFreshCheckboxes(String tipoId) {
    final base = checkboxesBySelection[tipoId] ?? [];
    return base
        .map((c) => CustomCheckbox(fragments: c.fragments, value: false))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    //_fetchDepartamentos();
    resetForm();
    Future(() {
      ref.read(formProvider.notifier).reset();
    });

    _focusNode.addListener(() {
      if (selectedTipoDocumento?.id == null) return;
      if (!_focusNode.hasFocus) {
        // 🔹 Esperar a que se estabilice el árbol de widgets
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final state = _numeroDocumentoFieldKey.currentState;
          if (state != null && state.mounted) {
            final isValid = state.validate();
            if (isValid) {
              // 🔹 Si pasa la validación, ejecutamos la lógica adicional
              //   await consultarDocumento();
              consultarDocumento(numeroDocumentoController.text);
            }
          }
        });
      }
    });

    _focusNodeTipoDocumento.addListener(() {
      if (!_focusNodeTipoDocumento.hasFocus) {
        Future.microtask(() {
          _numeroDocumentoFieldKey.currentState?.validate();
        });
      }
    });

    _focusNodeNumeroDocumentoRepresentante.addListener(() {
      if (!_focusNodeNumeroDocumentoRepresentante.hasFocus) {
        consultarRepresentante(documentoRepresentanteController.text);
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

              Consumer(
                builder: (context, ref, _) {
                  return DropdownCustom<ModalModel>(
                    label: "Tipo Trámite",
                    items: listaTipoTramite,
                    value: selectedTipoTramite,
                    displayBuilder: (b) => b.descripcion!,
                    validator: (val) =>
                        val == null ? "Seleccione un Tipo Trámite" : null,
                    onChanged: (val) {
                      setState(() {
                        selectedTipoTramite = val;
                      });

                      widget.onTipoClienteChanged?.call(val?.id);

                      if (val != null) {
                        final options = checkboxesBySelection[val.id] ?? [];
                        ref
                            .read(formProvider.notifier)
                            .updateDropdown(val.id!, options);
                      }
                    },
                  );
                },
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
                key: _tipoDocumentoFieldKey,
                focusNode: _focusNodeTipoDocumento,
                label: "Tipo Documento",
                items: listaTipoDocumento,
                value: selectedTipoDocumento,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Documento" : null,
                onChanged: (val) => {
                  setState(() {
                    selectedTipoDocumento = val;

                    // ✅ validar el campo número de documento justo después del cambio
                    Future.microtask(() {
                      _numeroDocumentoFieldKey.currentState?.validate();
                    });
                  }),
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: _numeroDocumentoFieldKey,
                focusNode: _focusNode,
                controller: numeroDocumentoController,
                //keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de CI, RUC o Pasaporte",
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Ingrese Número de CI, RUC o Pasaporte";
                  }

                  final tipo = selectedTipoDocumento!.id ?? '';

                  // C.I. Civil → solo números, entre 6 y 10 dígitos
                  if (tipo == 'TD001' &&
                      !RegExp(r'^[0-9]{6,10}$').hasMatch(val)) {
                    return "Éste campo debe contener solo números.";
                  }

                  // RUC → números, guion y dígito verificador
                  if (tipo == 'TD002' &&
                      !RegExp(r'^\d{6,12}-\d$').hasMatch(val)) {
                    return "Este campo debe tener formato de RUC";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              selectedTipoDocumento?.id == 'TD004'
                  ? (TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese Nombre(s) o Razón Social.";
                        }
                        return null;
                      },
                      controller: nombreObtenido,
                      decoration: const InputDecoration(
                        labelText: "Nombre(s) o Razón Social",
                        border: OutlineInputBorder(),
                      ),
                    ))
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text("Nombre(s) o Razón Social"),
                          isLoadingConsultaDocumento
                              ? loadingRow()
                              //: Text(nombreObtenido.text),
                              : TextFormField(
                                  enabled: false,
                                  initialValue: nombreObtenido.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Ingrese Nombre(s) o Razón Social.";
                                    }

                                    return null;
                                  },
                                ),
                        ],
                      ),
                    ),
              const SizedBox(height: 20),
              selectedTipoDocumento?.id == 'TD004'
                  ? (TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Apellido(s)",
                        border: OutlineInputBorder(),
                      ),
                    ))
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          isLoadingConsultaDocumento
                              ? loadingRow()
                              : Text("Apellido(s)"),

                          isLoadingConsultaDocumento
                              ? Text("")
                              //: Text(apellidoObtenido.text),
                              : TextFormField(
                                  enabled: false,
                                  initialValue: apellidoObtenido.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Ingrese Apellido(s)";
                                    }

                                    return null;
                                  },
                                ),
                        ],
                      ),
                    ),
              const SizedBox(height: 20),

              selectedTipoDocumento?.id != 'TD004' &&
                      selectedTipoSolicitante?.id?.contains('Entidad') == true
                  ? Column(
                      children: [
                        TextFormField(
                          focusNode: _focusNodeNumeroDocumentoRepresentante,
                          controller: documentoRepresentanteController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Número de CI del Representante",
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            //if (selectedTipoReclamo?.nisObligatorio == 'S') {
                            if (val == null || val.isEmpty) {
                              return "Ingrese Número de CI del Representante.";
                            }

                            return null;
                            //}
                          },
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              isLoadingConsultaDocumentoRepresentante
                                  ? loadingRow()
                                  : TextFormField(
                                      decoration: const InputDecoration(
                                        labelText:
                                            "Nombre(s) del Representante",
                                        border: OutlineInputBorder(),
                                      ),
                                      enabled: false,
                                      initialValue:
                                          nombreRepresentanteObtenido.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Ingrese Nombre(s) del Representante";
                                        }

                                        return null;
                                      },
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              isLoadingConsultaDocumentoRepresentante
                                  ? loadingRow()
                                  : TextFormField(
                                      decoration: const InputDecoration(
                                        labelText:
                                            "Apellido(s) del Representante",
                                        border: OutlineInputBorder(),
                                      ),
                                      enabled: false,
                                      initialValue:
                                          apellidoRepresentanteObtenido.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Ingrese Apellido(s) del Representante";
                                        }

                                        return null;
                                      },
                                    ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(""),

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

              Visibility(
                visible: selectedPais?.id == 'Paraguay',
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    IgnorePointer(
                      ignoring:
                          selectedPais?.descripcion?.compareTo("Paraguay") == 0
                          ? false
                          : true,
                      child: DropdownCustom<Departamento>(
                        label: "Departamento",
                        items: listaDepartamentos,
                        value: selectedDept,
                        displayBuilder: (d) => d.nombre!,
                        validator: (val) =>
                            val == null ? "Seleccione un Departamento" : null,
                        onChanged: (val) {
                          setState(() {
                            selectedDept = val;
                            selectedCiudad = null;
                            ciudades = [];
                          });
                          if (val != null) _fetchCiudades(val.idDepartamento);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

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
                // keyboardType: TextInputType.text,
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
                  if (!emailRegex.hasMatch(val))
                    return "Ingrese formato de correo válido.";
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
            ],
          ),
        ),
      ),
    );
  }
}
