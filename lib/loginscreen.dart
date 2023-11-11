import 'package:checkin_app/homescreen.dart';
import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color.fromRGBO(12, 45, 92, 1);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation().then((value) {
      setState(() {
        Users.lat = value.latitude;
        Users.long = value.longitude;
      });
    });
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(
                  height: screenHeight / 20,
                )
              : Container(
                  height: screenHeight / 3,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(55))),
                  child: Center(
                      child: Image(
                    image: const AssetImage('assets/images/logo.png'),
                    height: screenHeight / 5,
                  )),
                ),
          Container(
            margin: EdgeInsets.only(
                top: screenHeight / 15, bottom: screenHeight / 25),
            child: Text(
              "Login",
              style:
                  TextStyle(fontSize: screenWidth / 18, fontFamily: "NexaBold"),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth / 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldTitle('Username'),
                customField(
                    'Username or Phone Number', _emailController, false),
                fieldTitle('Password'),
                customField('Password', _passwordController, false),
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Email in still empty!")));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Paswword in still empty !")));
                        } else {
                          QuerySnapshot sanp = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where('username', isEqualTo: email)
                              .get();

                          try {
                            if (password == sanp.docs[0]['password']) {
                              QuerySnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where('username', isEqualTo: email)
                                  .get();
                              setState(() {
                                Users.username = snap2.docs[0]['username'];
                                Users.id = snap2.docs[0].id;
                              });

                              sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  'employeeID', snap2.docs[0].id);
                              sharedPreferences
                                  .setString('employeeUser', email)
                                  .then((_) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreeen()));
                              });
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Paswword in wrong !")));
                            }
                          } catch (e) {
                            String error = '';

                            if (e.toString() ==
                                "RangeError (index): Invalid value: Valid value range is empty: 0") {
                              setState(() {
                                error = 'Employee is not exist';
                              });
                            } else {
                              setState(() {
                                error = 'Error occured';
                              });
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth / 26, fontFamily: "NexaBold"),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscureText) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth / 50),
      width: screenWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ]),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: screenWidth / 12),
            child: TextFormField(
              enableSuggestions: false,
              obscureText: obscureText,
              controller: controller,
              autocorrect: false,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint),
              maxLines: 1,
            ),
          ))
        ],
      ),
    );
  }
}
