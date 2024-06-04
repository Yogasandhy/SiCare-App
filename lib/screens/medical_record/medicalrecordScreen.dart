// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_badge.dart';
import 'package:sicare_app/providers/historyProvider.dart';
import 'package:sicare_app/screens/medical_record/medical_record_detail.dart';

import '../../providers/doctorProvider.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false)
          .filterHistory('Aktif');
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/mainlogobiru.png', fit: BoxFit.cover),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // row for selecting aktif, selesai, dan dibatalkan
          Consumer<HistoryProvider>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: LinearBorder.bottom(
                          side: BorderSide(
                            color: value.selectedHistory == 'Aktif'
                                ? Color(0xff0E82FD)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        value.changeHistory('Aktif');
                        value.filterHistory('Aktif');
                      },
                      child: Text(
                        'Aktif',
                        style: TextStyle(
                          color: value.selectedHistory == 'Aktif'
                              ? Color(0xff0E82FD)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: LinearBorder.bottom(
                          side: BorderSide(
                            color: value.selectedHistory == 'Selesai'
                                ? Color(0xff0E82FD)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        value.changeHistory('Selesai');
                        value.filterHistory('Selesai');
                      },
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          color: value.selectedHistory == 'Selesai'
                              ? Color(0xff0E82FD)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shape: LinearBorder.bottom(
                          side: BorderSide(
                            color: value.selectedHistory == 'Dibatalkan'
                                ? Color(0xff0E82FD)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        value.changeHistory('Dibatalkan');
                        value.filterHistory('Dibatalkan');
                      },
                      child: Text(
                        'Dibatalkan',
                        style: TextStyle(
                          color: value.selectedHistory == 'Dibatalkan'
                              ? Color(0xff0E82FD)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // listview for medical record
          Consumer<HistoryProvider>(
            builder: (context, value, child) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: value.userFilteredHistory.length,
                    itemBuilder: (context, index) {
                      var doctorId =
                          value.userFilteredHistory[index]['doctor_id'];
                      return FutureBuilder(
                        future: doctorProvider.getDoctor(doctorId),
                        builder: (context, snapshot) {
                          var doctorData = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              print(value.userFilteredHistory[index]['id']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicalRecordDetail(
                                      data: {
                                        'doctor_data': doctorData,
                                        'history_data':
                                            value.userFilteredHistory[index],
                                      },
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TransaksiHistoryCard(
                                lokasiKonsultasi: doctorData!['lokasi'],
                                spesialis: doctorData['posisi'],
                                namaDokter: doctorData['nama'],
                                diagnosis: value.userFilteredHistory[index]
                                    ['diagnosis'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TransaksiHistoryCard extends StatelessWidget {
  const TransaksiHistoryCard({
    super.key,
    required this.lokasiKonsultasi,
    required this.spesialis,
    required this.namaDokter,
    required this.diagnosis,
  });

  final String lokasiKonsultasi;
  final String spesialis;
  final String namaDokter;
  final String diagnosis;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey.shade300,
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // badge konsultasi
            DoctorBadge(
              icon: Icons.verified,
              title: 'Konsultasi',
              color: Color(0xff6EB4FE).withOpacity(0.3),
              iconColor: Color(0xff0E82FD),
              height: 27,
              iconSize: 12,
              fontSize: 12,
              titleColor: Color(0xff0E82FD),
            ),
            SizedBox(
              height: 14,
            ),
            // lokasi konsultasi
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xff0E82FD),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  lokasiKonsultasi,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0E82FD),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            // informasi dokter
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff6EB4FE).withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/${spesialis.toLowerCase()}.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spesialis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      namaDokter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            //diagnosis
            Text(
              'Diagnosis',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              diagnosis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
