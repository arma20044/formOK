import 'package:flutter/material.dart';
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
      text = "Ubicación seleccionada: lat $lat, lon $lng";
    } else if (current != null) {
      text =
          "Ubicación actual: lat ${current!.latitude}, lon ${current!.longitude}";
    } else {
      text = "Esperando ubicación...";
    }

    return Container(
      //color: Colors.blue.shade50,
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
