import 'package:doctor/common/pdf_report.dart';
import 'package:doctor/provider/TimeProvider.dart';
import 'package:doctor/provider/counter.dart';
import 'package:doctor/screens/appointment_page.dart';
import 'package:doctor/screens/doctor_page.dart';
import 'package:doctor/screens/forgot_password.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:doctor/screens/login_page.dart';
import 'package:doctor/screens/profile_screen.dart';
import 'package:doctor/screens/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TimeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: "/",
        routes: {
          '/': (context) => const LoginPage(),
          '/signup': (context) => const Signup(),
          '/home': (context) => const MainPage(),
          '/report': (context) => const InvestigationReport(),
          '/book': (context) => AppointmentPage(),
          '/doctorPage': (context) => const DoctorPage(),
          '/profile': (context) => const ProfileScreen(),
          '/forgotPassword': (context) => const ForgotPassword(),
          '/pdfReport': (context) => PdfReport()
        },
      ),
    );
  }
}
