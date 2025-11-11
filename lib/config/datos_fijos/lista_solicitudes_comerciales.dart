import 'package:form/model/comercial/info_item_comercial_solicitud.dart';

final List<InfoItem> itemsSolicitudesComerciales = [
  InfoItem(
    title: "Fraccionamiento",
    description:
        "Solicitar Fraccionamiento de deuda.",
    buttonText: "Solicitar",
    necesitaAuth: true
  ),
  InfoItem(
    title: "Registro de número de Teléfono Celular",
    description:
        "Registre su número de Teléfono Celular y NIS para recibir notificaciones por SMS.",
    buttonText: "Registrar",
  ),
  InfoItem(
    title: "Solicitud de Factura Fija",
    description: "Abone un importe fijo mensual durante todo un año.",
    buttonText: "Solicitar",
  ),
  InfoItem(
    title: "Solicitud de Abastecimiento",
    description:
        "Solicitud para nueva conexión en Baja Tensión (hasta 40 kW). Solicitud para modificación de contrato para clientes con potencia reservada.",
    buttonText: "Solicitar",
  ),
];
