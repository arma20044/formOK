import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelector extends StatelessWidget {
  final LatLng initialPosition;
  final LatLng? selectedPosition;
  final Function(GoogleMapController controller)? onCreated;
  final Function(LatLng pos) onTap;

  const MapSelector({
    super.key,
    required this.initialPosition,
    required this.onTap,
    this.selectedPosition,
    this.onCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => onCreated?.call(controller),
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: {
        if (selectedPosition != null)
          Marker(
            markerId: const MarkerId("selected"),
            position: selectedPosition!,
          ),
      },
      onTap: onTap,
    );
  }
}
