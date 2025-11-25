import 'package:form/model/comercial/info_item_comercial_solicitud.dart';

final List<InfoItem> itemsSolicitudesComerciales = [
  InfoItem(
    title: "Tú Fraccionamiento",
    description: "Solicitar Tú Fraccionamiento de deuda.",
    buttonText: "Solicitar",
    necesitaAuth: true,
    path: "/solicitudFraccionamientoDeuda",
  ),
    InfoItem(
    title: "Fraccionamiento a Terceros",
    description: "Solicitar Fraccionamiento de deuda a terceros.",
    buttonText: "Solicitar",
    necesitaAuth: true,
    path: "/solicitudFraccionamientoDeudaATerceros",
  ),
  InfoItem(
    title: "Registro de número de Teléfono Celular",
    description:
        "Registre su número de Teléfono Celular y NIS para recibir notificaciones por SMS.",
    buttonText: "Registrar",
    necesitaAuth: false,
    path: "/registroNumeroCelular",
  ),
  InfoItem(
    title: "Solicitud de Factura Fija",
    description: "Abone un importe fijo mensual durante todo un año.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudFacturaFija",
  ),
  InfoItem(
    title: "Solicitud de Abastecimiento",
    description:
        "Solicitud para nueva conexión en Baja Tensión (hasta 40 kW). Solicitud para modificación de contrato para clientes con potencia reservada.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudAbastecimiento",
  ),
  InfoItem(
    title: "Yo facturo mi Luz",
    description:
        "Ingrese los datos del NIS y lectura de Medidor.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudYoFacturoMiLuz",
  ),
];
