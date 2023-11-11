import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:checkin_app/model/user.dart';

class GooglemapScreen extends StatefulWidget {
  const GooglemapScreen({super.key});

  @override
  State<GooglemapScreen> createState() => _GooglemapScreenState();
}

class _GooglemapScreenState extends State<GooglemapScreen> {
  String locationMessage = 'Current Location of User';
  double lat = 37.64;
  double long = 122;
  String locationCheckin = " ";
  late Position currentLocation;
  Completer<GoogleMapController> _controller = Completer();

  double result2 = double.parse('2');

  final List<Marker> _maker = [];
  final List<Marker> _list = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(Users.lat, Users.long),
        infoWindow: InfoWindow(title: 'You are Here !'))
  ];

  void _getLocationCheckin(double lat, double long) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    setState(() {
      locationCheckin =
          "${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].subAdministrativeArea}  ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].postalCode} ${placemark[0].country}";
    });
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;

      setState(() {
        locationMessage = 'Latitude: $lat, Longtitude: $long';
      });

      _liveLocation();
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

  Future _goToMe(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
    )));
    _maker.add(
      Marker(
          markerId: MarkerId('2'),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
              title: 'My Current Position', snippet: 'ที่อยุ๋ปัจจุบัน')),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _maker.addAll(_list);
    _getCurrentLocation().then((value) {
      setState(() {
        Users.lat = value.latitude;
        Users.long = value.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Users.lat);
    print(Users.long);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter User Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 600,
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
            Text(
              locationMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              locationCheckin,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = value.latitude;
                  long = value.longitude;

                  setState(() {
                    locationMessage = 'Latitude: $lat, Longtitude: $long';
                  });
                  setState(() {
                    lat = value.latitude;
                    long = value.longitude;
                  });
                });
              },
              child: const Text('Get Current Location'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});

                _getLocationCheckin(lat, long);
              },
              child: const Text('Get Location'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _goToMe(Users.lat, Users.long);
        },
        label: Text('My location'),
        icon: Icon(Icons.near_me),
      ),
    );
  }
}
