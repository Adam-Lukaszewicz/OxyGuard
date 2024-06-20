import 'package:flutter/material.dart';
import 'package:oxy_guard/action/manage_page.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/squad_model.dart';

class SquadChoice extends StatefulWidget {
  const SquadChoice({super.key});

  @override
  State<SquadChoice> createState() => _SquadChoiceState();
}

class _SquadChoiceState extends State<SquadChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("OxyGuard")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  String? chosenSquadIndex = await chooseExistingSquadDialog();
                  if (chosenSquadIndex != null) {
                    SquadModel rebuild = SquadModel();
                    rebuild.copyFrom(GlobalService.currentAction.squads[chosenSquadIndex]!);
                    GlobalService.currentAction.squads[chosenSquadIndex] = rebuild;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManagePage(
                                chosenAction: rebuild,
                              )),
                    );
                  }
                },
                child: const Center(child: Text("Wybierz odcinek"))),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagePage()),
                  );
                },
                child: const Center(child: Text("Stwórz odcinek"))),
          ],
        ),
      ),
    );
  }

  Future<String?> chooseExistingSquadDialog() => showDialog<String>(
      context: context,
      builder: (context) => Dialog(
            child: ListView(
              children: GlobalService.currentAction.squads.entries
                  .toList()
                  .map((squad) {
                return Card(
                    child: InkWell(
                  child: ListTile(
                    title: Text(squad.key),
                  ),
                  onTap: () {
                    //create
                    //action.
                    Navigator.of(context).pop(squad.key);
                  },
                ));
              }).toList(),
            ),
          ));
}
