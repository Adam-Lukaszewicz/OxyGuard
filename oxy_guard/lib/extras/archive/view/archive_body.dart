import 'package:OxyGuard/extras/archive/cubit/archive_state.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ArchiveBody extends StatelessWidget {
  const ArchiveBody({super.key, required this.state});

  final ArchiveLoadedState state;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var dateTextStyle = TextStyle(fontSize: screenWidth * 0.05);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Archiwum"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Center(
            child: SizedBox(
              width: screenWidth * 0.9,
              child: ListView(
                children: state.archivedActions.map((ArchivedAction action) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        detailsDialog(context, action);
                      },
                      child: ListTile(
                        title: _buildCardTitle(context, action),
                        trailing: Text(
                          "${action.endTime.day}.${action.endTime.month}.${action.endTime.year}",
                          style: dateTextStyle,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTitle(BuildContext context, ArchivedAction action) {
    var screenWidth = MediaQuery.of(context).size.width;
    var addressTextStyle = TextStyle(fontSize: screenWidth * 0.04);
    if (action.actionLocation == null) {
      return Text(
        "Brak adresu akcji",
        style: addressTextStyle,
      );
    } else {
      return FutureBuilder(
          future: placemarkFromCoordinates(action.actionLocation!.latitude, action.actionLocation!.longitude),
          builder: (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(
                  'Błąd przy ustalaniu adresu',
                  style: addressTextStyle,
                );
              }
              if (snapshot.hasData) {
                final address = "${snapshot.data!.first.street}, ${snapshot.data!.first.locality}";
                return Text(
                  address,
                  style: addressTextStyle,
                );
              }
            }
            return const CircularProgressIndicator();
          });
    }
  }

  Future<void> detailsDialog(BuildContext context, ArchivedAction action) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var labelTextStyle = TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500);
    var detailsTextStyle = TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w300);
    final List<FinishedSquad> squads = state.finishedSquads[action.id]!;
    return showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: screenHeight * 0.8,
              width: screenWidth * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Szczegóły akcji",
                      style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      height: screenHeight * 0.60,
                      child: ListView.builder(
                          itemCount: squads.length,
                          itemBuilder: (context, int index) {
                            List<FinishedTeam> finishedTeams = state.finishedTeams[squads[index].id]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Odcinek ?",
                                  style: labelTextStyle,
                                ),
                                for (FinishedTeam finishedTeam in finishedTeams)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rota: ${finishedTeam.name}",
                                        style: detailsTextStyle,
                                      ),
                                      Text(
                                        "Strażacy:",
                                        style: labelTextStyle,
                                      ),
                                      for (String workerId in finishedTeam.workers)
                                        Text(
                                          "${getWorker(workerId).name} ${getWorker(workerId).surname}",
                                          style: detailsTextStyle,
                                        ),
                                      Text(
                                        "Przeciętne zużycie: ${finishedTeam.averageConsumption.ceil().toString()} bar/min",
                                        style: detailsTextStyle,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.015,
                                      ),
                                    ],
                                  )
                              ],
                            );
                          }),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          router.pop(context);
                        },
                        child: const Text("Wróć"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Worker getWorker(String id) {
    return state.workers.firstWhere((Worker worker) => worker.id == id);
  }
}
