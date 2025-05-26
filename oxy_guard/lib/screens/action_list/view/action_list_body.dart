import 'package:OxyGuard/screens/action_list/cubit/action_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:OxyGuard/models/models.dart' as models;

class ActionListBody extends StatefulWidget {
  const ActionListBody({super.key, required this.state});

  final ActionListLoadedState state;

  @override
  State<ActionListBody> createState() => _ActionListBodyState();
}

class _ActionListBodyState extends State<ActionListBody> {
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
          child: widget.state.offlineMode
              ? _buildOfflineList()
              : Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: widget.state.actions.map((models.Action action) {
                        return Card(
                            color: Colors.white,
                            elevation: 5,
                            child: GestureDetector(
                              child: FutureBuilder(
                                future: placemarkFromCoordinates(
                                    action.actionLocation!.latitude, action.actionLocation!.longitude),
                                builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done) {
                                    if (snap.hasData) {
                                      final address = "${snap.data!.first.street}";
                                      final city = "${snap.data!.first.locality}";
                                      return ListTile(
                                        title: Text(
                                          city,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                        ),
                                        subtitle: Text(
                                          address,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      );
                                    } else if (snap.hasError) {
                                      return const ListTile(
                                        title: Text("Brak pasującego adresu/nazwy akcji"),
                                      );
                                    }
                                  }
                                  return const ListTile(
                                    title: Text("Ładowanie..."),
                                  );
                                },
                              ),
                              onTap: () {
                                //TODO: route to action page with the chosen id
                              },
                            ));
                      }).toList(),
                    )),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOfflineList() {
    return const Placeholder();
    //TODO: Offline actions
    /*
    return Column(
      children: [
        Expanded(
            child: FutureBuilder(
                future: dbService.readActionFromFile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      Card localRejoin = Card(
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            dbService.currentAction = snapshot.data!;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ActionBody()));
                          },
                          title: const Text(
                            "Akcja offline",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "Brak akcji stworzonych w trybie offline, stwórz nową akcję lub połącz się z internetem i zaloguj aby wyszukać trwające",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ],
    );
    */
  }
}
