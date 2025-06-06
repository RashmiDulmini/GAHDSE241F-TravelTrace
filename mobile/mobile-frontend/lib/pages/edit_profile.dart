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
  bool _isUploading = false;

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
    addressController = TextEditingController(text: userProvider.address);
    contactController = TextEditingController(text: userProvider.contact);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadProfilePicture();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_image == null) return;
    setState(() => _isUploading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('http://localhost:8080/api/users/${userProvider.userId}/profile-picture');

      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      if (response.statusCode == 200) {
        userProvider.updateProfilePicture(data['profilePicture']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to upload profile picture');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _removeProfilePicture() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse('http://localhost:8080/api/users/${userProvider.userId}/profile-picture');

      final response = await http.delete(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _image = null;
        });
        userProvider.updateProfilePicture(null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture removed successfully')),
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to remove profile picture');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove profile picture: ${e.toString()}')),
      );
    }
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
        final data = json.decode(response.body);
        userProvider.setUserInfo(
          userId: userProvider.userId,
          userName: data['userName'] ?? '',
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          role: userProvider.role,
          address: data['address'] ?? '',
          contact: data['contact'] ?? '',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Update failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
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
          icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.blue),
          onPressed: onEditPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String? profilePicture = userProvider.profilePicture;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.cyan[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (profilePicture != null
                          ? NetworkImage('http://localhost:8080/uploads/profile-pictures/$profilePicture')
                          : AssetImage('assets/profile.jpg')) as ImageProvider,
                  backgroundColor: Colors.grey[300],
                ),
                if (_isUploading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (profilePicture != null)
                        GestureDetector(
                          onTap: _removeProfilePicture,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.delete, color: Colors.white, size: 20),
                          ),
                        ),
                      SizedBox(width: 8),
                      PopupMenuButton<ImageSource>(
                        onSelected: _pickImage,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: ImageSource.camera,
                            child: ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Take Photo'),
                            ),
                          ),
                          PopupMenuItem(
                            value: ImageSource.gallery,
                            child: ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Choose from Gallery'),
                            ),
                          ),
                        ],
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildEditableField('Full Name', fullNameController, isEditingFullName, () {
              setState(() {
                isEditingFullName = !isEditingFullName;
                if (!isEditingFullName) _updateProfile();
              });
            }),
            _buildEditableField('Username', usernameController, isEditingUsername, () {
              setState(() {
                isEditingUsername = !isEditingUsername;
                if (!isEditingUsername) _updateProfile();
              });
            }),
            _buildEditableField('Email', emailController, isEditingEmail, () {
              setState(() {
                isEditingEmail = !isEditingEmail;
                if (!isEditingEmail) _updateProfile();
              });
            }),
            _buildEditableField('Address', addressController, isEditingAddress, () {
              setState(() {
                isEditingAddress = !isEditingAddress;
                if (!isEditingAddress) _updateProfile();
              });
            }),
            _buildEditableField('Contact', contactController, isEditingContact, () {
              setState(() {
                isEditingContact = !isEditingContact;
                if (!isEditingContact) _updateProfile();
              });
            }),
          ],
        ),
      ),
    );
  }
}
