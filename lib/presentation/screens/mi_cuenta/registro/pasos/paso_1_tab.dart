import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';

class Paso1Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso1Tab({super.key, required this.formKey});

  @override
  State<Paso1Tab> createState() => _Paso1TabState();
}

final List<ModalModel> listaTipoTramite = dataTipoClienteArray;
final List<ModalModel> listaTipoSolicitante = dataTipoSolicitanteArray;
final List<ModalModel> listaTipoDocumento = dataTipoDocumentoArray;

void consultarDocumento(String documento) {

  print(documento);


}

class _Paso1TabState extends State<Paso1Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ModalModel? selectedTipoTramite;
  ModalModel? selectedTipoSolicitante;
  ModalModel? selectedTipoDocumento;

  final TextEditingController numeroDocumentoController = TextEditingController();
    final FocusNode _focusNode = FocusNode();


    @override
  void initState() {
    super.initState();

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
    return Form(
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
              onChanged: (val) => setState(() => selectedTipoTramite = val),
            ),
            const SizedBox(height: 20),
            DropdownCustom<ModalModel>(
              label: "Tipo Solicitante",
              items: listaTipoSolicitante,
              value: selectedTipoSolicitante,
              displayBuilder: (b) => b.descripcion!,
              validator: (val) =>
                  val == null ? "Seleccione un Tipo Solicitante" : null,
              onChanged: (val) => setState(() => selectedTipoSolicitante = val),
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
                  if (val == null || val.isEmpty) return "Ingrese Número de CI, RUC o Pasaporte";
                  //if (!RegExp(r'^\d+$').hasMatch(val)) return "Solo números";
                  return null;
                //}
                
              },
             
            ),
            // Otros campos...
          ],
        ),
      ),
    );
  }
  
  
}
