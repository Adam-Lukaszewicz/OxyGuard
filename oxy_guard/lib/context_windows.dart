import 'package:flutter/material.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/personnel/worker.dart';



Future<int?> checkListDialog(BuildContext context, int oxygenMaximum, int oxygenMinimum, String title_text) => showDialog<int>(
  context: context,
  builder: (context) {
    FixedExtentScrollController checkController = FixedExtentScrollController();

    return Dialog(
      child: SizedBox(
        height: 500,
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title_text,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: ListWheelScrollView.useDelegate(
                  controller: checkController,
                  itemExtent: 50,
                  perspective: 0.005,
                  overAndUnderCenterOpacity: 0.6,
                  squeeze: 1,
                  magnification: 1.1,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: (oxygenMaximum - oxygenMinimum + 10) ~/ 10,
                    builder: (context, index) => Center(
                      child: Text(
                        "${oxygenMaximum - 10 * index}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    print(oxygenMaximum - 10 * checkController.selectedItem);
                    Navigator.of(context).pop(oxygenMaximum - 10 * checkController.selectedItem);
                  },
                  child: const Text("Wprowadź"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);


Future<int?> timeDialog(BuildContext context, String titleText) {
  FixedExtentScrollController seconds = FixedExtentScrollController();
  FixedExtentScrollController minutes = FixedExtentScrollController();

  return showDialog<int>(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          height: 500,
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5), // Adjust spacing as needed
                      Text(
                        "(min)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ListWheelScrollView.useDelegate(
                          controller: minutes,
                          itemExtent: 50,
                          perspective: 0.005,
                          overAndUnderCenterOpacity: 0.6,
                          squeeze: 1,
                          magnification: 1.1,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 16,
                            builder: (context, index) => Center(
                              child: Text(
                                "$index",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                        padding: const EdgeInsets.only(bottom: 18),
                        child: const Text(
                          ":",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ListWheelScrollView.useDelegate(
                          controller: seconds,
                          itemExtent: 50,
                          perspective: 0.005,
                          overAndUnderCenterOpacity: 0.6,
                          squeeze: 1,
                          magnification: 1.1,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 4,
                            builder: (context, index) => Center(
                              child: Text(
                                "${index * 15}",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        15 * seconds.selectedItem + 60 * minutes.selectedItem,
                      );
                    },
                    child: const Text("Wprowadź"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  

  Future<void> warningDialog(BuildContext context, warningText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OSTRZEŻENIE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                child: Text(
                  warningText,
                  style: TextStyle(fontSize: 17), // Zmieniony rozmiar czcionki treści
                ),
              ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    Future<void> succesDialog(BuildContext context, warningText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SUKCES'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                child: Text(
                  warningText,
                  style: TextStyle(fontSize: 17), // Zmieniony rozmiar czcionki treści
                ),
              ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

Future<String?> selectFromList(BuildContext context, List<String> items) async {
final TextEditingController _locationController = TextEditingController();
  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Wybierz pole'),
        content: Container(
          constraints: BoxConstraints(maxHeight: 300.0),
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Wprowadź'),
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: (){
                        if (_locationController.text.trim().isNotEmpty ) {
                          Navigator.of(context).pop(_locationController.text.trim());
                        } else {
                          warningDialog(context, "Wprowadź dane");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      String selectedItem = items[index];
                      Navigator.of(context).pop(selectedItem);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Anuluj'),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
        ],
      );
    },
  );
}

Future<Worker?> selectWorkerFromList(BuildContext context) async {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  return showDialog<Worker?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Wybierz pole'),
        content: Container(
          constraints: BoxConstraints(maxHeight: 300.0),
          width: double.maxFinite,
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
                      onPressed: (){
                        if (_firstNameController.text.trim().isNotEmpty && _lastNameController.text.trim().isNotEmpty) {
                          Navigator.of(context).pop(Worker(name: _firstNameController.text.trim(), surname: _lastNameController.text.trim()));
                        } else {
                          warningDialog(context, "Wprowadź imię oraz nazwisko");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: GlobalService.currentPersonnel.team
                      .map((worker) => ListTile(
                            title: Text('${worker.name} ${worker.surname}'),
                            onTap: () {
                              Navigator.of(context).pop(worker);
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Anuluj'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

