import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/home/bottomnavbar.dart';

import '../../providers/historyProvider.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({
    super.key,
    required this.documentId,
    required this.availableDocumentId,
    required this.time,
  });
  final String documentId;
  final String availableDocumentId;
  final String time;

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  TextEditingController _otherReasonController = TextEditingController();
  List<String> reasons = [
    'Perubahan jadwal',
    'Kondisi cuaca',
    'Pekerjaan tak terduga',
    'Masalah mengasuh anak',
    'Penundaan Perjalanan',
  ];
  String reason = '';
  final String status = 'Dibatalkan';
  @override
  Widget build(BuildContext context) {
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Batalkan Janji Temu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Alasan membatalkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff7A7A7A),
                          ),
                        ),
                        // radio button for cancellation reason
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reasons.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                reasons[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              leading: Radio(
                                activeColor: Color(0xff0E82FD),
                                value: reasons[index],
                                groupValue: reason,
                                onChanged: (value) {
                                  setState(() {
                                    reason = value.toString();
                                  });
                                  print(reason);
                                },
                              ),
                            );
                          },
                        ),
                        //other reason
                      ],
                    ),
                  ),
                  Divider(
                    color: Color(0xffD3D3D3).withOpacity(0.3),
                    thickness: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lainnya',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // text field for other reason
                        TextField(
                          controller: _otherReasonController,
                          onChanged: (value) {
                            setState(() {
                              reason = value;
                            });
                            print(reason);
                          },
                          onTap: () {
                            setState(() {
                              reason = '';
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Masukkan alasan lainnya',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xff7A7A7A),
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //cancel appointment button
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
                  //show dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actionsPadding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 14),
                        title: Text(
                          'Cancel scheduled appointment?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'You will permanently cancel this appointment.',
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
                                historyProvider.cancelBooking(
                                  widget.documentId,
                                  status,
                                  reason,
                                  widget.availableDocumentId,
                                  widget.time,
                                );
                                //show success message on snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Janji temu berhasil dibatalkan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Color(0xff0E82FD),
                                  ),
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomnavbarScreen(
                                        indexHalaman: 1,
                                      ),
                                    ));
                              } catch (e) {
                                //show error message on snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Color(0xff0E82FD),
                                  )),
                            ),
                            child: Text(
                              'Ya, Lanjutkan',
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
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: Color(0xff0E82FD),
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
  }
}
