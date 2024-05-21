import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  //TODO: instance of firebase auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //TODO: create user with  email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        user.updateDisplayName(name);
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-password') {
        throw 'The password is invalid.';
      } else if (e.code == 'invalid-email') {
        throw 'The email is invalid.';
      } else {
        throw 'An error occurred while creating the user.';
      }
    }
  }
}
