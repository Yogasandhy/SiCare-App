import 'package:flutter/material.dart';
import 'package:sicare_app/screens/medical_record/medicalrecordScreen.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/admin/doctorScreen.dart';
import 'package:sicare_app/screens/admin/patientScreen.dart';
import 'package:sicare_app/screens/medicalrecordScreen.dart';
import 'package:sicare_app/screens/profile/profileScreen.dart';
import 'package:sicare_app/screens/home/home_screen.dart';
import '../../providers/Auth.dart';

class BottomnavbarScreen extends StatefulWidget {
  const BottomnavbarScreen({super.key});
  final bool isAdmin;

  const BottomnavbarScreen({super.key, this.isAdmin = false});

  @override
  _BottomnavbarScreenState createState() => _BottomnavbarScreenState();
}

class _BottomnavbarScreenState extends State<BottomnavbarScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    HomeScreen(),
    MedicalRecordScreen(),
    ProfileScreen(),
  ];
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

        return Scaffold(
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
                          label: 'Medical',
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
        );
      },
    );
  }
}
