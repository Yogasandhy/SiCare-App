import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/admin/add_doctor_screen.dart';
import '../../components/doctor_card.dart';
import '../../providers/doctorProvider.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  const HomeScreen({super.key, this.isAdmin = false});

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
  void initState() {
    super.initState();
    print('isAdmin value is: ${widget.isAdmin}');
  }

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
                widget.isAdmin ? 'Dashboard' : 'Consultation With Doctor',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            if (widget.isAdmin) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(Icons.local_hospital, 'Doctor', '10 Doctors'),
                  SizedBox(width: 10),
                  _buildCard(Icons.people, 'Patient', '20 Patients'),
                  SizedBox(width: 10),
                  _buildCard(Icons.assignment, 'Record', '30 Records'),
                ],
              ),
            ] else ...[
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
            ],
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isAdmin ? 'Doctors' : 'Top Spesialist',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                widget.isAdmin
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddDoctorScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          backgroundColor: Color(0xff0E82FD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Add Doctor',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ))
                    : Container(),
              ],
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
                  doctorId: doctorData['id'],
                  doctorData: doctorData,
                  availableDates: availableDates,
                  isAdmin: widget.isAdmin,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(title,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(subtitle, style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
