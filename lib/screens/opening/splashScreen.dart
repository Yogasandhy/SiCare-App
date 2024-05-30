// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/screens/home/bottomnavbar.dart';
import 'package:sicare_app/screens/home/home_screen.dart';
import 'package:sicare_app/screens/opening/welcomeScreen.dart';

import '../../providers/Auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int index = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          index = (index + 1) % 4;
        });
        _controller.reset();
      }
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    if (index == 3) {
      //check if user is logged in
      if (auth.isUserLoggedIn()) {
        Future.microtask(() {
          _timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomnavbarScreen()),
          );
        });
      } else {
      Future.microtask(() {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      });
      }
    }

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0E82FD),
              Color(0xff268FFD),
              Color(0xff3E9BFD),
              Color(0xff56A8FE),
              Color(0xff6EB4FE),
              Color(0xff8DDFEE),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: index == 0
                ? ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      'assets/SiCare.png',
                      width: 300,
                      height: 300,
                    ),
                  )
                : index == 1
                    ? ScaleTransition(
                        scale: _animation,
                        child: Image.asset('assets/mainlogo.png'),
                      )
                    : index == 2
                        ? Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 50, top: 25),
                                      child: ScaleTransition(
                                        scale: _animation,
                                        child: Text(
                                          'Your Health, Our Priority',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ScaleTransition(
                                      scale: _animation,
                                      child: Image.asset('assets/titikdua.png'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: ScaleTransition(
                                  scale: _animation,
                                  child: Image.asset('assets/mainlogo.png'),
                                ),
                              ),
                            ],
                          )
                        : Container(), 
          ),
        ),
      ),
    );
  }
}
