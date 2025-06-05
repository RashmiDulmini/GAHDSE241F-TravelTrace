import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/user_provider.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = false;
  final _locationNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.latitude != null && userProvider.longitude != null) {
      _selectedLocation = LatLng(userProvider.latitude!, userProvider.longitude!);
      _locationNameController.text = userProvider.locationName ?? '';
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse(
          'http://localhost:8080/api/users/${userProvider.userId}/location');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'latitude': _selectedLocation!.latitude.toString(),
          'longitude': _selectedLocation!.longitude.toString(),
          'locationName': _locationNameController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userProvider.updateLocation(
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          locationName: _locationNameController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location saved successfully')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to save location');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save location: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Location'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? LatLng(7.8731, 80.7718), // Sri Lanka center
              zoom: 7,
            ),
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('selected_location'),
                      position: _selectedLocation!,
                      infoWindow: InfoWindow(title: 'Selected Location'),
                    ),
                  }
                : {},
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _locationNameController,
                      decoration: InputDecoration(
                        labelText: 'Location Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Selected Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(6)}',
                    ),
                    Text(
                      'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveLocation,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Save Location'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 