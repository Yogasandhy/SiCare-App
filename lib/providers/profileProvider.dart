import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User get user => _auth.currentUser!;

  Stream<DocumentSnapshot> getUserData() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .snapshots();
  }

  Future<void> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? password,
    String? photoUrl,
  }) async {
    // Update user data in Firestore
    Map<String, String> updatedData = {};
    if (name != null && name.isNotEmpty) {
      updatedData['displayName'] = name;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      updatedData['phoneNumber'] = phoneNumber;
    }
    if (updatedData.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update(updatedData);
    }

    // Update password in Firebase Auth
    if (password != null && password.isNotEmpty) {
      await _auth.currentUser?.updatePassword(password);
    }
    if (photoUrl != null && photoUrl.isNotEmpty) {
      await _auth.currentUser?.updatePhotoURL(photoUrl);
    }

    notifyListeners();
  }

  // Update Profile Picture
  Future<String> uploadProfilePicture(String imagePath) async {
    File image = File(imagePath);
    final imageRef =
        _storage.ref().child('profile_pictures/${_auth.currentUser?.uid}');
    try {
      await imageRef.putFile(image);
      final url = await imageRef.getDownloadURL();
      return url;
    } catch (e) {
      return e.toString();
    }
  }
}
