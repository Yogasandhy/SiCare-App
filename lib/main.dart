import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/providers/AddDoctorProvider.dart';
import 'package:sicare_app/providers/doctorProvider.dart';
import 'package:sicare_app/providers/historyProvider.dart';
import 'package:sicare_app/providers/profileProvider.dart';
import 'package:sicare_app/providers/userDataProvider.dart';
import 'package:sicare_app/screens/opening/splashScreen.dart';
import 'package:sicare_app/firebase_options.dart';
import 'package:sicare_app/providers/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> _onWillPop() async {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddDoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => (UserProvider())  ,
        ),
      ],
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0E82FD),
            ),
            useMaterial3: true,
            fontFamily: "PlusJakartaSans",
          ),
          navigatorKey: _navigatorKey,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
