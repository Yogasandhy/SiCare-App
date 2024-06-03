import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sicare_app/components/doctor_card.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctorData = doctors[index].data() as Map<String, dynamic>;
              final doctorId = doctors[index].id;

              return FutureBuilder<List<dynamic>>(
                future: _getAvailableDates(doctorId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final availableDates = snapshot.data!;
                    return DoctorCard(
                      doctorId: doctorId,
                      doctorData: doctorData,
                      availableDates: availableDates,
                      isAdmin: true,
                    );
                  }

                  return SizedBox(); 
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _getAvailableDates(String doctorId) async {
    final availableDatesSnapshot = await _firestore
        .collection('available_dates')
        .where('doctor_id', isEqualTo: doctorId)
        .get();

    return availableDatesSnapshot.docs.map((doc) => doc.data()).toList();
  }
}
