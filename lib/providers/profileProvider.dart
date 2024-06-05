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

  // Update Profile Picture if user uploads a new one
  Future<String> updateProfilePicture(String imagePath) async {
    File image = File(imagePath);
    final ref = _storage.ref().child('profile_pictures/${user.uid}');
    await ref.putFile(image);
    final url = await ref.getDownloadURL();
    await _auth.currentUser?.updatePhotoURL(url);
    notifyListeners();
    return url;
  }
}
