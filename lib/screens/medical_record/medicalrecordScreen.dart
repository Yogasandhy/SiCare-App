// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_badge.dart';
import 'package:sicare_app/providers/historyProvider.dart';
import 'package:sicare_app/screens/medical_record/medical_record_detail.dart';

import '../../components/transaksi_history_card.dart';
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: TransaksiHistoryCard(
                              data: {
                                'doctor_data': doctorData,
                                'history_data':
                                    value.userFilteredHistory[index],
                              },
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
