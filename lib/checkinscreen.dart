import 'dart:async';
import 'package:checkin_app/checkinscreen2.dart';
import 'package:checkin_app/homescreen.dart';
import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


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
  String locationCheckin = " ";
  String locationCheckout = " ";
  Color primary = const Color.fromRGBO(12, 45, 92, 1);
  bool check = false;
  late Position currentLocation;

   final List<Marker> _list = [
    Marker(
        markerId: const MarkerId('1'),
        position: LatLng(Users.lat, Users.long),
        infoWindow: const InfoWindow(title: 'You are Here !'))
  ];

  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _maker = [];

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
    _maker.addAll(_list);
    _getRecord();
    
   
  }

  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnable = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnable) {
  //     return Future.error('Location service are Disable');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permission are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissino are denied, we cannot request');
  //   }

  //   return Geolocator.getCurrentPosition();
  // }


  void _getLocationCheckin() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(Users.lat, Users.long);
    setState(() {
      locationCheckin =
          "${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].thoroughfare} ${placemark[0].subAdministrativeArea}  ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].postalCode}  ${placemark[0].country}";
    });
  }

  void _getLocationCheckout() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(Users.lat, Users.long);
    setState(() {
      locationCheckout =
          "${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].thoroughfare} ${placemark[0].subAdministrativeArea}  ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].postalCode}  ${placemark[0].country}";
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
        .doc('Location 1')
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
        .doc('Location 1')
        .update({
      'Datetime': Timestamp.now(),
      'Checkin': checkIn2,
      'Checkout': DateFormat('hh:mm').format(DateTime.now()),
      'Location_Checkin': locationCheckin,
      'Location_Checkout': locationCheckout,
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckinScreen2()),
    );
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
          .doc('Location 1')
          .get();
      setState(() {
        checkIn = snap2['Checkin'];
        checkOut = snap2['Checkout'];
      });
      // ignore: use_build_context_synchronously
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  Future _goToMe(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
    )));
    _maker.add(
      Marker(
        markerId: const MarkerId('2'),
        position: LatLng(lat, long),
        infoWindow: const InfoWindow(
            title: 'My Current Position', snippet: 'ที่อยุ๋ปัจจุบัน'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String dropdownValue = locationPage.first;
    print(Users.lat);
    print(Users.long);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                'Welcome 1',
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
                      initialSelection: dropdownValue,
                      dropdownMenuEntries: locationPage
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                      onSelected: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                        // This is called when the user selects an item.
                        if (dropdownValue == 'location 1') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreeen()),
                          );
                        } else if (dropdownValue == 'location 2') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckinScreen2()),
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
              width: 400,
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(Users.lat, Users.long),
                  zoom: 16,
                ),
                markers: Set<Marker>.of(_maker),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
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
                          .doc('Location 1')
                          .get();

                      try {
                        _goToMe(Users.lat, Users.long);
                        _getLocationCheckout();
                        checkIn2 = snap2['Checkin'];
                        setState(() {
                          checkOut = DateFormat('hh:mm').format(DateTime.now());
                        });
                        updateRecordDetails(checkIn2);
                      } catch (e) {
                        _goToMe(Users.lat, Users.long);
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
    );
  }
}
