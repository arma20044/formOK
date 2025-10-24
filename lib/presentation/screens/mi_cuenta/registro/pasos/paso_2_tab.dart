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
  State<Paso2Tab> createState() => Paso2TabState();
}

final List<ModalModel> listaTipoVerificacion = dataTipoVerificacion;

class Paso2TabState extends State<Paso2Tab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool passwordInvisible = true;
  bool confirmarPasswordInvisible = true;

  ModalModel? selectedTipoVerificacion;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPassowordController =
      TextEditingController();

  Map<String, dynamic> getFormData() {
    return {
      "password": passwordController.text,
      "confirmarPassword": confirmarPassowordController.text,
      "tipoVerificacion": selectedTipoVerificacion?.id,
    };
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
              TituloSubtitulo(titulo: "Contraseña de Seguridad"),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: passwordInvisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordInvisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordInvisible = !passwordInvisible;
                      });
                    },
                  ),
                ),

                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmarPassowordController,
                obscureText: confirmarPasswordInvisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmarPasswordInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmarPasswordInvisible = !confirmarPasswordInvisible;
                      });
                    },
                  ),
                ),

                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 20),
              DropdownCustom<ModalModel>(
                label: "Tipo Trámite",
                items: listaTipoVerificacion,
                value: selectedTipoVerificacion,
                displayBuilder: (b) => b.descripcion!,
                validator: (val) =>
                    val == null ? "Seleccione un Tipo Verificación" : null,
                onChanged: (val) =>
                    setState(() => selectedTipoVerificacion = val),
              ),
              Visibility(
                visible: selectedTipoVerificacion != null,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    InfoCardSimple(
                      title:
                          selectedTipoVerificacion != null &&
                              selectedTipoVerificacion!.id != null &&
                              selectedTipoVerificacion!.id!.contains("CEL")
                          ? "Se utilizará para validar la cuenta vía SMS"
                          : "Se utilizará para validar la cuenta vía Correo",
                      subtitle: "",
                      icon: Icons.info,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              InfoCardSimple(
                title: infoTipoVerificacion,
                subtitle: "",
                color: Colors.blue,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
