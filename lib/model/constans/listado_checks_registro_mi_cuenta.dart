 import 'package:form/presentation/components/common/checkbox_group.dart';



 List<CustomCheckbox> checkboxesInicial(bool esComercial)  {
  
  return [
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