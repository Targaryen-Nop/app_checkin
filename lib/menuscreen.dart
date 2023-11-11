
import 'package:checkin_app/checkinscreen.dart';
import 'package:checkin_app/homescreen.dart';
import 'package:checkin_app/loginscreen.dart';
import 'package:checkin_app/testlocation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreeen();
          } else {
            return const KeyboardVisibilityProvider(child: HomeScreeen(),);
          }
        },
      ),
    );
  }
}
