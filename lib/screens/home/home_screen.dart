// ignore_for_file: prefer_const_constructors
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/doctor_card.dart';
import '../../providers/doctorProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imagePaths = [
    'assets/maki_doctor.png',
    'assets/dentist.png',
    'assets/love.png',
    'assets/ear.png',
    'assets/intestine.png',
    'assets/iconamoon.png',
    'assets/brain.png',
    'assets/healthicons.png',
  ];

  final List<String> cardLabels = [
    'Doctor',
    'Dentist',
    'Heart',
    'Ear',
    'Intestine',
    'Moon',
    'Brain',
    'Health',
  ];

  @override
  Widget build(BuildContext context) {
    final doctorP = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/mainlogobiru.png', fit: BoxFit.cover),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SearchBar(
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {},
              onChanged: (value) {},
              leading: const Icon(Icons.search),
              hintText: 'Cari Dokter',
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Consultation With Doctor',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            GridView.count(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              children: List.generate(imagePaths.length, (index) {
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Expanded(
                        child: Card(
                          color: Color.fromARGB(255, 183, 213, 246),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(imagePaths[index]),
                          ),
                        ),
                      ),
                      Text(cardLabels[index]),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 25.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top Spesialist',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            FutureBuilder(
              future: doctorP.getDoctorById("bUnT6Sv4vsCW7PzyrkwE"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final doctorData = snapshot.data!['doctor'];
                final availableDates = snapshot.data!['available_dates'];
                return DoctorCard(
                  doctorData: doctorData,
                  availableDates: availableDates,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
