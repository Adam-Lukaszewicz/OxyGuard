import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oxy_guard/action/manage_page.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/home/home_page.dart';
import 'package:oxy_guard/models/squad_model.dart';

class SquadChoice extends StatefulWidget {
  bool quickStart;
  SquadChoice({super.key, this.quickStart = false});

  @override
  State<SquadChoice> createState() => _SquadChoiceState();
}

class _SquadChoiceState extends State<SquadChoice> {
  @override
  void initState() {
    super.initState();
    if (widget.quickStart) {
      widget.quickStart = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManagePage(
                    chosenAction: GlobalService.currentAction.squads["0"],
                    quickStart: true,
                  )),
        );
      });
    } else if (GlobalService.currentAction.squads.entries.toList().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManagePage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Akcja")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.02,
                          horizontal: constraints.maxWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.1,
                          ),
                          const Text(
                            "Miejsce akcji:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.1,
                          ),
                          FutureBuilder(
                            future: placemarkFromCoordinates(
                                GlobalService
                                    .currentAction.actionLocation.latitude,
                                GlobalService
                                    .currentAction.actionLocation.longitude),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.done) {
                                if (snap.hasData) {
                                  final address = "${snap.data!.first.street}";
                                  final city = "${snap.data!.first.locality}";
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.05,
                                      ),
                                      Text(
                                        address,
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      )
                                    ],
                                  );
                                  //MOŻLIWY BUG: nie wiem czy ta logika pokryje brak lokalizacji w akcji (czy brak actionlocation spowoduje snap.hasError czy cos co nie jest handlowane)
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.07)),
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(width: 0.1))),
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () async {
                      String? chosenSquadIndex =
                          await chooseExistingSquadDialog();
                      if (chosenSquadIndex != null) {
                        SquadModel rebuild = SquadModel();
                        rebuild.copyFrom(GlobalService
                            .currentAction.squads[chosenSquadIndex]!);
                        GlobalService.currentAction.squads[chosenSquadIndex] =
                            rebuild;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagePage(
                                    chosenAction: rebuild,
                                  )),
                        );
                      }
                    },
                    child: Text(
                      "Wybierz odcinek",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 24),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.07)),
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(width: 0.1))),
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagePage()),
                      );
                    },
                    child: Text(
                      "Stwórz odcinek",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 24),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.07)),
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(width: 0.1))),
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: const WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      GlobalService.databaseSevice
                          .endAction(GlobalService.currentAction);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: const Text(
                      "Zakończ akcję",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> chooseExistingSquadDialog() => showDialog<String>(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: const Color(0xfffcfcfc),
            child: LayoutBuilder(builder: (context, constraints){
              return Padding(
              padding: EdgeInsets.symmetric(
                vertical: constraints.maxHeight * 0.05,
                horizontal: constraints.maxWidth * 0.1
                ),
              child: Column(
                children: [
                  const Center(child: Text(
                    "Odcinki w akcji",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    ),),
                  SizedBox(height: constraints.maxHeight * 0.05,),
                  SizedBox(
                    height: constraints.maxHeight * 0.8,
                    child: ListView(
                      children: GlobalService.currentAction.squads.entries
                          .toList()
                          .map((squad) {
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                            child: InkWell(
                          child: ListTile(
                            title: Text(squad.key),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(squad.key);
                          },
                        ));
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
            }))
          );
}
