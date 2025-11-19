import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:form/model/constans/mensajes_servicios.dart';
import 'package:form/model/servicios_nis_telefono.dart';
import 'package:form/presentation/components/common/custom_pdf_modal.dart';
import 'package:form/presentation/screens/favoritos/favoritos_screen.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';


final RegExp emailRegex = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

Widget loadingRow([String message = "Cargando datos..."]) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircularProgressIndicator(),
      const SizedBox(width: 10),
      Text(message),
    ],
  );
}

List<NumberItem> processServiciosClase(
  ResultadoServiciosNisTelefono resultado,
) {
  final Map<int, List<ServiceItem>> serviciosPorNumero = {};

  // Recorremos cada item de la lista
  for (var item in resultado.lista!) {
    if (item == null) continue;

    final numero = item.numeroMovil;
    final codigo = item.codigoServicio;
    final estado = item.estado;

    if (numero == null || codigo == null) continue;

    // Obtenemos el nombre del servicio desde ListaCodigoServicio
    final nombreServicio =
        resultado.listaCodigoServicio?.toJson()[codigo] ?? codigo;

    final serviceItem = ServiceItem(
      code: codigo,
      name: nombreServicio,
      isSelected: estado == 'EM001', // marcar seleccionado según estado
    );

    serviciosPorNumero.putIfAbsent(numero.toInt(), () => []).add(serviceItem);
  }

  // Convertimos el Map en una lista de NumberItem
  return serviciosPorNumero.entries
      .map((entry) => NumberItem(number: entry.key, services: entry.value))
      .toList();
}

Future<File> descargarPdfConPipe(String url, String nombreArchivo) async {
  Dio dio = Dio();

  Directory dir = await getTemporaryDirectory();
  String ruta = '${dir.path}/$nombreArchivo';
  File archivo = File(ruta);

  try {
    final response = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'application/pdf',
          'x-so': Platform.isAndroid ? 'Android' : 'IOS',
        },
      ),
    );

    final body = response.data as ResponseBody;

    final total = body.contentLength ?? -1;
    int recibido = 0;

    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');

    final sink = archivo.openWrite();

    // Esto descarga y escribe automáticamente el stream en el archivo
    await for (final chunk in body.stream) {
      recibido += chunk.length;
      if (total != -1) {
        print('Descargando: ${(recibido / total * 100).toStringAsFixed(0)}%');
      }
      sink.add(chunk);
    }

    await sink.close();
    print('Descarga completada: ${archivo.path}');

    print('Tamaño del archivo: ${await archivo.length()} bytes');

    final bytes = await archivo.readAsBytes();
    print('Primeros bytes: ${String.fromCharCodes(bytes.take(100))}');

    return archivo;
  } catch (e) {
    throw Exception('Error al descargar PDF: $e');
  }
}

void mostrarCustomModal(BuildContext context, File pdfFile) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomPdfModal(
        pdfFile: pdfFile,
        title: 'Confirmar acción',
        content: const Text(
          '¿Deseas continuar con esta acción?',
          textAlign: TextAlign.center,
        ),
        onConfirm: () {
          // acción de confirmación
          debugPrint('Confirmado ✅');
        },
        onCancel: () {
          debugPrint('Cancelado ❌');
        },
      );
    },
  );
}

/// Convierte una fecha de formato YYYY-DD-MM a DD/MM/YYYY
String formatearFecha({required String fecha, String formatoSalida = '/'}) {
  try {
    // Separar los componentes
    List<String> partes = fecha.split('-');
    if (partes.length != 3) throw FormatException("Formato inválido");

    String year = (partes[0]);
    String day = (partes[1]);
    String month = (partes[2]);

    /*if(int.parse(day) < 10){
      day = '0$day';
    }

    if(int.parse(month) < 10){
      month='0$month';
    }*/

    return '$month$formatoSalida$day$formatoSalida$year';
  } catch (e) {
    // En caso de error, devuelve el string original
    return fecha;
  }
}

String formatearNumero(
  num valor, {
  int decimales = 0,
  String locale =
      'es_PY', // Usa es_PY para formato con puntos y comas correctas
}) {
  final format = NumberFormat.currency(
    locale: locale,
    symbol: '', // sin símbolo de moneda
    decimalDigits: decimales,
  );
  return format.format(valor).trim();
}

String formatearNumeroString(
  String valor, {
  int decimales = 0,
  String locale = 'es_PY',
}) {
  if(valor.contains("/")){ //es fecha
    return valor;
  }
  final numero = num.tryParse(valor.replaceAll(',', '.')) ?? 0;
  return formatearNumero(numero, decimales: decimales, locale: locale);
}

Future<void> lanzarUrl(String key) async {
  //  await dotenv.load(fileName: ".env");

  final url = dotenv.env[key];
  if (url == null) return;

  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('No se pudo abrir $url');
  }
}

enum MediaType { foto, video, mixto }

void copyTextToClipboard(String textToCopy, BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: textToCopy));
  // Optionally, show a confirmation message to the user, like a SnackBar
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Texto copiado exitosamente!')));
}

String obtenerFechaActual() {
  DateTime ahora = DateTime.now();

  final formateador = DateFormat('dd/MM/yyyy HH:mm:ss');

  String fechaFormateada = formateador.format(ahora);

  print(fechaFormateada); // Ejemplo: 13/11/2025 10:30:00

  return fechaFormateada;
}




String formatMiles(num number) {
  final formatter = NumberFormat("#,##0", "es_PY"); // Español - Paraguay
  return formatter.format(number);
}







String formatNumero(dynamic valor) {
  if (valor == null) return "";

  String strValor = valor.toString().trim();
  if (strValor.isEmpty) return "";

  String normalized = strValor;

  // Detectar formato
  if (strValor.contains('.') && strValor.contains(',')) {
    // Caso típico: '1.234,56' -> punto miles, coma decimal
    normalized = strValor.replaceAll('.', '').replaceAll(',', '.');
  } else if (strValor.contains(',')) {
    // Solo coma decimal
    normalized = strValor.replaceAll(',', '.');
  } else {
    // Solo punto o nada
    normalized = strValor;
  }

  num numero;
  try {
    numero = num.parse(normalized);
  } catch (e) {
    return strValor; // fallback
  }

  // Decidimos la cantidad de decimales según el número original
  int decimales = 0;
  if (strValor.contains(',') || strValor.contains('.')) {
    // Si tiene decimal en entrada, contamos dígitos
    List<String> partes = strValor.contains(',')
        ? strValor.split(',')
        : strValor.split('.');
    if (partes.length > 1) {
      decimales = partes[1].length;
    }
  }

  // Formateamos con separador de miles y decimal
  final formatter = NumberFormat.currency(
    locale: 'es_PY',
    symbol: '',
    decimalDigits: decimales,
  );

  return formatter.format(numero).trim();
}

 List<Favorito> favFacturas = [];
  Future<void> toggleFavoritoFactura(Favorito fav) async {
    if (favFacturas.any((e) => e.id == fav.id)) {
      favFacturas.removeWhere((e) => e.id == fav.id);
    } else {
      favFacturas.add(fav);
    }
    await FavoritosStorage.saveLista(FavoritosStorage.keyFacturas, favFacturas);
    //setState(() {});
    log("guadradamos$fav");
  }


    num calcularCifra(String nis, String fechaVencimiento) {
    if (nis.length < 3) return 0;
    final nisParcial = int.tryParse(nis.substring(0, 3)) ?? 0;
    final parts = fechaVencimiento.split('-');
    if (parts.length != 3) return 0;
    final dia = int.tryParse(parts[2]) ?? 0;
    final mes = int.tryParse(parts[1]) ?? 0;
    final anho = int.tryParse(parts[0]) ?? 0;
    final mejunje = anho - (dia * mes);
    final oper = (int.tryParse(nis) ?? 0) * nisParcial + (int.tryParse(nis) ?? 0);
    return oper * mejunje;
  }