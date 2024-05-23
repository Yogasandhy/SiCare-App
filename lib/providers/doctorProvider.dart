import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DoctorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getDoctors() {
    return _firestore.collection('doctors').snapshots();
  }

  // Get doctor by id
  Future<DocumentSnapshot> getDoctorById(String id) {
    return _firestore.collection('doctors').doc(id).get();
  }
}
