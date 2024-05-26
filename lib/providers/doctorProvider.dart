import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorProvider with ChangeNotifier {
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String oneMonthLater = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 30)));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getDoctors() {
    return _firestore.collection('doctors').snapshots();
  }

  // Get doctor by id and jadwal from available_dates collection query
  Future<Map<String, dynamic>> getDoctorById(String id) async {
    final doctorData = await _firestore.collection('doctors').doc(id).get();
    final availableDates = await _firestore
        .collection('available_dates')
        .where('doctor_id', isEqualTo: id)
        .where('date', isGreaterThanOrEqualTo: today)
        .where('date', isLessThanOrEqualTo: oneMonthLater)
        .get();

    final doctor = doctorData.data() as Map<String, dynamic>;
    final availableDatesData =
        availableDates.docs.map((e) => e.data()).toList();

    return {
      'doctor': doctor,
      'available_dates': availableDatesData,
    };
  }
}
