import 'dart:async';
import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn2 = '';

  String checkIn = '--/--';
  String checkOut = '--/--';
  String location = " ";
  Color primary = Color.fromRGBO(12, 45, 92, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecord();
  }

  void _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(Users.lat, Users.long);
    setState(() {
      location =
          "${placemark[0].street} ${placemark[0].administrativeArea} ${placemark[0].postalCode} ${placemark[0].country}";
    });
  }

  Future addRecordDetails() async {
    QuerySnapshot sanp = await FirebaseFirestore.instance
        .collection("Employee")
        .where('username', isEqualTo: Users.username)
        .get();
    await FirebaseFirestore.instance
        .collection('Employee')
        .doc(sanp.docs[0].id)
        .collection('Record')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .set({
      'Datetime': Timestamp.now(),
      'Checkin': DateFormat('hh:mm').format(DateTime.now()),
      'Checkout': '--/--',
      'Location': location,
    });
  }

  Future updateRecordDetails(String checkIn2) async {
    QuerySnapshot sanp = await FirebaseFirestore.instance
        .collection("Employee")
        .where('username', isEqualTo: Users.username)
        .get();
    await FirebaseFirestore.instance
        .collection('Employee')
        .doc(sanp.docs[0].id)
        .collection('Record')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .update({
      'Datetime': Timestamp.now(),
      'Checkin': checkIn2,
      'Checkout': DateFormat('hh:mm').format(DateTime.now()),
      'Location': location
    });
  }

  void _getRecord() async {
    try {
      QuerySnapshot sanp = await FirebaseFirestore.instance
          .collection("Employee")
          .where('username', isEqualTo: Users.username)
          .get();
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(sanp.docs[0].id)
          .collection('Record')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();
      setState(() {
        checkIn = snap2['Checkin'];
        checkOut = snap2['Checkout'];
      });
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                'Welcome',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaRegular',
                    fontSize: screenWidth / 20),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                Users.username,
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 18),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 30),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2))
                ],
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                                fontFamily: 'NexaRegular',
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(checkIn,
                              style: TextStyle(
                                  fontFamily: 'NexaBold',
                                  fontSize: screenWidth / 18,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                                fontFamily: 'NexaRegular',
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(checkOut,
                              style: TextStyle(
                                  fontFamily: 'NexaBold',
                                  fontSize: screenWidth / 18,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: 'NexaBold',
                      ),
                      children: [
                        TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                              fontFamily: 'NexaBold',
                              fontSize: screenWidth / 20,
                              color: Colors.black54),
                        )
                      ]),
                )),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18,
                          color: Colors.black54),
                    ),
                  );
                }),
            if (checkOut == '--/--')
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Builder(builder: (context) {
                  final GlobalKey<SlideActionState> key = GlobalKey();
                  return SlideAction(
                    text: checkIn == "--/--"
                        ? "Slide to Check In"
                        : "Slide to Check Out",
                    textStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: "NexaRegular",
                      fontSize: screenWidth / 18,
                    ),
                    outerColor: Colors.white,
                    innerColor: primary,
                    key: key,
                    onSubmit: () async {
                      

                      QuerySnapshot sanp = await FirebaseFirestore.instance
                          .collection("Employee")
                          .where('username', isEqualTo: Users.username)
                          .get();
                      DocumentSnapshot snap2 = await FirebaseFirestore.instance
                          .collection('Employee')
                          .doc(sanp.docs[0].id)
                          .collection('Record')
                          .doc(
                              DateFormat('dd MMMM yyyy').format(DateTime.now()))
                          .get();

                      try {
                        checkIn2 = snap2['Checkin'];
                        setState(() {
                          checkOut = DateFormat('hh:mm').format(DateTime.now());
                        });
                        updateRecordDetails(checkIn2);
                      } catch (e) {
                        _getLocation();
                        setState(() {
                          checkIn = DateFormat('hh:mm').format(DateTime.now());
                        });
                        addRecordDetails();
                      }
                      key.currentState?.reset();
                    },
                  );
                }),
              )
            else
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Text(
                  'Today You have Check In',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
            location != " " ? Text("Location" + location) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
