import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/personnel/personnel_model.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

class ShiftSquadChoicePage extends StatefulWidget {
  const ShiftSquadChoicePage({super.key});

  @override
  State<ShiftSquadChoicePage> createState() => _ShiftSquadChoicePageState();
}

class _ShiftSquadChoicePageState extends State<ShiftSquadChoicePage> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _addToList() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      setState(() {
        GlobalService.currentPersonnel.addWorker(Worker(name: firstName, surname: lastName));
      });
      _firstNameController.clear();
      _lastNameController.clear();
    }
    else{
      warningDialog(context, "Wprowadź imię oraz nazwisko");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.18,
        title: Image.asset(
          'media_files/logo.png',
          fit: BoxFit.scaleDown,
          width: 250,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'Imię'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Nazwisko'),
                  ),
                ),
                Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _addToList();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
                child: Icon(Icons.add),
                      
                ),
              )
              ],
            ),
            SizedBox(height: 20),
           Expanded(
              child: ListView(
                children: GlobalService.currentPersonnel.team
                    .map((worker) => ListTile(
                          title: Text('${worker.name} ${worker.surname}'),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
