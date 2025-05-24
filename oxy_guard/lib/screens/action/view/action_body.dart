import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:OxyGuard/screens/action/cubit/action_cubit.dart';
import 'package:OxyGuard/screens/action/cubit/action_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

class ActionBody extends StatefulWidget {
  const ActionBody({super.key, required this.state});

  final ActionLoadedState state;

  @override
  State<ActionBody> createState() => _ActionBodyState();
}

class _ActionBodyState extends State<ActionBody> {
  @override
  void initState() {
    super.initState();
    //TODO: reimplement quickstart
    if (widget.state.squads.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //TODO: create a new squad and route to its page immediately
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActionCubit cubit = context.read<ActionCubit>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                          vertical: constraints.maxHeight * 0.02, horizontal: constraints.maxWidth * 0.05),
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
                            future: placemarkFromCoordinates(widget.state.action.actionLocation!.latitude,
                                widget.state.action.actionLocation!.longitude),
                            builder: (context, snap) {
                              if (snap.connectionState == ConnectionState.done) {
                                if (snap.hasData) {
                                  final address = "${snap.data!.first.street}";
                                  final city = "${snap.data!.first.locality}";
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
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
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListView.builder(
                      itemCount: widget.state.squads.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              //TODO: route to SquadPage with a preexisting squad
                            },
                            child: ListTile(
                              //TODO: Squad naming
                              title: Text(widget.state.squads[index].id!),
                            ));
                      }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                    onPressed: () {
                      //TODO: route to SquadPage without a preexisting squad
                    },
                    child: Text(
                      "Stwórz odcinek",
                      style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 24),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                    onPressed: () {
                      cubit.endAction(widget.state.action);
                      router.pushAndRemove(RoutesNames.home);
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
}
