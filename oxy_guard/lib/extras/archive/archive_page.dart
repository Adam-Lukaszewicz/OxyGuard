import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oxy_guard/action/tabs/finished/finished_squad.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:oxy_guard/models/ended_model.dart';
import 'package:watch_it/watch_it.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var addressTextStyle = TextStyle(fontSize: screenWidth * 0.04);
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
              child: StreamBuilder(
                  stream: GetIt.I.get<DatabaseService>().getArchive(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var entryList = snapshot.data!.docs;
                    entryList.sort(
                      (a, b) {
                        if (a.data() is EndedModel && b.data() is EndedModel) {
                          EndedModel aModel = a.data() as EndedModel;
                          EndedModel bModel = b.data() as EndedModel;
                          return bModel.endTime.compareTo(aModel.endTime);
                        } else {
                          return 0;
                        }
                      },
                    );
                    return ListView(
                      children: entryList.map((entry) {
                        if (entry.data() is EndedModel) {
                          EndedModel model = entry.data() as EndedModel;
                          return FutureBuilder(
                              future: placemarkFromCoordinates(
                                  model.actionLocation.latitude,
                                  model.actionLocation.longitude),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  if (snap.hasData) {
                                    final address =
                                        "${snap.data!.first.street}, ${snap.data!.first.locality}";
                                    return Card(
                                      child: InkWell(
                                        onTap: () {
                                          detailsDialog(context, model);
                                        },
                                        child: ListTile(
                                          title: Text(
                                            address,
                                            style: addressTextStyle,
                                          ),
                                          trailing: Text(
                                            "${model.endTime.day}.${model.endTime.month}.${model.endTime.year}",
                                            style: dateTextStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snap.hasError) {
                                    return Card(
                                      child: InkWell(
                                        child: ListTile(
                                          leading: const Text(
                                              "Brak pasującego adresu"),
                                          trailing: Text(
                                              "${model.endTime.day}.${model.endTime.month}.${model.endTime.year}"),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return const Card(
                                  child: ListTile(
                                    title: CircularProgressIndicator(),
                                  ),
                                );
                              });
                        } else {
                          return const Card(
                            child: ListTile(
                              title: Text("Błąd pobierania wpisu archiwum"),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> detailsDialog(BuildContext context, EndedModel entry) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var labelTextStyle =
        TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500);
    var detailsTextStyle =
        TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w300);
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
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      height: screenHeight * 0.60,
                      child: ListView.builder(
                          itemCount: entry.squads.length,
                          itemBuilder: (context, int index) {
                            String squadIndex =
                                entry.squads.entries.toList()[index].key;
                            List<FinishedSquad> finishedSquads =
                                entry.squads.entries.toList()[index].value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Odcinek $squadIndex", style: labelTextStyle,),
                                for (var finishedSquad in finishedSquads)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("Rota: ${finishedSquad.name}", style: detailsTextStyle,),
                                    Text("Strażacy:", style: labelTextStyle,),
                                    for(var worker in finishedSquad.workers)
                                      if(worker != null) Text("${worker.name} ${worker.surname}", style: detailsTextStyle,),
                                    Text("Przeciętne zużycie: ${finishedSquad.averageUse.ceil().toString()} bar/min", style: detailsTextStyle,),
                                    SizedBox(height: screenHeight * 0.01,),
                                SizedBox(height: screenHeight * 0.015,),
                                  ],)
                              ],
                            );
                          }),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size(
                                MediaQuery.of(context).size.width * 0.5,
                                MediaQuery.of(context).size.height * 0.07)),
                            elevation: const WidgetStatePropertyAll(5),
                            shape: const WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColorDark),
                            textStyle: WidgetStatePropertyAll(TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Wróć"))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
