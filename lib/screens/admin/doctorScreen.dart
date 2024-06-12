import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_card.dart';
import '../../providers/doctorProvider.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key});

  Future<void> _refreshData(BuildContext context) async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    await doctorProvider.refreshDoctors();
  }

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
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: provider.getAllDoctorsWithAvailableDates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final doctors = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctorData = doctors[index];
                      final doctorId = doctorData['id'];
                      final availableDates = doctorData['available_dates'];

                      return DoctorCard(
                        doctorId: doctorId,
                        doctorData: doctorData,
                        availableDates: availableDates,
                        isAdmin: true,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
