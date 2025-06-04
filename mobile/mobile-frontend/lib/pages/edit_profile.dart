import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final picker = ImagePicker();
  File? _image;
  bool isEditingFullName = false;
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingAddress = false;
  bool isEditingContact = false;

  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    fullNameController = TextEditingController(text: userProvider.fullName);
    usernameController = TextEditingController(text: userProvider.userName);
    emailController = TextEditingController(text: userProvider.email);
    addressController = TextEditingController(); // Optionally preload
    contactController = TextEditingController(); // Optionally preload
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('http://localhost:8080/api/users/update/${userProvider.userId}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullNameController.text,
          'userName': usernameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'contact': contactController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
        userProvider.setUserInfo(
          userId: userProvider.userId,
          userName: usernameController.text,
          fullName: fullNameController.text,
          email: emailController.text,
          role: userProvider.role,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  Widget _buildEditableField(String label, TextEditingController controller, bool isEditing, VoidCallback onEditPressed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: onEditPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.cyan[700],
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/profile.jpg') as ImageProvider,
                  backgroundColor: Colors.grey[300],
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildEditableField('Full Name', fullNameController, isEditingFullName, () {
              setState(() {
                isEditingFullName = !isEditingFullName;
              });
            }),
            _buildEditableField('Username', usernameController, isEditingUsername, () {
              setState(() {
                isEditingUsername = !isEditingUsername;
              });
            }),
            _buildEditableField('Email', emailController, isEditingEmail, () {
              setState(() {
                isEditingEmail = !isEditingEmail;
              });
            }),
            _buildEditableField('Address', addressController, isEditingAddress, () {
              setState(() {
                isEditingAddress = !isEditingAddress;
              });
            }),
            _buildEditableField('Contact', contactController, isEditingContact, () {
              setState(() {
                isEditingContact = !isEditingContact;
              });
            }),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _updateProfile,
              icon: Icon(Icons.save),
              label: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
