// EditProfileScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/custom_text_field.dart';
import 'package:sicare_app/providers/profileProvider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Profile Information'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Provider.of<ProfileProvider>(context).getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data available'));
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            TextEditingController _nameController =
                TextEditingController(text: data['displayName']);
            TextEditingController _phoneController =
                TextEditingController(text: data['phoneNumber']);
            TextEditingController _emailController =
                TextEditingController(text: data['email']);
            TextEditingController _passwordController = TextEditingController();

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
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                          Positioned(
                            right: -4,
                            bottom: -4,
                            child: IconButton(
                              icon: Image.asset('assets/edit.png'),
                              onPressed: () {},
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
                          await Provider.of<ProfileProvider>(context, listen: false).updateUserProfile(
                            name: _nameController.text,
                            phoneNumber: _phoneController.text,
                            password: _passwordController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile updated successfully!')),
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update profile: $e')),
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