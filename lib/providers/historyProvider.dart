import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  var userHistory = [];
  var userFilteredHistory = [];
  var selectedHistory = 'Aktif';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void changeHistory(String history) {
    selectedHistory = history;
    notifyListeners();
  }

  //TODO: find transaction history by status
  void filterHistory(String status) {
    userFilteredHistory =
        userHistory.where((element) => element['status'] == status).toList();
    notifyListeners();
  }

  //TODO: get transaction history by user_id
  Future<void> getHistory() async {
    try {
      final history = await _firestore
          .collection('transactions')
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .get();
      userHistory = history.docs.map((e) => {...e.data(), 'id': e.id}).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  //TODO: cancel booking -> update status of transaction by document id
  Future<void> cancelBooking(String id, String status, String reason,
      String availableDocumentId, String timeBooked) async {
    try {
      await _firestore.collection('transactions').doc(id).update({
        'status': status,
        'reason': reason,
      });

      // fetch available dates slots
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('available_dates')
          .doc(availableDocumentId)
          .get();
      List<String> slots = List<String>.from(doc.data()!['slots']);

      // Find the correct position to insert the new time slot
      int insertIndex = slots.indexWhere((slot) =>
          int.parse(slot.replaceAll(':', '')) >
          int.parse(timeBooked.replaceAll(':', '')));

      // If no slot is found that is later than the new time slot, append the new time slot at the end
      if (insertIndex == -1) {
        slots.add(timeBooked);
      } else {
        slots.insert(insertIndex, timeBooked);
      }

      // update available dates slots
      await _firestore
          .collection('available_dates')
          .doc(availableDocumentId)
          .update({
        'slots': slots,
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
