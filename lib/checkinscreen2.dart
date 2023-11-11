import 'dart:async';
import 'package:checkin_app/checkinscreen.dart';
import 'package:checkin_app/homescreen.dart';
import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';

class CheckinScreen2 extends StatefulWidget {
  const CheckinScreen2({super.key});

  @override
  State<CheckinScreen2> createState() => _CheckinScreen2State();
}

class _CheckinScreen2State extends State<CheckinScreen2> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn2 = '';

  String checkIn = '--/--';
  String checkOut = '--/--';
  String locationCheckin = " ";
  String locationCheckout = " ";
  Color primary = const Color.fromRGBO(12, 45, 92, 1);

  List<String> locationPage = [
    "location 1",
    "location 2",
    "location 3",
    "location 4",
    "location 5",
    "location 6",
    "location 7",
    "location 8",
    "location 9",
    "location 10",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecord();
  }

  void _getLocationCheckin() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(Users.lat, Users.long);
    setState(() {
      locationCheckin =
          "${placemark[0].street} ${placemark[0].administrativeArea} ${placemark[0].postalCode} ${placemark[0].country}";
    });
  }

  void _getLocationCheckout() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(Users.lat, Users.long);
    setState(() {
      locationCheckout =
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
        .collection('Location')
        .doc('Location 2')
        .set({
      'Datetime': Timestamp.now(),
      'Checkin': DateFormat('hh:mm').format(DateTime.now()),
      'Checkout': '--/--',
      'Location_Checkin': locationCheckin,
      'Location_Checkout': '',
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
        .collection('Location')
        .doc('Location 2')
        .update({
      'Datetime': Timestamp.now(),
      'Checkin': checkIn2,
      'Checkout': DateFormat('hh:mm').format(DateTime.now()),
      'Location_Checkin': locationCheckin,
      'Location_Checkout': locationCheckout,
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
          .collection('Location')
          .doc('Location 2')
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
    String dropdownValue = locationPage[1];
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                'Welcome 2',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaRegular',
                    fontSize: screenWidth / 20),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      Users.username,
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: DropdownMenu<String>(
                      label: const Text('Location'),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontFamily: 'NexaBold',
                      ),
                      initialSelection: locationPage[1],
                      dropdownMenuEntries: locationPage
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                        if (dropdownValue == 'location 1') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreeen()),
                          );
                        } else if (dropdownValue == 'location 2') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckinScreen2()),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
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
                          .collection('Location')
                          .doc('Location 2')
                          .get();

                      try {
                        _getLocationCheckout();
                        checkIn2 = snap2['Checkin'];
                        setState(() {
                          checkOut = DateFormat('hh:mm').format(DateTime.now());
                        });
                        updateRecordDetails(checkIn2);
                      } catch (e) {
                        _getLocationCheckin();
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
            locationCheckin != " "
                ? Text("locationCheckin" + locationCheckin)
                : SizedBox(),
            locationCheckout != " "
                ? Text("locationCheckin" + locationCheckout)
                : SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreeen()),
                    );
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.home,
                            color: primary,
                            size: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            height: 3,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              color: primary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
