import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  var userHistory = [];
  var userFilteredHistory = [];
  var allTransactions = [];
  var allTransactionsFiltered = [];
  var selectedHistory = 'Aktif';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void changeHistory(String history) {
    selectedHistory = history;
    notifyListeners();
  }

  void filterHistory(String status) {
    userFilteredHistory =
        userHistory.where((element) => element['status'] == status).toList();
    _sortByDate(userFilteredHistory);
    notifyListeners();
  }

  void filterAllTransactions(String status) {
    allTransactionsFiltered = allTransactions
        .where((element) => element['status'] == status)
        .toList();
    _sortByDate(allTransactionsFiltered);
    notifyListeners();
  }

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

  Future<void> getAllTransactions() async {
    try {
      final transactions = await _firestore.collection('transactions').get();
      allTransactions =
          transactions.docs.map((e) => {...e.data(), 'id': e.id}).toList();
      filterAllTransactions(selectedHistory); // Filter after fetching
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelBooking(String id, String status, String reason,
      String availableDocumentId, String timeBooked) async {
    try {
      await _firestore.collection('transactions').doc(id).update({
        'status': status,
        'reason': reason,
      });

      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('available_dates')
          .doc(availableDocumentId)
          .get();
      List<String> slots = List<String>.from(doc.data()!['slots']);

      int insertIndex = slots.indexWhere((slot) =>
          int.parse(slot.replaceAll(':', '')) >
          int.parse(timeBooked.replaceAll(':', '')));

      if (insertIndex == -1) {
        slots.add(timeBooked);
      } else {
        slots.insert(insertIndex, timeBooked);
      }

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

  // change status to selesai
  Future<void> finishBooking(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).update({
        'status': 'Selesai',
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> refreshTransactions() async {
    await getAllTransactions();
    notifyListeners();
  }

  Future<void> refreshUserHistory() async {
    await getHistory();
    filterHistory(selectedHistory);
    notifyListeners();
  }

  void _sortByDate(List transactions) {
    transactions.sort((a, b) {
      DateTime dateA = a['created_at'].toDate();
      DateTime dateB = b['created_at'].toDate();
      return dateB.compareTo(dateA); // Sort in descending order
    });
  }
}
