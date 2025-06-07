import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _startLocation;
  LatLng? _endLocation;
  Location location = Location();
  LatLng _initialPosition = LatLng(7.8731, 80.7718); // Sri Lanka center
  bool _isLoading = true;
  Set<Marker> _markers = {};
  bool _isSelectingStart = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission is required to use the map'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => location.requestService(),
            ),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final locationData = await location.getLocation();
      if (mounted) {
        setState(() {
          _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
          _isLoading = false;
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_initialPosition, 15),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get current location. Using default location.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
        _startLocation = position;
        _updateMarkers();
        _isSelectingStart = false;
      } else {
        _endLocation = position;
        _updateMarkers();
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();
    
    if (_startLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('start'),
          position: _startLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Start Point'),
        ),
      );
    }
    
    if (_endLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: _endLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'End Point'),
        ),
      );
    }
  }

  void _resetPoints() {
    setState(() {
      _startLocation = null;
      _endLocation = null;
      _isSelectingStart = true;
      _markers.clear();
    });
  }

  void _confirmLocations() {
    if (_startLocation != null && _endLocation != null) {
      Navigator.pop(context, {
        'start': _startLocation,
        'end': _endLocation,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both start and end points'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Trail Points'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetPoints,
            tooltip: 'Reset Points',
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
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isSelectingStart
                                ? 'Tap on the map to select start point'
                                : _endLocation == null
                                    ? 'Tap on the map to select end point'
                                    : 'Route points selected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_startLocation != null) ...[
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.play_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Start: ${_startLocation!.latitude.toStringAsFixed(6)}, ${_startLocation!.longitude.toStringAsFixed(6)}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (_endLocation != null) ...[
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.stop_circle, color: Colors.red),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'End: ${_endLocation!.latitude.toStringAsFixed(6)}, ${_endLocation!.longitude.toStringAsFixed(6)}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
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
        onPressed: _startLocation != null && _endLocation != null ? _confirmLocations : null,
        label: Text('Confirm Selection'),
        icon: Icon(Icons.check),
        backgroundColor: _startLocation != null && _endLocation != null ? Colors.blue : Colors.grey,
      ),
    );
  }
}