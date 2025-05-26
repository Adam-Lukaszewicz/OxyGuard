import 'package:OxyGuard/models/models.dart';
import 'package:flutter/material.dart';

class FinishedBody extends StatelessWidget {
  const FinishedBody({super.key, required this.finishedTeams});

  final List<FinishedTeam> finishedTeams;

  @override
  Widget build(BuildContext context) {
    if (finishedTeams.isEmpty) {
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
    return Scaffold(
      backgroundColor: const Color(0xfffcfcfc),
      floatingActionButton: FloatingActionButton.extended(
        label: const Center(child: Text("Zakończ akcję")),
        onPressed: () {
          //TODO: End this squads work, route to action page
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
              children: finishedTeams
                  .map((fin) => Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text(
                            fin.name,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),
                          ),
                          title: Text(fin.averageConsumption.toString()),
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
