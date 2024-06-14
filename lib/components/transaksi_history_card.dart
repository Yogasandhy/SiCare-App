import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/home/bottomnavbar.dart';

import '../providers/historyProvider.dart';
import '../screens/medical_record/medical_record_detail.dart';
import 'doctor_badge.dart';

class TransaksiHistoryCard extends StatelessWidget {
  const TransaksiHistoryCard({
    super.key,
    required this.data,
    this.isAdmin = false,
  });

  final Map<String, dynamic> data;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicalRecordDetail(
                data: data,
              ),
            ));
      },
      child: Card(
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
                    data['doctor_data']['lokasi'],
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
                        'assets/${data['doctor_data']['posisi'].toLowerCase()}.png',
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
                        data['doctor_data']['posisi'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data['doctor_data']['nama'],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diagnosis',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data['history_data']['diagnosis'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  isAdmin && data['history_data']['status'] == 'Aktif'
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsPadding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 14),
                                  title: Text(
                                    'Finish scheduled appointment?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(
                                    'You will permanently finish this appointment.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff7A7A7A),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: Color(0xff0E82FD),
                                            )),
                                      ),
                                      child: Text(
                                        'No, Cancel',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff0E82FD),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          historyProvider.finishBooking(
                                              data['history_data']['id']);
                                          //show success message on snackbar
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Appointment finished successfully',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Color(0xff0E82FD),
                                            ),
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomnavbarScreen(
                                                  indexHalaman: 2,
                                                ),
                                              ));
                                        } catch (e) {
                                          //show error message on snackbar
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to cancel appointment',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0E82FD),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: Color(0xff0E82FD),
                                            )),
                                      ),
                                      child: Text(
                                        'Yes, Continue',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff0E82FD),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Color(0xff0E82FD),
                                )),
                          ),
                          child: Text('Selesai'))
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
