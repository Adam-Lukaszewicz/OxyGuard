import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); //TODO: Sprawdzić czy to powinno istnieć
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;

  void checkGPSPermission() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service isn't enabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
