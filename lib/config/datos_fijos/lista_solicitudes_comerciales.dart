import 'package:form/model/comercial/info_item_comercial_solicitud.dart';

final List<InfoItem> itemsSolicitudesComerciales = [
  InfoItem(
    title: "Tú Fraccionamiento",
    description: "Solicitar Tú Fraccionamiento de deuda.",
    buttonText: "Solicitar",
    necesitaAuth: true,
    path: "/solicitudFraccionamientoDeuda",
    comercial: true,
  ),
  InfoItem(
    title: "Fraccionamiento a Terceros",
    description: "Solicitar Fraccionamiento de deuda a terceros.",
    buttonText: "Solicitar",
    necesitaAuth: true,
    path: "/solicitudFraccionamientoDeudaATerceros",
    comercial: false,
  ),
  InfoItem(
    title: "Registro de número de Teléfono Celular",
    description:
        "Registre su número de Teléfono Celular y NIS para recibir notificaciones por SMS.",
    buttonText: "Registrar",
    necesitaAuth: false,
    path: "/registroNumeroCelular",
    comercial: false,
  ),
  InfoItem(
    title: "Solicitud de Factura Fija",
    description: "Abone un importe fijo mensual durante todo un año.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudFacturaFija",
    comercial: false,
  ),
  InfoItem(
    title: "Solicitud de Abastecimiento",
    description:
        "Solicitud para nueva conexión en Baja Tensión (hasta 40 kW). Solicitud para modificación de contrato para clientes con potencia reservada.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudAbastecimiento",
    comercial: false,
  ),
  InfoItem(
    title: "Yo facturo mi Luz",
    description: "Ingrese los datos del NIS y lectura de Medidor.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudYoFacturoMiLuz",
    comercial: false,
  ),
  InfoItem(
    title: "Alumbrado Público",
    description: "Desde aquí solicite la instalación de alumbrado público.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudAlumbradoPublico",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de extensión de línea en Baja Tensión",
    description: "Solicite extensión de línea en Baja Tensión.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudExtencionBajaTension",
    comercial: false,
    
  ),
  InfoItem(
    title: "Comunicación de avería de electrodomésticos",
    description: "Comunique la avería de electrodomésticos.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudComunicacionAveria",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de Retiro del Medidor",
    description: "Solicite el Retiro del Medidor.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudRetiroMedidor",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de Consulta previa superior a 40 KW",
    description: "Solicite Consulta previa superior a 40 KW.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudConsultaPreviaSuperior40kw",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de Actualización de Carga Hasta 40 kW",
    description: "Solicite Actualizacion de Carga Hasta 40 kW.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudActualizacionCargaHasta40kw",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de Actualización de datos",
    description: "Solicite Actualizacion de datos.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudActualizacionDatos",
    comercial: false,
    
  ),
  InfoItem(
    title: "Solicitud de Consumo Inteligente",
    description: "Solicite el cambio de categoría a Consumo Inteligente, tarifa por tramos horarios.",
    buttonText: "Solicitar",
    necesitaAuth: false,
    path: "/solicitudConsumoInteligente",
    comercial: false,
    
  ),
];
