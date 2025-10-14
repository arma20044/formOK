import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/checkbox_group.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';

class Paso4Tab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String tipoTramite; // '1' = Comercial, otros = no Comercial

  const Paso4Tab({
    super.key,
    required this.formKey,
    required this.tipoTramite,
  });

  @override
  Paso4TabState createState() => Paso4TabState();
}

class Paso4TabState extends State<Paso4Tab> {
  late List<CustomCheckbox> checkboxes;

  @override
  void initState() {
    super.initState();

    final esComercial = widget.tipoTramite == "1";

    checkboxes = [
      CustomCheckbox(
        fragments: [
          TextFragment(
            text: "Acepto envío de información al celular y correo electrónico",
          ),
        ],
      ),
      if (esComercial)
        CustomCheckbox(
          fragments: [
            TextFragment(text: "Acepto los "),
            TextFragment(
              text: "Términos y Condiciones Comerciales",
              url:
                  "https://www.ande.gov.py/documentos/Terminos_y_Condiciones.pdf",
            ),
          ],
        ),
      CustomCheckbox(
        fragments: [
          TextFragment(text: "Declaro conocer la: \n"),
          TextFragment(
            text: "-Ley de Comercio Electrónico N° 4868/13 \n",
            url:
                "https://www.ande.gov.py/documentos/Ley_4868_13_Comercio_Electronico.pdf",
          ),
          TextFragment(
            text: "-Ley de Defensa al Consumidor N°1334/98 \n",
            url:
                "https://www.ande.gov.py/documentos/Ley_1334_98_Defensa_del_Consumidor.pdf",
          ),
          TextFragment(
            text: "-Ley de la Firma Electrónica N° 4017/10",
            url:
                "https://www.ande.gov.py/documentos/Ley_4017_10_Firma_Electronica.pdf",
          ),
        ],
      ),
      CustomCheckbox(
        fragments: [
          TextFragment(text: "Acepto la "),
          TextFragment(
            text: "Política de Privacidad",
            url:
                "https://www.ande.gov.py/documentos/Politica_de_Privacidad.pdf",
          ),
        ],
      ),
      CustomCheckbox(
        fragments: [
          TextFragment(text: "Acepto los "),
          TextFragment(
            text: "Términos y Condiciones",
            url:
                "https://www.ande.gov.py/documentos/TERMINOS_CONDICIONES_REGISTRO_CIUDADANO.pdf",
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('${widget.tipoTramite} asd'),
              CheckboxGroup(
                checkboxes: checkboxes,
                onChanged: (updatedList) {
                  setState(() {
                    checkboxes = updatedList;
                  });
                },
              ),
              const SizedBox(height: 16),
              const InfoCardSimple(
                title: "",
                subtitle:
                    "La cuenta General estará activa, una vez que se verifique y valide los datos y archivos adjuntos.",
                color: Colors.blue,
                icon: Icons.info,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validar checkboxes según el tipo de cliente
  bool validateCheckboxes() {
    final esComercial = widget.tipoTramite == "1";

    for (int i = 0; i < checkboxes.length; i++) {
      // Ignorar el 2do checkbox si no es comercial
      if (i == 1 && !esComercial) continue;

      if (!checkboxes[i].value) return false;
    }
    return true;
  }
}
