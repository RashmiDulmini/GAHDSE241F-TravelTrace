import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import '../providers/user_provider.dart';

class RoutePicker extends StatefulWidget {
  @override
  _RoutePickerState createState() => _RoutePickerState();
}

class _RoutePickerState extends State<RoutePicker> {
  GoogleMapController? _mapController;
  LatLng? _startPoint;
  LatLng? _endPoint;
  bool _isSelectingStart = true;
  Location location = Location();
  LatLng _initialPosition = LatLng(7.8731, 80.7718); // Sri Lanka center
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        setState(() => _isLoading = false);
        return;
      }

      final locationData = await location.getLocation();
      setState(() {
        _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 15),
      );
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      if (_isSelectingStart) {
        _startPoint = position;
        _isSelectingStart = false;
      } else {
        _endPoint = position;
      }
    });
  }

  void _resetPoints() {
    setState(() {
      _startPoint = null;
      _endPoint = null;
      _isSelectingStart = true;
    });
  }

  void _confirmSelection() {
    if (_startPoint != null && _endPoint != null) {
      Navigator.pop(context, {
        'start': _startPoint,
        'end': _endPoint,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both start and end points')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    
    if (_startPoint != null) {
      markers.add(
        Marker(
          markerId: MarkerId('start'),
          position: _startPoint!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Start Point'),
        ),
      );
    }
    
    if (_endPoint != null) {
      markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: _endPoint!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'End Point'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Route Points'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetPoints,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _onMapTap,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isSelectingStart
                                ? 'Tap on the map to select start point'
                                : _endPoint == null
                                    ? 'Tap on the map to select end point'
                                    : 'Route points selected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_startPoint != null) ...[
                            SizedBox(height: 8),
                            Text(
                              'Start: ${_startPoint!.latitude.toStringAsFixed(6)}, ${_startPoint!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                          if (_endPoint != null) ...[
                            SizedBox(height: 8),
                            Text(
                              'End: ${_endPoint!.latitude.toStringAsFixed(6)}, ${_endPoint!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startPoint != null && _endPoint != null ? _confirmSelection : null,
        label: Text('Confirm Selection'),
        icon: Icon(Icons.check),
      ),
    );
  }
} 