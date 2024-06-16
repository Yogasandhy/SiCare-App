import 'package:flutter/material.dart';
import '../../providers/Auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final Auth _auth = Auth(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                'Masukkan email Anda dan kami akan mengirimkan instruksi untuk mereset password Anda.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(_emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Instruksi reset password telah dikirim ke email Anda.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terjadi kesalahan, silakan coba lagi.')),
                    );
                  }
                },
                child: Text('Kirim Instruksi Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}