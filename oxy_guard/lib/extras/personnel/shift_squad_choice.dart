import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/services/global_service.dart';
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var guidesTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.05
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Personel"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20),
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
                    style: guidesTextStyle
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'Imię'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'Nazwisko'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: _addToList,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kadra pracownicza:',
                    style: guidesTextStyle
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: GlobalService.currentPersonnel,
                      builder: (context, child) {
                        return ListView(
                        children: GlobalService.currentPersonnel.team
                            .map((worker) => ListTile(
                                title: Text('${worker.name} ${worker.surname}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      GlobalService.currentPersonnel.subWorker(worker);
                                    });
                                  },
                                ),
                              ))
                            .toList(),
                      );
                      },
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