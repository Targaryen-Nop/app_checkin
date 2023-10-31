import 'package:checkin_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String birthDate = 'Date of Birth';

  Color primary = Color.fromRGBO(12, 45, 92, 1);
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 80, bottom: 24),
            height: 120,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: primary),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Username : ${Users.username}',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          textField("First Name", "First Name"),
          textField("Last Name", "Last Name"),
 
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Date of Birth',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                              primary: primary,
                              secondary: primary,
                              onSecondary: Colors.white),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(primary: primary),
                          ),
                          textTheme: TextTheme(
                            headline4: TextStyle(fontFamily: 'NexaBold'),
                            overline: TextStyle(fontFamily: 'NexaBold'),
                            button: TextStyle(fontFamily: 'NexaBold'),
                          )),
                      child: child!);
                },
              ).then((value) {
                setState(() {
                  birthDate = DateFormat('dd/MM/yyyy').format(value!);
                });
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: kToolbarHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black54),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 11, top: 10),
                margin: EdgeInsets.only(bottom: 12),
                alignment: Alignment.centerLeft,
                child: Text(
                  birthDate,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(String hint, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontFamily: "NexaBold",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 12),
          child: TextFormField(
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 14,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
