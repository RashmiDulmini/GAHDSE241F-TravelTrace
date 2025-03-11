import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'trail_details_page.dart';

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

  void _createTrail() {
    if (nameController.text.isEmpty ||
        trailNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        _mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and upload an image/video")),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1AB7EA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Trail Create",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Who Are You?"),
                  _buildTextField("Enter Your Name", nameController),
                  _buildLabel("What is Your Trail?"),
                  _buildTextField("Enter Your Trail Name", trailNameController),
                  _buildLabel("Enter the Description"),
                  _buildTextField("Enter The Description", descriptionController),
                  const SizedBox(height: 20),
                  _buildUploadSection(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF162221),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _createTrail,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: Text('Create Trail', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showMediaPickerDialog(),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 28, color: Colors.black),
                SizedBox(width: 8),
                Text("Upload", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Please pick an image/video", style: TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 10),
        if (_mediaFile != null)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.file(_mediaFile!, fit: BoxFit.cover),
          ),
      ],
    );
  }

  void _showMediaPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
