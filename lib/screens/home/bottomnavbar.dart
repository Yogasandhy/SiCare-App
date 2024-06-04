// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sicare_app/screens/medical_record/medicalrecordScreen.dart';
import 'package:sicare_app/screens/profile/profileScreen.dart';
import 'home_screen.dart';

class BottomnavbarScreen extends StatefulWidget {
  const BottomnavbarScreen({super.key});

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: _onItemTapped,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
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
