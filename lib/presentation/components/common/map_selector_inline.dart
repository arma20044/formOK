import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectorInline extends StatefulWidget {
  final LatLng? initialLocation;
  final ValueChanged<LatLng> onLocationSelected;

  const MapSelectorInline({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<MapSelectorInline> createState() => _MapSelectorInlineState();
}

class _MapSelectorInlineState extends State<MapSelectorInline> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _mapReady = true);
  }

  void _onTap(LatLng position) {
    setState(() => _selectedLocation = position);
    widget.onLocationSelected(position);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona la ubicación en el mapa:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: size.height * 0.4,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(-25.2637, -57.5759),
                  zoom: 14,
                ),
                onMapCreated: _onMapCreated,
                onTap: _onTap,
                markers: _selectedLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: _selectedLocation!,
                        )
                      }
                    : {},
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
              ),
              if (!_mapReady)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Ubicación seleccionada: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}
