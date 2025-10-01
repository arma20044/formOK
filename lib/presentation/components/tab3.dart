import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tab3 extends StatefulWidget {
 
  final double? lat;
  final double? lng;
  final Function(double lat, double lng) onLocationSelected;

   const Tab3({super.key, 
       required this.lat,
    required this.lng,
    required this.onLocationSelected,
  });
  

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3>  with AutomaticKeepAliveClientMixin {
@override
  bool get wantKeepAlive => true;

  GoogleMapController? _mapController;
   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-25.2637, -57.5759), // ejemplo: Asunción
              zoom: 12,
            ),
            markers: widget.lat != null && widget.lng != null
                ? {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: LatLng(widget.lat!, widget.lng!),
                    ),
                  }
                : {},
            onTap: (pos) {
              widget.onLocationSelected(pos.latitude, pos.longitude);
            },
          ),
        ),
        // Mensaje de instrucción / error
        if (widget.lat == null || widget.lng == null)
          Container(
            color: Colors.red.shade100,
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Toque el mapa para seleccionar ubicación",
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (widget.lat != null || widget.lng != null)
          Container(child: Text('lat: ${widget.lat} - lon: ${widget.lng}')),
      ],
    );
  }
}

