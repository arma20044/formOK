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

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final LatLng initialLatLng = widget.lat != null && widget.lng != null
        ? LatLng(widget.lat!, widget.lng!)
        : (_currentPosition ?? const LatLng(-25.2637, -57.5759));

    final LatLng? selected = (widget.lat != null && widget.lng != null)
        ? LatLng(widget.lat!, widget.lng!)
        : null;

    return Column(
      children: [
        Expanded(
          child: MapSelector(
            initialPosition: initialLatLng,
            selectedPosition: selected,
            onCreated: (controller) => _mapController = controller,
            onTap: (pos) {
              widget.onLocationSelected(pos.latitude, pos.longitude);
            },
          ),
        ),
        LocationInfo(
          lat: widget.lat,
          lng: widget.lng,
          current: _currentPosition,
        ),
      ],
    );
  }
}
