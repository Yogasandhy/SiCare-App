import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_card.dart';
import '../../providers/doctorProvider.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctors',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<DoctorProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: provider.getDoctors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final doctors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctorData =
                        doctors[index].data() as Map<String, dynamic>;
                    final doctorId = doctors[index].id;

                    return FutureBuilder<List<dynamic>>(
                      future:
                          provider.getDoctorSchedule(doctorId, DateTime.now()),
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

                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
