import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/day_text.dart';
import 'package:sicare_app/screens/admin/edit_doctor_screen.dart';
import 'package:sicare_app/screens/doctor/doctor_detail_screen.dart';
import '../providers/AddDoctorProvider.dart';
import 'doctor_badge.dart';

class DoctorCard extends StatelessWidget {
  final bool isAdmin;
  final String doctorId;
  final Map<String, dynamic> doctorData;
  final List<dynamic> availableDates;

  const DoctorCard({
    Key? key,
    required this.doctorId,
    required this.doctorData,
    required this.availableDates,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = availableDates
        .map((e) => DateFormat('EEE').format(DateTime.parse(e['date'])))
        .toList();
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
                        fontSize: 12,
                        height: 28,
                        icon: Icons.verified,
                        iconColor: Color(0xff4E4E4E),
                        iconSize: 12,
                        title: 'Professional Doctor',
                        color: Color(0xff6EB4FE).withOpacity(0.5),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctorData['nama'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4E4E4E),
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
                            height: 28,
                            fontSize: 12,
                            icon: Icons.work,
                            iconColor: Color(0xff7A7A7A),
                            iconSize: 12,
                            title: '${doctorData['pengalaman']} Years',
                            color: Color(0xffD3D3D3).withOpacity(0.5),
                          ),
                          SizedBox(width: 8),
                          DoctorBadge(
                            height: 28,
                            fontSize: 12,
                            icon: Icons.star,
                            iconColor: Color(0xff7A7A7A),
                            iconSize: 12,
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
                  'Rp ${NumberFormat("#,##0", "id_ID").format(double.parse((doctorData['price'] ?? '0').replaceAll(',', '').replaceAll('.', '')))}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isAdmin
                    ? SizedBox(
                        width: 40.0,
                      )
                    : Spacer(),
                if (isAdmin) ...[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditDoctorScreen(doctorId: doctorId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        backgroundColor: Color(0xff0E82FD),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text('Edit',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        print('Deleting doctor with ID: $doctorId');
                        try {
                          await Provider.of<AddDoctorProvider>(context,
                                  listen: false)
                              .deleteDoctor(doctorId);
                          print('Doctor deleted successfully');
                        } catch (e) {
                          print('Failed to delete doctor: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: Text('Delete',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailScreen(
                            doctorData: doctorData,
                            availableDates: availableDates,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 40),
                      backgroundColor: Color(0xff0E82FD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    child: Text('Make Appointment',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
