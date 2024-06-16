import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicare_app/providers/historyProvider.dart';
import 'package:sicare_app/screens/admin/appointment_screen.dart';
import 'package:sicare_app/screens/medical_record/medicalrecordScreen.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/admin/doctorScreen.dart';
import 'package:sicare_app/screens/admin/patientScreen.dart';
import 'package:sicare_app/screens/profile/profileScreen.dart';
import 'package:sicare_app/screens/home/home_screen.dart';
import '../../providers/Auth.dart';

class BottomnavbarScreen extends StatefulWidget {
  final bool isAdmin;
  final int indexHalaman;

  const BottomnavbarScreen(
      {super.key, this.isAdmin = false, this.indexHalaman = 0});

  @override
  _BottomnavbarScreenState createState() => _BottomnavbarScreenState();
}

class _BottomnavbarScreenState extends State<BottomnavbarScreen> {
  int _selectedIndex = 0;
  bool isDataLoaded = false;
  DateTime? lastPressed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDataLoaded) {
      Provider.of<HistoryProvider>(context, listen: false)
          .getHistory()
          .then((value) {
        setState(() {
          isDataLoaded = true;
        });
      });
    }
  }

  List<Widget> get _adminWidgetOptions => [
        HomeScreen(isAdmin: true),
        DoctorScreen(),
        PatientScreen(),
        AppointmentScreen(),
      ];

  List<Widget> get _userWidgetOptions => [
        HomeScreen(),
        MedicalRecordScreen(),
        ProfileScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexHalaman;
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      final now = DateTime.now();
      if (lastPressed == null ||
          now.difference(lastPressed!) > Duration(seconds: 2)) {
        lastPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      SystemNavigator.pop();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Provider.of<Auth>(context).getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        bool isAdmin = snapshot.data == 'admin';
        List<Widget> _widgetOptions =
            isAdmin ? _adminWidgetOptions : _userWidgetOptions;

        // Ensure the selected index is valid
        if (_selectedIndex >= _widgetOptions.length) {
          _selectedIndex = 0;
        }

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  showUnselectedLabels: true,
                  onTap: _onItemTapped,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  items: isAdmin
                      ? <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 0
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/home.png'),
                              ),
                            ),
                            label: 'Beranda',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 1
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/doctorIcon.png'),
                              ),
                            ),
                            label: 'Dokter',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 2
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/patient.png'),
                              ),
                            ),
                            label: 'Pasien',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 3
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/file.png'),
                              ),
                            ),
                            label: 'Appointment',
                          ),
                        ]
                      : <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 0
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/home.png'),
                              ),
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 1
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/file.png'),
                              ),
                            ),
                            label: 'Appointment',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ColorFiltered(
                                colorFilter: _selectedIndex == 2
                                    ? ColorFilter.mode(
                                        Colors.blue, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                child: Image.asset('assets/user.png'),
                              ),
                            ),
                            label: 'Profile',
                          ),
                        ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
