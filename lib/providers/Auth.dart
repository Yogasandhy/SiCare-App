import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sicare_app/models/UserModel.dart';

class Auth with ChangeNotifier {
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // TODO: get current user
  User get user => _auth.currentUser!;

  //TODO: Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
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

      UserModel userModel = UserModel(
        email: email,
        role: 'user',
        displayName: name,
        phoneNumber: phone,
        address: '',
        photoURL: '',
      );

      if (user != null) {
        user.updateDisplayName(name);
        await _firestore.collection('users').doc(user.uid).set(
              userModel.toJson(),
            );
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

  //TODO: sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print(e.code);
        throw 'Wrong password provided for that user.';
      } else {
        print(e.code);
        throw 'An error occurred while signing in.';
      }
    }
  }

  //TODO: sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //TODO: save transaction to firestore
  Future<void> saveTransaction({
    required String doctorId,
    required String userId,
    required String date,
    required String formattedDate,
    required String time,
    required String paymentMethod,
    required String price,
  }) async {
    try {
      // TODO: save transaction to firestore
      await _firestore.collection('transactions').add({
        'doctor_id': doctorId,
        'user_id': userId,
        'date': date,
        'time': time,
        'payment_method': paymentMethod,
        'price': price,
        'status': 'Aktif',
        'diagnosis': '-',
      });
      // TODO: get available_dates collection id
      final availableDates = await _firestore
          .collection('available_dates')
          .where('doctor_id', isEqualTo: doctorId)
          .where('date', isEqualTo: formattedDate)
          .get();
      final availableDatesId = availableDates.docs.first.id;
      print(availableDatesId);
      //TODO: update available dates
      await _firestore
          .collection('available_dates')
          .doc(availableDatesId)
          .update({
        'slots': FieldValue.arrayRemove([time]),
      });
    } catch (e) {
      throw 'An error occurred while saving transaction';
    }
  }
}
