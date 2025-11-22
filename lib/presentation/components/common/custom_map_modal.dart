import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapModal extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng? selectedLocation;

  const CustomMapModal({
    Key? key,
    required this.initialPosition,
    this.selectedLocation,
  }) : super(key: key);

  @override
  State<CustomMapModal> createState() => _CustomMapModalState();
}

class _CustomMapModalState extends State<CustomMapModal> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;
    final height = MediaQuery.of(context).size.height * 0.7;

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.initialPosition,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (!_mapReady) {
                        setState(() => _mapReady = true);
                      }
                    },
                    onTap: (position) {
                      setState(() {
                        _selectedLocation = position;
                      });
                    },
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _selectedLocation!,
                            ),
                          }
                        : {},
                  ),
                  if (!_mapReady)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _selectedLocation != null
                        ? () => Navigator.of(context).pop(_selectedLocation)
                        : null,
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
