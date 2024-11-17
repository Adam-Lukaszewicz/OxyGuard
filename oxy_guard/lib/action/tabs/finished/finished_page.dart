import 'package:flutter/material.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:oxy_guard/home/home_page.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:provider/provider.dart';
import 'package:watch_it/watch_it.dart';

class FinishedPage extends StatelessWidget {
  const FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
        if (Provider.of<SquadModel>(context, listen: false)
                  .finishedSquads
                  .values
                  .toList().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tutaj będą wyświetlane statystki rot które zakończyły pracę.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    var dBService = GetIt.I.get<DatabaseService>();
    return Scaffold(
      backgroundColor: const Color(0xfffcfcfc),
      floatingActionButton: FloatingActionButton.extended(
        label: const Center(child: Text("Zakończ akcję")),
        onPressed: () {
          dBService.endAction(dBService.currentAction);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: Provider.of<SquadModel>(context, listen: false)
                  .finishedSquads
                  .values
                  .toList()
                  .map((fin) => Card(
                    color: Colors.white,
                        child: ListTile(
                          leading: Text(fin.name,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.08
                          ),),
                          title: Text(fin.averageUse.toString()),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
