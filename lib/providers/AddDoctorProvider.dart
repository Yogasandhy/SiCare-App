import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class AddDoctorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  XFile? _imageFile;

  final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  XFile? get imageFile => _imageFile;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    _imageFile = pickedImage;
    notifyListeners();
  }

  Future<String> uploadImage(String doctorId) async {
    String imageUrl = '';
    if (_imageFile != null) {
      final storageRef = _storage.ref().child('doctors').child(doctorId);
      final uploadTask = storageRef.putFile(File(_imageFile!.path));
      final snapshot = await uploadTask.whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }
    return imageUrl;
  }

  Future<void> addDoctor({
    required String name,
    required String description,
    required String alumni,
    required String position,
    required String experience,
    required String location,
    required String locationDetail,
    required double price,
    required String shift,
  }) async {
    try {
      final doctorRef = _firestore.collection('doctors').doc();
      final doctorId = doctorRef.id;

      final imageUrl = await uploadImage(doctorId);

      final doctor = {
        'alumni': alumni,
        'deskripsi': description,
        'imageUrl': imageUrl,
        'lokasi': location,
        'lokasiDetail': locationDetail,
        'nama': name,
        'pengalaman': experience,
        'posisi': position,
        'price': price,
        'rating': 0.0,
      };

      await doctorRef.set(doctor);

      final slots = _generateSlots(shift);
      await _firestore.collection('available_dates').add({
        'doctor_id': doctorId,
        'date': formattedDate,
        'slots': slots,
      });

      _imageFile = null;
      notifyListeners();
    } catch (error) {
      print('Error adding doctor: $error');
      rethrow;
    }
  }

  List<String> _generateSlots(String shift) {
    switch (shift) {
      case 'Shift 1':
        return ['09:00', '10:00', '11:00', '12:00'];
      case 'Shift 2':
        return ['13:00', '14:00', '15:00', '16:00'];
      case 'Shift 3':
        return ['17:00', '18:00', '19:00', '20:00'];
      default:
        return [];
    }
  }

   Future<void> deleteDoctor(String doctorId) async {
    try {
      print('Starting deletion process for doctor with ID: $doctorId');
      await _firestore.collection('doctors').doc(doctorId).delete();
      print('Doctor deleted from Firestore');

      final availableDatesQuery = await _firestore.collection('available_dates')
        .where('doctor_id', isEqualTo: doctorId)
        .get();

      for (var dateDoc in availableDatesQuery.docs) {
        await dateDoc.reference.delete();
        print('Deleted available date with ID: ${dateDoc.id}');
      }

      final storageRef = _storage.ref().child('doctors/$doctorId');
      await storageRef.delete();
      print('Deleted doctor image from Firebase Storage');

      notifyListeners();
      print('Deletion process completed successfully');
    } catch (e) {
      print('Error deleting doctor: $e');
      rethrow; 
    }
  }

}
