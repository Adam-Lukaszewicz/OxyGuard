import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/manage_page.dart';
import 'package:oxy_guard/main.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:provider/provider.dart';

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
                  stream: NavigationService.databaseSevice.getActions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
              
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePage(chosenAction: action.data(),)));
                            },));
                          }
                        }
                        return Card(child: ListTile(title: Text("Loading..."),));
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
