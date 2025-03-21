import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _startLocation;
  LatLng? _endLocation;

  void _onMapTap(LatLng position) {
    setState(() {
      if (_startLocation == null) {
        _startLocation = position;
      } else if (_endLocation == null) {
        _endLocation = position;
      } else {
        _startLocation = position;
        _endLocation = null;
      }
    });
  }

  void _confirmLocations() {
    if (_startLocation != null && _endLocation != null) {
      Navigator.pop(context, {'start': _startLocation, 'end': _endLocation});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both start and end locations")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Travel Trail")),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        onTap: _onMapTap,
        markers: {
          if (_startLocation != null)
            Marker(markerId: MarkerId("start"), position: _startLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
          if (_endLocation != null)
            Marker(markerId: MarkerId("end"), position: _endLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
        },
        initialCameraPosition: CameraPosition(target: LatLng(7.8731, 80.7718), zoom: 7),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmLocations,
        label: Text("Confirm Locations"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
