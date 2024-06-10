import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDoctors() {
    return _firestore.collection('doctors').snapshots();
  }

  Future<Map<String, dynamic>> getDoctor(String id) async {
    final doctorData = await _firestore.collection('doctors').doc(id).get();
    final doctor = doctorData.data() as Map<String, dynamic>;
    doctor['id'] = id;
    return doctor;
  }

  Future<int> getDoctorCount() async {
    QuerySnapshot snapshot = await _firestore.collection('doctors').get();
    return snapshot.docs.length;
  }

  Future<Map<String, dynamic>> fetchDoctorWithDates(String id,
      {DateTime? startDate}) async {
    try {
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
    } catch (e) {
      throw Exception("Error fetching doctor with dates: $e");
    }
  }

  Future<List<dynamic>> getDoctorSchedule(
      String doctorId, DateTime date) async {
    return await _getAvailableDates(doctorId, startDate: date, daysRange: 3);
  }

  Future<List<dynamic>> _getAvailableDates(String doctorId,
      {DateTime? startDate, int daysRange = 0}) async {
    DateTime start = startDate ?? DateTime.now();
    DateTime end = daysRange > 0 ? start.add(Duration(days: daysRange)) : start;

    String startFormatted = DateFormat('yyyy-MM-dd').format(start);
    String endFormatted = DateFormat('yyyy-MM-dd').format(end);

    final availableDatesSnapshot = await _firestore
        .collection('available_dates')
        .where('doctor_id', isEqualTo: doctorId)
        .where('date', isGreaterThanOrEqualTo: startFormatted)
        .where('date', isLessThanOrEqualTo: endFormatted)
        .get();

    return availableDatesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> searchDoctorsByName(String name) async {
    final querySnapshot = await _firestore.collection('doctors').get();

    String searchKey = name.toLowerCase();
    List<Map<String, dynamic>> doctors = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;
      doctorData['id'] = doc.id;

      if (doctorData['nama'] is String &&
          (doctorData['nama'] as String).toLowerCase().contains(searchKey)) {
        final availableDates = await _getAvailableDates(doc.id);
        doctors.add({
          'id': doc.id,
          'doctor': doctorData,
          'available_dates': availableDates,
        });
      }
    }
    return doctors;
  }

  Future<List<Map<String, dynamic>>> getAllDoctorsWithAvailableDates() async {
    final doctorsSnapshot = await _firestore.collection('doctors').get();
    final doctors = doctorsSnapshot.docs.map((doc) {
      final doctor = doc.data() as Map<String, dynamic>;
      doctor['id'] = doc.id;
      return doctor;
    }).toList();

    for (var doctor in doctors) {
      final availableDates = await _getAvailableDates(doctor['id']);
      doctor['available_dates'] = availableDates;
    }

    return doctors;
  }

  // Get doctor by posisi
  Future<List<Map<String, dynamic>>> getDoctorsByPosition(String posisi) async {
    final doctorsSnapshot = await _firestore
        .collection('doctors')
        .where('posisi', isEqualTo: posisi)
        .get();
    final doctors = doctorsSnapshot.docs.map((doc) {
      final doctor = doc.data() as Map<String, dynamic>;
      doctor['id'] = doc.id;
      return doctor;
    }).toList();

    for (var doctor in doctors) {
      final availableDates = await _getAvailableDates(doctor['id']);
      doctor['available_dates'] = availableDates;
    }

    return doctors;
  }
}
