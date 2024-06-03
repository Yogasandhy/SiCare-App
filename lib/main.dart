import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/providers/AddDoctorProvider.dart';
import 'package:sicare_app/providers/doctorProvider.dart';
import 'package:sicare_app/providers/profileProvider.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          create: (context) => AddDoctorProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0E82FD),
          ),
          useMaterial3: true,
          fontFamily: "PlusJakartaSans",
        ),
        home: SplashScreen(),
      ),
    );
  }
}
