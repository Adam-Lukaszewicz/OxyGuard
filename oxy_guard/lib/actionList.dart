import 'package:flutter/material.dart';

class ActionList extends StatelessWidget{
  const ActionList({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("TODO"),
            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text("Wróć")),
          ],
        ),
      ),
    );
  }
}