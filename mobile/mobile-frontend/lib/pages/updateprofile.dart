import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:traveltrace/providers/user_provider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'user';
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _fullNameController.text = userProvider.fullName;
    _userNameController.text = userProvider.userName;
    _emailController.text = userProvider.email;
    _role = userProvider.role;
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('http://localhost:8080/api/users/update/${userProvider.userId}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': _fullNameController.text,
          'userName': _userNameController.text,
          'address': _addressController.text,
          'contact': _contactController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': _role,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Provider.of<UserProvider>(context, listen: false).setUserInfo(
          userId: data['id'].toString(),
          userName: data['userName'] ?? '',
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          role: data['role'] ?? '',
        );

        setState(() {
          _successMessage = 'Profile updated successfully!';
          _errorMessage = '';
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Update failed.';
          _successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter full name' : null,
              ),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Enter username' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value!.isEmpty || !value.contains('@')) ? 'Enter valid email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: _role,
                items: ['user', 'admin']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: Text('Update Profile'),
              ),
              if (_successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _successMessage,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
