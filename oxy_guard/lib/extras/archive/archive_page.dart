import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/models/ended_model.dart';

class ArchivePage extends StatelessWidget{
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("OxyGuard")),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(child: Text("Archiwum"),),
              Expanded(
                child: StreamBuilder(stream: GlobalService.databaseSevice.getArchive(), builder: (context, snapshot){
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  var entryList = snapshot.data!.docs;
                  entryList.sort((a, b) {
                    if(a.data() is EndedModel && b.data() is EndedModel){
                      EndedModel aModel = a.data() as EndedModel;
                      EndedModel bModel = b.data() as EndedModel;
                      return bModel.endTime.compareTo(aModel.endTime);
                    }else{
                      return 0;
                    }
                  },);
                  return ListView(
                    children: entryList.map((entry){
                      if(entry.data() is EndedModel){
                        EndedModel model = entry.data() as EndedModel;
                        return FutureBuilder(future: placemarkFromCoordinates(model.actionLocation.latitude, model.actionLocation.longitude), builder: (context, snap){
                          if (snap.connectionState == ConnectionState.done) {
                            if (snap.hasData) {
                              final address = "${snap.data!.first.street}, ${snap.data!.first.locality}";
                              return Card(child: InkWell(
                                onTap: (){
                                  detailsDialog(context, model);
                                },
                                child: ListTile(
                                  leading: Text(address),
                                  trailing: Text("${model.endTime.day}.${model.endTime.month}.${model.endTime.year}"),
                                ),
                              ),
                              );
                            } else if (snap.hasError) {
                              return Card(child: InkWell(
                                child: ListTile(
                                  leading: const Text("Brak pasującego adresu"),
                                  trailing: Text("${model.endTime.day}.${model.endTime.month}.${model.endTime.year}"),
                                  ),
                              ),
                                );
                            }
                          }
                          return const Card(child: ListTile(
                          title: CircularProgressIndicator(),
                          ),
                          );
                        });
                      }else{
                        return const Card(child: ListTile(
                          title: Text("Błąd pobierania wpisu archiwum"),
                        ),
                        );
                      }
                    }).toList(),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> detailsDialog(BuildContext context, EndedModel entry) => showDialog<void>(context: context, builder: (context){
    return Dialog(
      child: SizedBox(
              height: 500,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "Szczegóły",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 6,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Przeciętne zużycie tlenu:"),
                            Text(entry.averageUse.toStringAsFixed(2)),
                          ],
                        )
                      ],)
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Wróć")))
                  ],
                ),
              ),
            ),
    );
  });
}