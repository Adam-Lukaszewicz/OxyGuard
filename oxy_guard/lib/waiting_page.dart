import 'package:flutter/material.dart';
import 'package:oxy_guard/managePage.dart';
import 'package:oxy_guard/setup_page.dart';
import 'package:provider/provider.dart';

class WaitingPage extends StatefulWidget{
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
    var genericButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.grey),
      foregroundColor: MaterialStatePropertyAll(Colors.black),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      )));
  @override
  Widget build(BuildContext context){
    return  Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            var newSquad = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPage()),
                );
            if(newSquad != null){
              if(newSquad.length == 3){
                Provider.of<CategoryModel>(context, listen: false).startSquadWork(newSquad[1], newSquad[2], newSquad[0]);
              }
            }
          },
          style: genericButtonStyle, 
          child: const Center(child: Text("Dodaj nową rotę"),))
      ],
    );
  }
}