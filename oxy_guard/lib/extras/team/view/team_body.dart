import 'package:OxyGuard/context_windows.dart';
import 'package:OxyGuard/extras/team/cubit/team_cubit.dart';
import 'package:OxyGuard/extras/team/cubit/team_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamBody extends StatefulWidget {
  const TeamBody({super.key, required this.state});

  final TeamLoadedState state;

  @override
  State<TeamBody> createState() => _TeamBodyState();
}

class _TeamBodyState extends State<TeamBody> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  void _addToList() {
    final TeamCubit cubit = context.read<TeamCubit>();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      if (validCharacters.hasMatch(firstName) && validCharacters.hasMatch(lastName)) {
        setState(() {
          cubit.addWorker(widget.state.personnel, firstName, lastName);
        });
        _firstNameController.clear();
        _lastNameController.clear();
      } else {
        warningDialog(context, "Tekst nie może zawierać znaków specjalnych (np. %, #, spacja itp.)");
      }
    } else {
      warningDialog(context, "Wprowadź imię oraz nazwisko");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var guidesTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05);
    final TeamCubit cubit = context.read<TeamCubit>();
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
                color: Colors.white,
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
                  Text('Dodaj pracownika:', style: guidesTextStyle),
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
                  Text('Kadra pracownicza:', style: guidesTextStyle),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: widget.state.workers
                          .map((worker) => ListTile(
                                title: Text('${worker.name} ${worker.surname}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      cubit.deleteWorker(widget.state.personnel, worker);
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
