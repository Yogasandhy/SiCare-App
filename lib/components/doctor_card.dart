import 'package:flutter/material.dart';
import 'package:sicare_app/components/day_text.dart';

import 'doctor_badge.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctorData,
    required this.days,
  });

  final Map<String, dynamic> doctorData;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(doctorData['imageUrl']),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorBadge(
                        icon: Icons.verified,
                        iconColor: Color(0xff0E82FD),
                        title: 'Proffesional Doctor',
                        color: Color(0xff6EB4FE).withOpacity(0.5),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctorData['nama'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctorData['posisi'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          DoctorBadge(
                            icon: Icons.work,
                            iconColor: Color(0xff7A7A7A),
                            title: '${doctorData['pengalaman']} Years',
                            color: Color(0xffD3D3D3).withOpacity(0.5),
                          ),
                          SizedBox(width: 8),
                          DoctorBadge(
                            icon: Icons.star,
                            iconColor: Color(0xff7A7A7A),
                            title: '${doctorData['rating']}',
                            color: Color(0xffD3D3D3).withOpacity(0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 4),
                  Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  // show days from list give padding
                  for (var day in days)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      child: DayText(day: day),
                    ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rp. ${doctorData['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(156, 40),
                    backgroundColor: Color(0xff0E82FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    'Make Appointment',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
