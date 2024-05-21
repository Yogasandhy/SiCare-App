import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/providers/Auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Input your name here',
                placeholder: 'Full Name',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _phoneController,
                hintText: 'Input your phone number here',
                placeholder: 'Phone Number',
                isPhone: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                hintText: 'Input your email here',
                placeholder: 'Email',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Input your password here',
                placeholder: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 113),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: Color(0xff0E82FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //already have an account? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: const Text(
                      'Sign In',
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.placeholder,
    this.isPassword = false,
    this.isPhone = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String placeholder;
  final bool isPassword;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              placeholder,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              obscureText: value.isPasswordVisible,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: () {
                          value.togglePasswordVisibility();
                        },
                        icon: Icon(value.isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )
                    : null,
                prefixIcon: isPhone
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //flag image
                          Image.asset(
                            'assets/Indonesia_flag.png',
                          ),
                          Text(
                            '+62',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
