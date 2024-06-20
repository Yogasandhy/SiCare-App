import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/medical_record/cancel_booking_screen.dart';

import '../../providers/Auth.dart';

class MedicalRecordDetail extends StatelessWidget {
  const MedicalRecordDetail({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final authC = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Janji Temu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: authC.userStreamById(data['history_data']['user_id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final userData = (snapshot.data as dynamic).data();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // doctor profile card
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        //doctor image
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              data['doctor_data']['imageUrl'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        //doctor details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['doctor_data']['nama'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data['doctor_data']['posisi'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Color(0xFF0E82FD),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data['doctor_data']['lokasi'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xffD3D3D3).withOpacity(0.3),
                  thickness: 8,
                ),
                // Booking details
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title
                        const Text(
                          'Jadwal Janji Temu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // date and time
                        ScheduleText(
                          title: 'Tanggal & Waktu',
                          doubleText: true,
                          date: data['history_data']['date'],
                          time: data['history_data']['time'],
                        ),
                        const SizedBox(height: 20),
                        ScheduleText(
                          title: 'Durasi',
                          singleText: '1 Jam',
                        ),
                        const SizedBox(height: 20),
                        ScheduleText(
                          title: 'Total Biaya',
                          singleText: 'Rp. ${data['history_data']['price']}',
                        ),
                        const SizedBox(height: 20),
                        ScheduleText(
                          title: 'Pembayaran',
                          singleText: data['history_data']['payment_method']
                                  .substring(0, 1)
                                  .toUpperCase() +
                              data['history_data']['payment_method']
                                  .substring(1),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xffD3D3D3).withOpacity(0.3),
                  thickness: 8,
                ),
                // Patient details
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        const Text(
                          'Detail Pasien',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // patient name
                        ScheduleText(
                          title: 'Nama Lengkap',
                          singleText: userData['displayName'],
                        ),
                        const SizedBox(height: 20),
                        // patient gender
                        ScheduleText(
                          title: 'Jenis Kelamin',
                          singleText: userData['gender'] == ''
                              ? '-'
                              : (userData['gender'] == 'Male'
                                  ? 'Laki-Laki'
                                  : (userData['gender'] == 'Female'
                                      ? 'Perempuan'
                                      : '-')),
                        ),
                        const SizedBox(height: 20),
                        // patient age
                        ScheduleText(
                          title: 'Umur',
                          singleText:
                              userData['age'] == '' ? '-' : userData['age'],
                        ),
                        const SizedBox(height: 20),
                        // patient diagnosis
                        ScheduleText(
                          title: 'Diagnosis',
                          singleText: data['history_data']['diagnosis'],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xffD3D3D3).withOpacity(0.3),
                  thickness: 8,
                ),
                const SizedBox(height: 10),
                //Reason for cancelling appointment
                (data['history_data']['status'] == 'Dibatalkan')
                    ? Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alasan Dibatalkan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              const SizedBox(height: 20),
                              Text(
                                data['history_data']['reason'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        data['history_data']['status'] == 'Aktif'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CancelBookingScreen(
                                    documentId: data['history_data']['id'],
                                    availableDocumentId: data['history_data']
                                        ['available_dates_id'],
                                    time: data['history_data']['time'],
                                  ),
                                ))
                            : null;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56),
                        backgroundColor:
                            data['history_data']['status'] == 'Aktif'
                                ? Color(0xff0E82FD)
                                : Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Batalkan Janji Temu',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ScheduleText extends StatelessWidget {
  const ScheduleText({
    super.key,
    required this.title,
    this.date = '',
    this.time = '',
    this.doubleText = false,
    this.singleText = '',
  });
  final String title;
  final bool? doubleText;
  final String? date;
  final String? time;
  final String? singleText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff4E4E4E),
          ),
        ),
        doubleText!
            ? Text(
                '$date | $time',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                singleText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }
}
