import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TestLocation extends StatefulWidget {
  const TestLocation({super.key});

  @override
  State<TestLocation> createState() => _TestLocationState();
}

class _TestLocationState extends State<TestLocation> {
  String locationMessage = 'Current Location of User';
  late String lat;
  late String long;

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
//Listen to Location Update

  // ignore: unused_element
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longtitude: $long';
      });
      _liveLocation();
    });
  }

  //Open Google map
  Future<void> _openMap(String lat, String long) async {
    var url = Uri.https('google.com');
  String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat},${long}';
    await canLaunchUrlString(googleUrl)
        ? await launchUrlString(googleUrl)
        : throw 'Cannot Launch $googleUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter User Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locationMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';

                  setState(() {
                    locationMessage = 'Latitude: $lat, Longtitude: $long';
                  });
                });
              },
              child: const Text('Get Current Location'),
            ),
            ElevatedButton(
              onPressed: () {
                _openMap(lat, long);
              },
              child: const Text('Open Google map'),
            )
          ],
        ),
      ),
    );
  }
}
