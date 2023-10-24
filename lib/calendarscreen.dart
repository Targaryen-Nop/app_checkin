import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Color.fromRGBO(12, 45, 92, 1);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print(Users.id.runtimeType);
    print(Users.id);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 35 ),
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
                    DateFormat('MMMM').format(DateTime.now()),
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'NexaBold',
                        fontSize: screenWidth / 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    'Pick Month',
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'NexaBold',
                        fontSize: screenWidth / 18),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight / 1.5,
              color: Colors.red,
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
                        return Container(
                          margin: EdgeInsets.only(top: 12, right: 6,left: 6),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check In",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                        );
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
    );
  }
}
