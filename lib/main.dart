import 'package:checkin_app/checkinscreen.dart';
import 'package:checkin_app/googlemap.dart';
import 'package:checkin_app/homescreen.dart';
import 'package:checkin_app/loginscreen.dart';
import 'package:checkin_app/menuscreen.dart';
import 'package:checkin_app/model/user.dart';
import 'package:checkin_app/testlocation.dart';
import 'package:checkin_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: [MonthYearPickerLocalizations.delegate],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location service are Disable');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissino are denied, we cannot request');
    }
    return Geolocator.getCurrentPosition();
  }


  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeUser') != '') {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Employee")
            .where('username', isEqualTo: sharedPreferences.getString('employeeUser')!)
            .get();
        setState(() {

          Users.username = sharedPreferences.getString('employeeUser')!;
          Users.id = sharedPreferences.getString('employeeID')!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable
        ? const HomeScreeen()
        : const KeyboardVisibilityProvider(
            child: LoginScreen(),
          );
  }
}
