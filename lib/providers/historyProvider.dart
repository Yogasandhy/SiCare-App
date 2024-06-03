import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  var userHistory = [];
  var selectedHistory = 'Aktif';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void changeHistory(String history) {
    selectedHistory = history;
    notifyListeners();
  }

  //TODO: get transaction history by user_id and filter by status
  Future<void> getHistoryByStatus(String status) async {
    try {
      final history = await _firestore
          .collection('transactions')
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .where('status', isEqualTo: status)
          .get();
      userHistory = history.docs.map((e) => {...e.data(), 'id': e.id}).toList();
      print(userHistory);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
