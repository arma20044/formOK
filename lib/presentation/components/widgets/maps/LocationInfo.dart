import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/info_card_simple.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfo extends StatelessWidget {
  final double? lat;
  final double? lng;
  final LatLng? current;

  const LocationInfo({
    super.key,
    required this.lat,
    required this.lng,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    if (lat != null && lng != null) {
      text = "Ubicación seleccionada:\n latitud $lat, \n longitud $lng";
    } else if (current != null) {
      text =
          "Ubicación actual: \n lat ${current!.latitude}, \n lon ${current!.longitude}";
    } else {
      text = "Esperando ubicación...";
    }

    return InfoCardSimple(title: text, subtitle: "", color: Colors.red);
  }
}
