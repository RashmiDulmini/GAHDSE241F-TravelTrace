import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'map_page.dart';
import 'trail_details_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrailCreatePage extends StatefulWidget {
  @override
  _TrailCreatePageState createState() => _TrailCreatePageState();
}

class _TrailCreatePageState extends State<TrailCreatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController trailNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();
  LatLng? _startLocation;
  LatLng? _endLocation;

  Future<void> _pickMedia(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _mediaFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick an image")),
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

  void _createTrail() {
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrailDetailsPage(
          name: nameController.text,
          trailName: trailNameController.text,
          description: descriptionController.text,
          mediaFile: _mediaFile!,
          //startLocation: _startLocation!,
          //endLocation: _endLocation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trail create", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField(nameController, "Who are you?"),
            _buildTextField(trailNameController, "What is your trail?"),
            _buildTextField(descriptionController, "Enter description"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openMap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text("Go to Map...", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 5),
            Text("Select and mark start, end locations, specific locations here.",
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            if (_startLocation != null && _endLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Start: $_startLocation, End: $_endLocation",
                    style: TextStyle(color: Colors.blue)),
              ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _pickMedia(ImageSource.gallery),
              child: Icon(Icons.add_circle_outline, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTrail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              child: Text("Create Trail", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
