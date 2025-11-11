import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapModal extends StatefulWidget {
  final LatLng initialPosition;

  const CustomMapModal({Key? key, required this.initialPosition}) : super(key: key);

  @override
  State<CustomMapModal> createState() => _MapModalState();
}

class _MapModalState extends State<CustomMapModal> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 700,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.initialPosition,
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (position) {
                  setState(() {
                    _selectedLocation = position;
                  });
                },
                markers: _selectedLocation != null
                    ? {
                        Marker(
                          markerId: MarkerId('selected'),
                          position: _selectedLocation!,
                        ),
                      }
                    : {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _selectedLocation != null
                        ? () => Navigator.of(context).pop(_selectedLocation)
                        : null,
                    child: Text('Aceptar'),
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
