import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int index = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          index = (index + 1) % 3;
        });
        _controller.reset();
      }
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: index == 0
                  ? ScaleTransition(
                      scale: _animation,
                      child: Image.asset('assets/SiCare.png',
                          width: 300, height: 300),
                    )
                  : index == 1
                      ? ScaleTransition(
                          scale: _animation,
                          child: Image.asset('assets/mainlogo.png'),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 50, top: 25),
                                    child: ScaleTransition(
                                      scale: _animation,
                                      child: const Text(
                                        'Your Health, Our Priority',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
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
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: ScaleTransition(
                                scale: _animation,
                                child: Image.asset('assets/mainlogo.png'),
                              ),
                            ),
                          ],
                        )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
