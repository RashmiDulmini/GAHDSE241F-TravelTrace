import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveltrace/pages/home_page.dart'; // Import HomePage
import 'map_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var camera = await Permission.camera.status;
    var storage = await Permission.storage.status;
    
    if (camera.isDenied) {
      await Permission.camera.request();
    }
    if (storage.isDenied) {
      await Permission.storage.request();
    }
  }

  void _loadUserInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    nameController.text = userProvider.fullName ?? '';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    nameController.dispose();
    trailNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, String type) async {
    try {
      XFile? pickedFile;
      if (type == 'video') {
        pickedFile = await _picker.pickVideo(source: source);
      } else {
        pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
      }

      if (pickedFile != null) {
        final directory = await path_provider.getTemporaryDirectory();
        final fileName = path.basename(pickedFile.path);
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

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${type.capitalize()} selected successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick ${type}: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );

    if (result != null && mounted) {
      setState(() {
        _startLocation = result['start'];
        _endLocation = result['end'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location points selected successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _createTrail() async {
    if (!_validateInputs()) return;

    setState(() => _isUploading = true);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/api/trails/create'),
      );

      // Add text fields
      request.fields.addAll({
        'name': nameController.text,
        'trailName': trailNameController.text,
        'description': descriptionController.text,
        'startLatitude': _startLocation!.latitude.toString(),
        'startLongitude': _startLocation!.longitude.toString(),
        'endLatitude': _endLocation!.latitude.toString(),
        'endLongitude': _endLocation!.longitude.toString(),
        'mediaType': _mediaType,
      });

      // Add media file
      if (_mediaFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'mediaFile',
          _mediaFile!.path,
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Trail created successfully!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      } else {
        throw Exception(responseData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create trail: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  bool _validateInputs() {
    String? errorMessage;

    if (nameController.text.isEmpty ||
        trailNameController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      errorMessage = "Please fill in all text fields";
    } else if (_mediaFile == null) {
      errorMessage = "Please select a photo or video";
    } else if (_startLocation == null || _endLocation == null) {
      errorMessage = "Please select both start and end locations";
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Trail", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                nameController,
                "Your Name",
                Icons.person,
                enabled: false,
              ),
              _buildTextField(
                trailNameController,
                "Trail Name",
                Icons.route,
                hint: "Enter a name for your trail",
              ),
              _buildTextField(
                descriptionController,
                "Description",
                Icons.description,
                maxLines: 3,
                hint: "Describe your trail experience",
              ),
              SizedBox(height: 24),
              _buildMediaSection(),
              SizedBox(height: 24),
              _buildLocationSection(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUploading ? null : _createTrail,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 12),
                          Text("Creating Trail...",
                              style: TextStyle(fontSize: 18)),
                        ],
                      )
                    : Text("Create Trail", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    String? hint,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Media",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMediaButton(
                  "Take Photo",
                  Icons.photo_camera,
                  () => _pickMedia(ImageSource.camera, 'image'),
                ),
                _buildMediaButton(
                  "Record Video",
                  Icons.videocam,
                  () => _pickMedia(ImageSource.camera, 'video'),
                ),
                _buildMediaButton(
                  "Gallery",
                  Icons.photo_library,
                  () => _showMediaPickerDialog(),
                ),
              ],
            ),
            if (_mediaFile != null) ...[
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _mediaType == 'video' &&
                        _videoController != null &&
                        _videoController!.value.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          ),
                          IconButton(
                            icon: Icon(
                              _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isVideoPlaying = !_isVideoPlaying;
                                _isVideoPlaying
                                    ? _videoController!.play()
                                    : _videoController!.pause();
                              });
                            },
                          ),
                        ],
                      )
                    : Image.file(
                        _mediaFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showMediaPickerDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Media Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Photo'),
                onTap: () => Navigator.pop(context, {
                  'type': 'image',
                  'source': ImageSource.gallery,
                }),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video'),
                onTap: () => Navigator.pop(context, {
                  'type': 'video',
                  'source': ImageSource.gallery,
                }),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      await _pickMedia(result['source'], result['type']);
    }
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trail Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openMap,
              icon: Icon(Icons.map),
              label: Text("Select Locations on Map"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (_startLocation != null && _endLocation != null) ...[
              SizedBox(height: 16),
              _buildLocationInfo("Start", _startLocation!),
              Divider(height: 24),
              _buildLocationInfo("End", _endLocation!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String type, LatLng location) {
    return Row(
      children: [
        Icon(
          type == "Start" ? Icons.play_circle : Icons.stop_circle,
          color: type == "Start" ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$type Point",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: type == "Start" ? Colors.green : Colors.red,
                ),
              ),
              Text(
                "Lat: ${location.latitude.toStringAsFixed(6)}\nLng: ${location.longitude.toStringAsFixed(6)}",
                style: TextStyle(fontSize: 14),
              ),
            ],
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
          color: Colors.blue,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
