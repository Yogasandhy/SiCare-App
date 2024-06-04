import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDoctors() {
    return _firestore.collection('doctors').snapshots();
  }

  Future<int> getDoctorCount() async {
    QuerySnapshot snapshot = await _firestore.collection('doctors').get();
    return snapshot.docs.length;
  }

  // Get doctor by id and jadwal from available_dates collection query
  Future<Map<String, dynamic>> getDoctorById(String id,
      {DateTime? startDate}) async {
    DateTime start = startDate ?? DateTime.now();
    DateTime end = start.add(const Duration(days: 30));

    String startFormatted = DateFormat('yyyy-MM-dd').format(start);
    String endFormatted = DateFormat('yyyy-MM-dd').format(end);

    final doctorData = await _firestore.collection('doctors').doc(id).get();
    final availableDates = await _firestore
        .collection('available_dates')
        .where('doctor_id', isEqualTo: id)
        .where('date', isGreaterThanOrEqualTo: startFormatted)
        .where('date', isLessThanOrEqualTo: endFormatted)
        .get();

    final doctor = doctorData.data() as Map<String, dynamic>;
    doctor['id'] = id;

    final availableDatesData =
        availableDates.docs.map((e) => e.data()).toList();

    return {
      'doctor': doctor,
      'available_dates': availableDatesData,
    };
  }

  Future<Map<String, dynamic>> getDoctorData(String id,
      {DateTime? startDate}) async {
    try {
      final data = await getDoctorById(id, startDate: startDate);
      return {
        'doctor': data['doctor'],
        'available_dates': data['available_dates'],
        'error': null,
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  // Get doctor schedule by doctor_id
  Future<List<dynamic>> getDoctorSchedule(
      String doctorId, DateTime date) async {
    final availableDates = await _firestore
        .collection('available_dates')
        .where('doctor_id', isEqualTo: doctorId)
        .where('date',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(date))
        .where('date',
            isLessThanOrEqualTo: DateFormat('yyyy-MM-dd')
                .format(date.add(const Duration(days: 3))))
        .get();
    final availableDatesData =
        availableDates.docs.map((e) => e.data()).toList();

    return availableDatesData;
  }
}
