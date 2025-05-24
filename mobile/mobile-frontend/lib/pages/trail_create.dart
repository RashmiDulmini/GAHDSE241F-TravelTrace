import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveltrace/pages/acc_page.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_search.dart';
import 'map_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrailCreatePage extends StatefulWidget {
  @override
  _TrailCreatePageState createState() => _TrailCreatePageState();
}

class _TrailCreatePageState extends State<TrailCreatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController trailNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _mediaFile;
  String _mediaType = ''; // 'image' or 'video'
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  LatLng? _startLocation;
  LatLng? _endLocation;
  bool _isUploading = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, String type) async {
    try {
      XFile? pickedFile;
      if (type == 'video') {
        pickedFile = await _picker.pickVideo(source: source);
      } else {
        pickedFile = await _picker.pickImage(source: source);
      }

      if (pickedFile != null) {
        // Get temporary directory
        final directory = await path_provider.getTemporaryDirectory();
        final fileName = path.basename(pickedFile.path);
        
        // Create a copy of the file in the temporary directory
        final File localFile = File('${directory.path}/$fileName');
        final File originalFile = File(pickedFile.path);
        await originalFile.copy(localFile.path);

        setState(() {
          _mediaFile = localFile;
          _mediaType = type;
        });

        if (type == 'video') {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(_mediaFile!)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick ${type}: ${e.toString()}")),
      );
    }
  }

  Future<void> _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );

    if (result != null) {
      setState(() {
        _startLocation = result['start'];
        _endLocation = result['end'];
      });
    }
  }

  Future<void> _createTrail() async {
    if (nameController.text.isEmpty ||
        trailNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        _mediaFile == null ||
        _startLocation == null ||
        _endLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/api/trails/create'),
      );

      // Add text fields
      request.fields['name'] = nameController.text;
      request.fields['trailName'] = trailNameController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['startLatitude'] = _startLocation!.latitude.toString();
      request.fields['startLongitude'] = _startLocation!.longitude.toString();
      request.fields['endLatitude'] = _endLocation!.latitude.toString();
      request.fields['endLongitude'] = _endLocation!.longitude.toString();
      request.fields['mediaType'] = _mediaType;

      // Add media file
      request.files.add(await http.MultipartFile.fromPath(
        'mediaFile',
        _mediaFile!.path,
      ));

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Trail created successfully!")),
        );
        Navigator.pop(context);
      } else {
        throw Exception(responseData);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create trail: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trail", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(nameController, "Your Name", Icons.person),
            _buildTextField(trailNameController, "Trail Name", Icons.route),
            _buildTextField(descriptionController, "Description", Icons.description, maxLines: 3),
            
            SizedBox(height: 20),
            
            // Location Selection
            ElevatedButton.icon(
              onPressed: _openMap,
              icon: Icon(Icons.map),
              label: Text("Select Locations on Map"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            if (_startLocation != null && _endLocation != null)
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      _buildLocationInfo("Start", _startLocation!),
                      Divider(),
                      _buildLocationInfo("End", _endLocation!),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),
            
            // Media Upload Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Upload Media", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMediaButton("Photo", Icons.photo_camera, () => _pickMedia(ImageSource.camera, 'image')),
                        _buildMediaButton("Video", Icons.videocam, () => _pickMedia(ImageSource.camera, 'video')),
                        _buildMediaButton("Gallery", Icons.photo_library, () => _pickMedia(ImageSource.gallery, _mediaType.isEmpty ? 'image' : _mediaType)),
                      ],
                    ),
                    if (_mediaFile != null) ...[
                      SizedBox(height: 10),
                      _mediaType == 'video' && _videoController != null && _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : Image.file(_mediaFile!, height: 200),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isUploading ? null : _createTrail,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Create Trail", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String type, LatLng location) {
    return Row(
      children: [
        Icon(type == "Start" ? Icons.play_circle : Icons.stop_circle, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "$type: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaButton(String label, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
