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
    if (widget.lat != null && widget.lng != null) {
      _selected = LatLng(widget.lat!, widget.lng!);
    }
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Servicio de ubicación deshabilitado');
      setState(() {
        _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
      });
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso denegado');
        setState(() {
          _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso denegado permanentemente');
      setState(() {
        _currentPosition = const LatLng(-25.2637, -57.5759); // fallback
      });
      return;
    }

    // Permiso otorgado, obtener posición
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _currentPosition = LatLng(pos.latitude, pos.longitude);
      });
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      debugPrint("Error obteniendo ubicación: $e");
      setState(() {
        _currentPosition = const LatLng(-25.2882897, -57.6120394); // fallback
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final LatLng initialLatLng =
        _selected ?? _currentPosition ?? const LatLng(-25.2882897, -57.6120394);

    return LayoutBuilder(
      builder: (context, constraints) {
        final mapHeight = constraints.maxHeight * 0.85;
        final infoHeight = constraints.maxHeight - mapHeight ;

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              SizedBox(
                height: mapHeight,
                width: double.infinity,
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
               if (_selected != null)
              SizedBox(
                
                height: infoHeight,
                width: double.infinity,
                child: LocationInfo(
                  lat: _selected?.latitude ?? initialLatLng.latitude,
                  lng: _selected?.longitude ?? initialLatLng.longitude,
                  current: _currentPosition,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
