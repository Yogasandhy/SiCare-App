import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/providers/Auth.dart';
import 'package:sicare_app/screens/auth/login_screen.dart';
import '../../components/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Pendaftaran..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pendaftaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Masukan nama lengkap anda',
                placeholder: 'Nama Lengkap',
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _phoneController,
                hintText: 'Masukkan nomor telepon anda',
                placeholder: 'Nomor Telepon',
                isPhone: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukkan email anda',
                placeholder: 'Email',
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Masukkan Kata Sandi anda',
                placeholder: 'Kata Sandi',
                isPassword: true,
              ),
              SizedBox(height: 113),
              ElevatedButton(
                onPressed: () async {
                  _showLoadingDialog(context); // Show loading dialog
                  try {
                    await auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                      phone: _phoneController.text,
                    );
                    _hideLoadingDialog(context); // Hide loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User created successfully'),
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } catch (e) {
                    _hideLoadingDialog(context); // Hide loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User creation failed: $e'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: Color(0xff0E82FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              //already have an account? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah memiliki akun? ',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0E82FD),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
