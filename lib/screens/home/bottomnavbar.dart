import 'package:flutter/material.dart';
import 'package:sicare_app/screens/admin/doctorScreen.dart';
import 'package:sicare_app/screens/admin/patientScreen.dart';
import 'package:sicare_app/screens/medicalrecordScreen.dart';
import 'package:sicare_app/screens/profile/profileScreen.dart';
import 'package:sicare_app/screens/home/home_screen.dart';

class BottomnavbarScreen extends StatefulWidget {
  final bool isAdmin;

  const BottomnavbarScreen({super.key, this.isAdmin = false});

  @override
  _BottomnavbarScreenState createState() => _BottomnavbarScreenState();
}

class _BottomnavbarScreenState extends State<BottomnavbarScreen> {
  int _selectedIndex = 0;

  List<Widget> get _adminWidgetOptions => [
        HomeScreen(isAdmin: true),
        DoctorScreen(),
        Patientscreen(),
        ProfileScreen(),
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
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions =
        widget.isAdmin ? _adminWidgetOptions : _userWidgetOptions;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
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
            items: widget.isAdmin
                ? <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ColorFiltered(
                          colorFilter: _selectedIndex == 0
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          child: Image.asset('assets/doctor.png'),
                        ),
                      ),
                      label: 'Dokter',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ColorFiltered(
                          colorFilter: _selectedIndex == 2
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          child: Image.asset('assets/user.png'),
                        ),
                      ),
                      label: 'Profil',
                    ),
                  ]
                : <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ColorFiltered(
                          colorFilter: _selectedIndex == 0
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          child: Image.asset('assets/file.png'),
                        ),
                      ),
                      label: 'Medical',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ColorFiltered(
                          colorFilter: _selectedIndex == 2
                              ? ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                              : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          child: Image.asset('assets/user.png'),
                        ),
                      ),
                      label: 'Profile',
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
