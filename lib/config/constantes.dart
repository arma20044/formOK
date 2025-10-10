import 'package:form/config/tipo_tramite_model.dart';

final List<ModalModel> dataTipoClienteArray = [
  ModalModel(id: "1", descripcion: "Gestión Documental (EXPEDIENTES)"),
  ModalModel(id: "2", descripcion: "Gestión Comercial"),
  //{ "id": "2", "descripcion": "Gestión Documental (EXPEDIENTES)" },
  //{ "id": "1", "descripcion": "Gestión Comercial" }
];

final dataTipoDocumentoArray = [
  ModalModel(id: "TD001", descripcion: "C.I. Civil"),
  ModalModel(id: "TD002", descripcion: "RUC"),
  ModalModel(id: "TD004", descripcion: "Pasaporte"),

  /* { "id": "TD001", "descripcion": "C.I. Civil" },
    { "id": "TD002", "descripcion": "RUC" },
    { "id": "TD004", "descripcion": "Pasaporte" }*/
];

final dataTipoSolicitanteArray = [
  ModalModel(id: "Entidad Pública", descripcion: "Entidad Pública"),
  ModalModel(id: "Entidad Privada", descripcion: "Entidad Privada"),
  ModalModel(id: "Particular", descripcion: "Particular"),
  /* { "id": "Entidad Pública", "descripcion": "Entidad Pública" },
    { "id": "Entidad Privada", "descripcion": "Entidad Privada" },
    { "id": "Particular", "descripcion": "Particular" },*/
];

final dataPaisArray = [
  ModalModel(id: "Paraguay", descripcion: "Paraguay"),
  ModalModel(id: "Brasil", descripcion: "Brasil"),
  ModalModel(id: "Argentina", descripcion: "Argentina"),
  ModalModel(id: "Bolivia", descripcion: "Bolivia"),
  /*  { "id": "Paraguay", "descripcion": "Paraguay" },
    { "id": "Brasil", "descripcion": "Brasil" },
    { "id": "Argentina", "descripcion": "Argentina" },
    { "id": "Bolivia", "descripcion": "Bolivia" }*/
];

const dataTipoDocumentoActArray = [
  {"id": "TD001", "descripcion": "C.I. Civil"},
  {"id": "TD002", "descripcion": "RUC"},
];

final dataTipoVerificacion = [
  ModalModel(id: "CEL", descripcion: "Numero de Celular"),
  ModalModel(id: "COR", descripcion: "Correo"),
];


final infoTipoVerificacion = "Conforme la RP N° 45.385 de fecha 1 de julio de 2021, que aplica lo establecido en la Ley 4017/2010, la contraseña suministrada para autenticarse en la plataforma digital de la institución, es personal e intransferible y constituye su firma electrónica. El usuario al utilizarla como su medio de identificación, manifiesta en carácter de declaración jurada que la misma fue creada personalmente y se obliga a mantenerlo bajo su exclusivo control y conocimiento; permitiendo identificarlo en forma inequívoca, asumiendo en consecuencia, toda la responsabilidad emergente de su uso.";