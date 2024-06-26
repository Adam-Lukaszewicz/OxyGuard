import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

class ShiftSquadChoicePage extends StatefulWidget {
  const ShiftSquadChoicePage({super.key});

  @override
  State<ShiftSquadChoicePage> createState() => _ShiftSquadChoicePageState();
}

class _ShiftSquadChoicePageState extends State<ShiftSquadChoicePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  void _addToList() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      if(validCharacters.hasMatch(firstName) && validCharacters.hasMatch(lastName)){
      setState(() {
        GlobalService.currentPersonnel.addWorker(Worker(name: firstName, surname: lastName));
      });
      _firstNameController.clear();
      _lastNameController.clear();
      }
      else{
        warningDialog(context, "Tekst nie może zawierać znaków specjalnych (np. %, #, spacja itp.)");
      }
    } else {
      warningDialog(context, "Wprowadź imię oraz nazwisko");
    }
  }

  void _sortWorkers() {
    GlobalService.currentPersonnel.team.sort((a, b) {
      int firstNameComparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (firstNameComparison != 0) {
        return firstNameComparison;
      } else {
        return a.surname.toLowerCase().compareTo(b.surname.toLowerCase());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sortWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Container(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'media_files/logo.png',
                        fit: BoxFit.scaleDown,
                        width: 250,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 10,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dodaj pracownika:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
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
                          onPressed: _addToList,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kadra pracownicza:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: GlobalService.currentPersonnel.team
                          .map((worker) => ListTile(
                              title: Text('${worker.name} ${worker.surname}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    GlobalService.currentPersonnel.subWorker(worker);
                                  });
                                },
                              ),
                            ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
