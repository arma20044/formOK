    import 'package:flutter/material.dart';
import 'package:form/model/constans/mensajes_servicios.dart';
import 'package:form/model/servicios_nis_telefono.dart';

final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");



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


List<NumberItem> processServiciosClase(ResultadoServiciosNisTelefono resultado) {
  final Map<int, List<ServiceItem>> serviciosPorNumero = {};

  // Recorremos cada item de la lista
  for (var item in resultado.lista!) {
    if (item == null) continue;

    final numero = item.numeroMovil;
    final codigo = item.codigoServicio;
    final estado = item.estado;

    if (numero == null || codigo == null) continue;

    // Obtenemos el nombre del servicio desde ListaCodigoServicio
    final nombreServicio = resultado.listaCodigoServicio?.toJson()[codigo] ?? codigo;

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



