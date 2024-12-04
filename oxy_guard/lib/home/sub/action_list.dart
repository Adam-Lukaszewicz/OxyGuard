import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:oxy_guard/services/internet_serivce.dart';
import 'package:watch_it/watch_it.dart';

import '../../services/gps_service.dart';

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
    } on PlatformException catch (err) {
      return Future.error(err);
    } catch (err) {
      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbService = GetIt.I.get<DatabaseService>();
    var internetService = GetIt.I.get<InternetService>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Dołącz do trwającej akcji"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02),
          child: internetService.offlineMode
              ? Column(
                  children: [
                    Expanded(
                        child: FutureBuilder(
                            future: dbService.readActionFromFile(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  Card localRejoin = Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () {
                                        dbService.currentAction =
                                            snapshot.data!;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SquadChoice()));
                                      },
                                      title: const Text(
                                        "Akcja offline",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                      subtitle: const Text(
                                        "Brak znanego adresu",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                  return ListView(
                                    children: [localRejoin],
                                  );
                                } else {
                                  return const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Brak akcji stworzonych w trybie offline, stwórz nową akcję lub połącz się z internetem i zaloguj aby wyszukać trwające",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              }
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ],
                              );
                            })),
                    const Expanded(
                      child: Text(
                        "Zaloguj się, aby przechowywać i archiwizować akcje",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                          stream: dbService.getActions(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ],
                              );
                            }
                            List<(Position, Card)> preSort =
                                snapshot.data!.docs.map((action) {
                              Position actionLocation = Position.fromMap(
                                  jsonDecode(action["Location"]!));
                              return (
                                actionLocation,
                                Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    child: InkWell(
                                      child: FutureBuilder(
                                        future: placemarkFromCoordinates(
                                            actionLocation.latitude,
                                            actionLocation.longitude),
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                              ConnectionState.done) {
                                            if (snap.hasData) {
                                              final address =
                                                  "${snap.data!.first.street}";
                                              final city =
                                                  "${snap.data!.first.locality}";
                                              return ListTile(
                                                title: Text(
                                                  city,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                                subtitle: Text(
                                                  address,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //MOŻLIWY BUG: nie wiem czy ta logika pokryje brak lokalizacji w akcji (czy brak actionlocation spowoduje snap.hasError czy cos co nie jest handlowane)
                                              );
                                            } else if (snap.hasError) {
                                              return const ListTile(
                                                title: Text(
                                                    "Brak pasującego adresu/nazwy akcji"),
                                              );
                                            }
                                          }
                                          return const ListTile(
                                            title: Text("Ładowanie..."),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        dbService.joinAction(action.id);
                                        dbService.currentAction =
                                            action.data() as ActionModel;
                                        dbService.currentAction
                                            .listenToChanges();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SquadChoice()));
                                      },
                                    ))
                              );
                            }).toList();
                            if (GetIt.I.get<GpsService>().permission ==
                                    LocationPermission.always ||
                                GetIt.I.get<GpsService>().permission ==
                                    LocationPermission.whileInUse) {
                              return FutureBuilder(
                                future: Geolocator.getCurrentPosition(),
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.done) {
                                    if (snap.hasData) {
                                      Position currentPostion = snap.data!;
                                      preSort.sort((a, b) {
                                        double distanceToA =
                                            Geolocator.distanceBetween(
                                                currentPostion.latitude,
                                                currentPostion.longitude,
                                                a.$1.latitude,
                                                a.$1.longitude);
                                        double distanceToB =
                                            Geolocator.distanceBetween(
                                                currentPostion.latitude,
                                                currentPostion.longitude,
                                                b.$1.latitude,
                                                b.$1.longitude);
                                        return distanceToA
                                            .compareTo(distanceToB);
                                      });
                                      return ListView(
                                        children:
                                            preSort.map((e) => e.$2).toList(),
                                      );
                                    }
                                  }
                                  return const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return ListView(
                                children: preSort.map((e) => e.$2).toList(),
                              );
                            }
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
