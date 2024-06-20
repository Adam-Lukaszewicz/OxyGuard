import 'package:flutter/material.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/home_page.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:provider/provider.dart';

class FinishedPage extends StatelessWidget {
  FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Center(child: Text("Zakończ akcję")),
        onPressed: () {
          GlobalService.databaseSevice.endAction(GlobalService.currentAction);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: ListView(
          children: Provider.of<SquadModel>(context, listen: false)
              .finishedSquads
              .values
              .toList()
              .map((fin) => Card(
                    child: ListTile(
                      leading: Text(fin.name),
                      title: Text(fin.averageUse.toString()),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
