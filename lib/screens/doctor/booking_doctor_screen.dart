import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sicare_app/providers/doctorProvider.dart';
import 'package:sicare_app/screens/doctor/payment_screen.dart';
import '../../components/payment_card.dart';

class BookingPage extends StatefulWidget {
  final String doctorId;
  final String selectedDate;
  final String selectedTime;

  BookingPage({
    required this.doctorId,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<String, dynamic>? doctorData;
  bool _isLoading = true;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    getDoctorData();
  }

  Future<void> getDoctorData() async {
    final doctorProvider = DoctorProvider();
    final data = await doctorProvider.getDoctorData(widget.doctorId);
    setState(() {
      doctorData = data['doctor'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(doctorData?['imageUrl']),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorData?['nama'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4E4E4E),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        doctorData?['posisi'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue, size: 16),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            doctorData?['lokasi'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 30.0,
            color: Color(0xFFD3D3D3),
            thickness: 6.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date & Hour'),
                    Text('${widget.selectedDate} | ${widget.selectedTime}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Duration'),
                    Text('1 hour',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount'),
                    Text(
                        'Rp ${NumberFormat("#,##0", "en_US").format(int.parse(doctorData?['price'] ?? '0'))}',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 30.0,
            color: Color(0xFFD3D3D3),
            thickness: 6.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                ListTile(
                  leading:
                      Image.asset('assets/payment.png', color: Colors.blue),
                  title: Text('Select Payment Method'),
                ),
                ...paymentMethods.map((method) {
                  return PaymentMethodCard(
                    imagePath: method['imagePath']!,
                    title: method['title']!,
                    value: method['value']!,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payment : ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        'Rp ${NumberFormat("#,##0", "en_US").format(int.parse(doctorData?['price'] ?? '0'))}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            bookingData: {
                              'doctor': doctorData,
                              'selectedDate': widget.selectedDate,
                              'selectedTime': widget.selectedTime,
                            },
                          ),
                        ),
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
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
