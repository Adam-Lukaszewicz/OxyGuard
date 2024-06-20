import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/models/personnel/personnel_model.dart';
import 'package:oxy_guard/services/database_service.dart';

class GlobalService { 
  static GlobalKey<NavigatorState> navigatorKey = 
  GlobalKey<NavigatorState>();
  static DatabaseSevice databaseSevice = DatabaseSevice();
  static bool serviceEnabled = false;
  static LocationPermission permission = LocationPermission.denied;
  static ActionModel currentAction = ActionModel();
  static PersonnelModel currentPersonnel = PersonnelModel();

  static void checkGPSPermission() async {

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    throw Exception("Location service isn't enabled"); 
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      throw Exception('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    throw Exception(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
}



}
