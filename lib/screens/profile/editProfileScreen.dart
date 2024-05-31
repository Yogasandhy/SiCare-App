// EditProfileScreen.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/custom_text_field.dart';
import 'package:sicare_app/providers/profileProvider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userDataFuture = _loadUserData();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    DocumentSnapshot userDoc = await profile.getUserData().first;
    var data = userDoc.data() as Map<String, dynamic>;

    _nameController.text = data['displayName'];
    _phoneController.text = data['phoneNumber'];
    _emailController.text = data['email'];
    return data;
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Profile Information'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data available'));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (profile.user.photoURL != null
                                    ? NetworkImage(profile.user.photoURL!)
                                    : null) as ImageProvider?,
                            child: _imageFile == null &&
                                    profile.user.photoURL == null
                                ? Icon(Icons.person,
                                    size: 100, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            right: -4,
                            bottom: -4,
                            child: IconButton(
                              icon: Image.asset('assets/edit.png'),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => BottomSheet(
                                    onClosing: () {},
                                    builder: (context) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton.icon(
                                          icon: Icon(Icons.camera),
                                          label: Text('Camera'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _getImage(ImageSource.camera);
                                          },
                                        ),
                                        TextButton.icon(
                                          icon: Icon(Icons.photo),
                                          label: Text('Gallery'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _getImage(ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Input your name here',
                      placeholder: 'Full Name',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Input your phone number here',
                      placeholder: 'Phone Number',
                      isPhone: true,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      enabled: false,
                      controller: _emailController,
                      hintText: 'Input your email here',
                      placeholder: 'Email',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: '*******',
                      placeholder: 'Change Password',
                      isPassword: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56),
                        backgroundColor: Color(0xff0E82FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (_imageFile != null) {
                            await profile
                                .updateProfilePicture(_imageFile!.path)
                                .then((value) {
                              profile.updateUserProfile(
                                name: _nameController.text,
                                phoneNumber: _phoneController.text,
                                password: _passwordController.text,
                                photoUrl: value,
                              );
                            });
                          } else {
                            profile.updateUserProfile(
                              name: _nameController.text,
                              phoneNumber: _phoneController.text,
                              password: _passwordController.text,
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Profile updated successfully!')),
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to update profile: $e')),
                          );
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
