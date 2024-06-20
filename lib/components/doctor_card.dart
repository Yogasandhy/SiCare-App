import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/day_text.dart';
import 'package:sicare_app/providers/doctorProvider.dart';
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
                            title: '${doctorData['pengalaman']}',
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
                    'Jadwal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  if (days.isEmpty) DayText(day: 'Tidak ada jadwal'),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${NumberFormat("#,##0", "id_ID").format(double.parse((doctorData['price'] ?? '0').replaceAll(',', '').replaceAll('.', '')))}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                if (isAdmin) ...[
                  ClipOval(
                    child: Material(
                      color: Color(0xff0E82FD), // Button color
                      child: InkWell(
                        splashColor: Colors.blueAccent, // Splash color
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditDoctorScreen(doctorId: doctorId),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ClipOval(
                    child: Material(
                      color: Colors.red, // Button color
                      child: InkWell(
                        splashColor: Colors.redAccent, // Splash color
                        onTap: () {
                          // Alert dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Hapus Dokter ${doctorData['nama']} ?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: Text(
                                  'Anda akan menghapus data dokter ini secara permanen.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Color(0xff0E82FD),
                                        )),
                                  ),
                                  child: Text(
                                    'Tidak, Batalkan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff0E82FD),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await Provider.of<AddDoctorProvider>(
                                              context,
                                              listen: false)
                                          .deleteDoctor(doctorId);
                                      await Provider.of<DoctorProvider>(context,
                                              listen: false)
                                          .refreshDoctors();
                                      Navigator.pop(context);
                                      // snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Berhasil menghapus dokter'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (e) {
                                      print('Failed to delete doctor: $e');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff0E82FD),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Color(0xff0E82FD),
                                        )),
                                  ),
                                  child: Text(
                                    'Ya, Lanjutkan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
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
                    child: Text('Buat Janji Temu',
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
