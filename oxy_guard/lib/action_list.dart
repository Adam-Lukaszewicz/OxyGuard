import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/models/action_model.dart';


import 'global_service.dart';

class ActionList extends StatefulWidget {
  const ActionList({super.key});

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  Future<List<Placemark>> getAddress(double latitude, double longitude) {
    Future<List<Placemark>> placemark;
    try {
      placemark = placemarkFromCoordinates(latitude, longitude);
      return placemark;
    }on PlatformException catch(err){
      print("Caught the odd one");
      return Future.error(err);
    }catch (err) {
      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: GlobalService.databaseSevice.getActions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    List<(Position, Card)> preSort = snapshot.data!.docs.map((action) {      
                      Position actionLocation = Position.fromMap(jsonDecode(action["Location"]!));
                      return (
                        actionLocation,
                        Card(
                            child: InkWell(
                          child: ListTile(
                            title: (action.data() as ActionModel).actionName.isNotEmpty ? Text((action.data() as ActionModel).actionName) : FutureBuilder(
                              future: placemarkFromCoordinates(actionLocation.latitude, actionLocation.longitude),
                              builder: (context, snap) {
                                if (snap.connectionState == ConnectionState.done) {
                                  if (snap.hasData) {
                                    final address = "${snap.data!.first.street}, ${snap.data!.first.locality}";
                                    return Text(address);
                                  } else if (snap.hasError) {
                                    return const Text("Brak pasującego adresu");
                                  }
                                }
                                return const Text("Loading...");
                              },
                            ),
                          ),
                          onTap: () {
                            GlobalService.databaseSevice.joinAction(action.id);
                            GlobalService.currentAction =
                                action.data() as ActionModel;
                            GlobalService.currentAction.listenToChanges();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SquadChoice()));
                          },
                        ))
                      );
                    }).toList();
                    if (GlobalService.permission == LocationPermission.always ||
                        GlobalService.permission ==
                            LocationPermission.whileInUse) {
                      return FutureBuilder(
                        future: Geolocator.getCurrentPosition(),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.done) {
                            if (snap.hasData) {
                              Position currentPostion = snap.data!;
                              preSort.sort((a, b) {
                                double distanceToA = Geolocator.distanceBetween(
                                    currentPostion.latitude,
                                    currentPostion.longitude,
                                    a.$1.latitude,
                                    a.$1.longitude);
                                double distanceToB = Geolocator.distanceBetween(
                                    currentPostion.latitude,
                                    currentPostion.longitude,
                                    b.$1.latitude,
                                    b.$1.longitude);
                                return distanceToA.compareTo(distanceToB);
                              });
                              return ListView(
                                children: preSort.map((e) => e.$2).toList(),
                              );
                            }
                          }
                          return const Text("LOADING");
                        },
                      );
                    } else {
                      return ListView(
                        children: preSort.map((e) => e.$2).toList(),
                      );
                    }
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Wróć")),
          ],
        ),
      ),
    );
  }
}
