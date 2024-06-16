import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/custom_appbar.dart';
import 'package:sicare_app/screens/admin/add_doctor_screen.dart';
import '../../components/doctor_card.dart';
import '../../providers/doctorProvider.dart';
import 'doctor_category_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  const HomeScreen({super.key, this.isAdmin = false});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final List<String> imagePaths = [
    'assets/doctor.png',
    'assets/dentist.png',
    'assets/heart.png',
    'assets/ear.png',
    'assets/intestine.png',
    'assets/moon.png',
    'assets/brain.png',
    'assets/health.png',
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

  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    print('isAdmin value is: ${widget.isAdmin}');
  }

  Future<void> _refreshData() async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    await doctorProvider.refreshDoctors();
    setState(() {});
  }

  void _onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      final doctorProvider =
          Provider.of<DoctorProvider>(context, listen: false);
      final results = await doctorProvider.searchDoctorsByName(value);
      setState(() {
        _isSearching = true;
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line
    final doctorP = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        isAdmin: widget.isAdmin,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SearchBar(
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {},
              onChanged: _onSearchChanged,
              leading: const Icon(Icons.search),
              hintText: 'Cari Dokter',
              controller: _searchController,
            ),
            SizedBox(height: 20.0),
            if (_isSearching) ...[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final doctorData = _searchResults[index]['doctor'];
                      final availableDates =
                          _searchResults[index]['available_dates'];
                      return DoctorCard(
                        doctorId: doctorData['id'],
                        doctorData: doctorData,
                        availableDates: availableDates,
                        isAdmin: widget.isAdmin,
                      );
                    },
                  ),
                ),
              ),
            ] else ...[
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
                    FutureBuilder<int>(
                      future: doctorP.getDoctorCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildCard(
                              Icons.local_hospital, 'Doctor', 'Loading...');
                        }
                        if (snapshot.hasError) {
                          return _buildCard(
                              Icons.local_hospital, 'Doctor', 'Error');
                        }
                        return _buildCard(Icons.local_hospital, 'Doctor',
                            '${snapshot.data} Doctors');
                      },
                    ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorCategoryScreen(
                              category: cardLabels[index],
                            ),
                          ),
                        );
                      },
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
                    'Doctors',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              FutureBuilder(
                future: doctorP.getAllDoctorsWithAvailableDates(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  }
                  final doctors = snapshot.data!;
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctorData = doctors[index];
                          return DoctorCard(
                            doctorId: doctorData['id'],
                            doctorData: doctorData,
                            availableDates: doctorData['available_dates'],
                            isAdmin: widget.isAdmin,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
