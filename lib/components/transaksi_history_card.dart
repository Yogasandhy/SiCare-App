import 'package:flutter/material.dart';

import '../screens/medical_record/medical_record_detail.dart';
import 'doctor_badge.dart';

class TransaksiHistoryCard extends StatelessWidget {
  const TransaksiHistoryCard({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
