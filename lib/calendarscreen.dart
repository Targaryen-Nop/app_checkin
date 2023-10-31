import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Color.fromRGBO(12, 45, 92, 1);

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Users.id != ""? Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 35, bottom: 20),
              child: Text(
                'My Attendance',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NexaBold',
                    fontSize: screenWidth / 18),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    _month,
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'NexaBold',
                        fontSize: screenWidth / 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 32),
                  child: GestureDetector(
                    onTap: () async {
                      int nowyear = new DateTime.now().year.toInt();
                      final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(nowyear),
                        lastDate: DateTime(2099),
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: primary,
                                      secondary: primary,
                                      onSecondary: Colors.white),
                                  textButtonTheme: TextButtonThemeData(
                                    style:
                                        TextButton.styleFrom(primary: primary),
                                  ),
                                  textTheme: TextTheme(
                                    headline4:
                                        TextStyle(fontFamily: 'NexaBold'),
                                    overline: TextStyle(fontFamily: 'NexaBold'),
                                    button: TextStyle(fontFamily: 'NexaBold'),
                                  )),
                              child: child!);
                        },
                      );

                      if (month != null) {
                        setState(() {
                          _month = DateFormat('MMMM').format(month);
                        });
                      }
                    },
                    child: Text(
                      'Pick Month',
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight / 1.45,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Employee')
                    .doc(Users.id)
                    .collection('Record')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return DateFormat('MMMM')
                                    .format(snap[index]['Datetime'].toDate()) ==
                                _month
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 12, right: 6, left: 6, bottom: 10),
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(2, 2))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(),
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                        child: Text(
                                            DateFormat('EE\n dd').format(
                                                snap[index]['Datetime']
                                                    .toDate()),
                                            style: TextStyle(
                                                fontFamily: 'NexaBold',
                                                fontSize: screenWidth / 20,
                                                color: Colors.white)),
                                      ),
                                    )),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Check In" ,
                                              style: TextStyle(
                                                  fontFamily: 'NexaRegular',
                                                  fontSize: screenWidth / 20,
                                                  color: Colors.black54),
                                            ),
                                            Text(snap[index]['Checkin'],
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Check Out",
                                              style: TextStyle(
                                                  fontFamily: 'NexaRegular',
                                                  fontSize: screenWidth / 20,
                                                  color: Colors.black54),
                                            ),
                                            Text(snap[index]['Checkout'],
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
                              )
                            : SizedBox();
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ):
    SizedBox();
  }
}
