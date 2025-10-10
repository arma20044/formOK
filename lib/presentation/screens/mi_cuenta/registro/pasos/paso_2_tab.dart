import 'package:flutter/material.dart';
import 'package:form/config/constantes.dart';
import 'package:form/config/tipo_tramite_model.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/presentation/components/common/titulo_custom.dart';
import 'package:form/presentation/components/widgets/dropdown_custom.dart';

class Paso2Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Paso2Tab({super.key, required this.formKey});

  @override
  State<Paso2Tab> createState() => _Paso2TabState();
}

final List<ModalModel> listaTipoVerificacion = dataTipoVerificacion;

class _Paso2TabState extends State<Paso2Tab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool passwordVisible = false;
  bool confirmarPasswordVisible = false;

    ModalModel? selectedTipoVerificacion;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TituloSubtitulo(titulo: "Contraseña de Seguridad"),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: passwordVisible,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),

              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: confirmarPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    confirmarPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      confirmarPasswordVisible = !confirmarPasswordVisible;
                    });
                  },
                ),
              ),

              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 20),
             DropdownCustom<ModalModel>(
                label: "Tipo Trámite",
                items: listaTipoVerificacion,
                value: selectedTipoVerificacion,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Verificación" : null,
                onChanged: (val) => setState(() => selectedTipoVerificacion = val),
              ),
               const SizedBox(height: 10),
              InfoCardSimple(title: infoTipoVerificacion, subtitle: "",  color: Colors.blue , size: 13,)
          ],
        ),
      ),
    );
  }
}
