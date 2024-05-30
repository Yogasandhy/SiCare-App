import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_badge.dart';

import '../../providers/doctorProvider.dart';
import 'booking_doctor_screen.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({
    super.key,
    required this.doctorData,
    required this.availableDates,
  });
  final Map<String, dynamic> doctorData;
  final List<dynamic> availableDates;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  int selectedDate = 0;
  int selectedTime = 0;
  DateTime? selectedPickerDate;
  List<dynamic> noTimeHandler = [
    {
      'slots': ['No Time Available'],
    },
  ];
  List<dynamic> listSelectedAvailable = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSelectedAvailable = widget.availableDates;
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final baseDate = selectedPickerDate ?? DateTime.now();
    final days = List.generate(3, (index) {
      final date = baseDate.add(Duration(days: index));
      return DateFormat('EEE').format(date);
    });
    final formattedDates = List.generate(3, (index) {
      final date = baseDate.add(Duration(days: index));
      return DateFormat('dd MMM').format(date);
    });
    final thisMonth = DateFormat('MMM').format(DateTime.now());
    var todayTime = (selectedDate < listSelectedAvailable.length) 
      ? listSelectedAvailable[selectedDate]['slots'] 
      : noTimeHandler[0]['slots'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Doctor First Section Detail
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Image
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(widget.doctorData['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Doctor Detail
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Doctor Name
                        Text(
                          widget.doctorData['nama'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        //Doctor Position
                        Text(
                          widget.doctorData['posisi'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            DoctorBadge(
                              height: 41,
                              fontSize: 14,
                              icon: Icons.work,
                              iconColor: Color(0xff7A7A7A),
                              iconSize: 18,
                              title: '${widget.doctorData['pengalaman']} Years',
                              color: Color(0xffD3D3D3).withOpacity(0.5),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            DoctorBadge(
                              height: 41,
                              fontSize: 14,
                              icon: Icons.star,
                              iconColor: Color(0xff7A7A7A),
                              iconSize: 18,
                              title: '${widget.doctorData['rating']}',
                              color: Color(0xffD3D3D3).withOpacity(0.5),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        // Doctor Location
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                // Icon Location
                                Icon(
                                  Icons.location_on,
                                  size: 36,
                                  color: Color(0xff0E82FD),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // lokasi
                                    Text(
                                      widget.doctorData['lokasi'],
                                      style: TextStyle(
                                        color: Color(0xff4e4e4e),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Alamat Lokasi
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      widget.doctorData['lokasiDetail'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // Doctor Price
                                    Text(
                                      'Rp ${widget.doctorData['price']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Booking Appointment
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Appointment
                        Text(
                          'Book Appointment',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Booking Date
                        Text(
                          'Day',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Booking Date Card
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < days.length && i < 3; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDate = i;
                                  });
                                },
                                child: BookDateCard(
                                  day: days[i],
                                  date: formattedDates[i],
                                  isSelected: selectedDate == i,
                                ),
                              ),
                            GestureDetector(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 30)),
                                  initialDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  doctorProvider.getDoctorSchedule(
                                        widget.doctorData['id'],
                                        pickedDate,
                                      ).then((value){
                                        setState(() {
                                          listSelectedAvailable = value;
                                          selectedPickerDate = pickedDate;
                                          
                                        });
                                      });
                                  print(listSelectedAvailable.length);
                                }
                              },
                              child: BookDateCard(
                                icon: Icons.calendar_month,
                                date: thisMonth,
                                isSelected: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
// Booking Time
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 50),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: todayTime.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTime = index;
                                  });
                                },
                                child: Card(
                                  color: selectedTime == index
                                      ? Color(0xff0E82FD)
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      todayTime[index],
                                      style: TextStyle(
                                          color: selectedTime == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
// Divider
              const Divider(
                thickness: 10,
                color: Color(0xffF5F5F5),
              ),
// Doctor Second Section Detail
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//detail info title
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Detail Info',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
//detail info content
                    Text(
                      widget.doctorData['deskripsi'],
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
// Alumni
                    SizedBox(
                      height: 20,
                    ),
                    _detailInfoRow(
                      icon: Icons.school,
                      title: 'Alumni',
                      data: widget.doctorData['alumni'],
                    ),
// Lokasi Praktik
                    SizedBox(
                      height: 20,
                    ),
                    _detailInfoRow(
                      icon: Icons.location_on,
                      title: 'Lokasi Praktik',
                      data: widget.doctorData['lokasi'],
                    ),
// Keterangan
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Keterangan:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                          child: Text(
                            'Pembuatan janji disarankan minimal 2 hari sebelum waktu kunjungan.',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                          child: Text(
                            'Biaya layanan belum termasuk biaya administrasi.',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
// Button Book Appointment
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            doctorId: widget.doctorData['id'],
                            selectedDate: '${formattedDates[selectedDate]} ${DateFormat('yyyy').format(DateTime.parse(listSelectedAvailable[selectedDate]['date']))}',
                            selectedTime: todayTime[selectedTime],
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
                      'Make Appointment',
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
        ),
      ),
    );
  }

  Row _detailInfoRow({
    required IconData icon,
    required String title,
    required String data,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xff0E82FD),
          size: 36,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class BookDateCard extends StatelessWidget {
  const BookDateCard({
    super.key,
    this.day,
    required this.date,
    required this.isSelected,
    this.icon,
  });
  final String? day;
  final String date;
  final bool isSelected;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: icon != null
          ? Color(0xff6EB4FE).withOpacity(0.3)
          : isSelected
              ? Color(0xff0E82FD)
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Day
            icon != null
                ? Icon(
                    icon,
                    color: Color(0xff0E82FD),
                    size: 15,
                  )
                : Text(
                    day!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
            SizedBox(
              height: 4,
            ),
            // Date
            icon != null
                ? Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0E82FD),
                    ),
                  )
                : Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
