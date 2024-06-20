import 'package:flutter/material.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

class PersonnelPage extends StatefulWidget{
  PersonnelPage({super.key});

  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("OxyGuard")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  (String, String)? newWorkerData = await createWorker();
                  if(newWorkerData != null){
                    GlobalService.currentPersonnel.addWorker(Worker(name: newWorkerData.$1, surname: newWorkerData.$2));
                  }
                },
                child: const Center(child: Text("Dodaj członka załogi"))),
            ElevatedButton(
                onPressed: () {
                },
                child: const Center(child: Text("Stwórz nową zmianę"))),
          ],
        ),
      ),
    );
  }

  Future<(String, String)?> createWorker() => showDialog<(String, String)>(
      context: context,
      builder: (context) => Dialog(
            child:Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Wprowadź imię',
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Wprowadź nazwisko',
              ),),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop((nameController.text, surnameController.text));
                      },
                      style: ButtonStyle(
                        maximumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width * 0.37,
                            double.infinity)),
                      ),
                      child: const Center(
                          child: Text(
                        "Dodaj",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                ],
              ),
            ],
          ),
        ),
          ));
}