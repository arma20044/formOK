import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/presentation/components/common/checkbox_group.dart';
import 'package:form/presentation/components/common/info_card.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:form/provider/theme_provider.dart';

class Paso4Tab extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const Paso4Tab({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<bool> _selected = [false, false, false];

    final themeState = ref.watch(themeNotifierProvider);

    final url = 'https://www.ande.gov.py/documentos/Terminos_y_Condiciones.pdf';

    final List<CustomCheckbox> checkboxes = [
      CustomCheckbox(
        fragments: [
          TextFragment(
            text: "Acepto envío de información al celular y correo electrónico",
          ),
        ],
      ),
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

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxGroup(checkboxes: checkboxes),
            InfoCardSimple(
              title: "",
              subtitle:
                  "La cuenta General estará activa, una vez que se verifique y valide los datos y archivos adjuntos.",
              color: Colors.blue,
              icon: Icons.info,
              
            ),
          ],
        ),
      ),
    );
  }
}
