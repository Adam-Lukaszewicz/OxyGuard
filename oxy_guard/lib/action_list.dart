import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/models/action_model.dart';

import 'global_service.dart';

class ActionList extends StatefulWidget {
  const ActionList({super.key});

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  
  Future<List<Placemark>> getAddress(double latitude, double longitude){return placemarkFromCoordinates(latitude, longitude);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: GlobalService.databaseSevice.getActions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
              
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    // return ListView(
                    //   children: snapshot.data!.docs.map((action){
                    //     Position actionLocation = Position.fromMap(jsonDecode(action["Location"]!));
                    //     Future<List<Placemark>> address = placemarkFromCoordinates(actionLocation.latitude, actionLocation.longitude);
                    //     address.then((address){
                    //       return ListTile(title: Text(address.first.country.toString()),);
                    //     });
                    //     return ListTile(title: Text("b"),);
                    //     }).toList()
                    // );
                    return ListView(
                      children: snapshot.data!.docs.map((action){
                        Position actionLocation = Position.fromMap(jsonDecode(action["Location"]!));
                      return FutureBuilder(future: getAddress(actionLocation.latitude, actionLocation.longitude), builder: (context, snap){
                        if(snap.connectionState == ConnectionState.done){
                          if(snap.hasData){
                            final address = snap.data!.first.country.toString();
                            return Card(child: InkWell(child: ListTile(title: Text(address),), onTap: () {
                              //create
                              //action.
                              GlobalService.databaseSevice.joinAction(action.id);
                              GlobalService.currentAction = action.data() as ActionModel;
                              GlobalService.currentAction.listenToChanges();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SquadChoice()));
                            },));
                          }
                        }
                        return const Card(child: ListTile(title: Text("Loading..."),));
                      });}).toList(),
                    );
                  }),
            ),
            const Text("TODO"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Wróć")),
          ],
        ),
      ),
    );
  }
}
