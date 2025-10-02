import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'widgets/maps/LocationInfo.dart';
import 'widgets/maps/MapSelector.dart';

class Tab3 extends StatefulWidget {
  final double? lat;
  final double? lng;
  final Function(double lat, double lng) onLocationSelected;

  const Tab3({
    super.key,
    required this.lat,
    required this.lng,
    required this.onLocationSelected,
  });

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _selected;

  @override
  void initState() {
    super.initState();
    // Si viene del padre ya con lat/lng, arrancamos con eso como seleccionado
    if (widget.lat != null && widget.lng != null) {
      _selected = LatLng(widget.lat!, widget.lng!);
    }
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() {
        _currentPosition = LatLng(pos.latitude, pos.longitude);
      });
      // Mover cámara si ya tenemos controlador
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      debugPrint("Error obteniendo ubicación: $e");
      // Fallback en Asunción
      setState(() {
        _currentPosition = const LatLng(-25.2637, -57.5759);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Si ya había un seleccionado (del padre o del usuario), se usa como inicial.
    final LatLng initialLatLng = _selected ??
        _currentPosition ??
        const LatLng(-25.2637, -57.5759);

    return Column(
      children: [
        Expanded(
          child: MapSelector(
            initialPosition: initialLatLng,
            selectedPosition: _selected,
            onCreated: (controller) => _mapController = controller,
            onTap: (pos) {
              setState(() {
                _selected = pos;
              });
              widget.onLocationSelected(pos.latitude, pos.longitude);
            },
          ),
        ),
        LocationInfo(
          lat: _selected?.latitude,
          lng: _selected?.longitude,
          current: _currentPosition,
        ),
      ],
    );
  }
}
