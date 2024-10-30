import 'package:flutter/material.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/models/personnel/worker.dart';



Future<int?> checkListDialog(BuildContext context, int oxygenMaximum, int oxygenMinimum, String tileText, {String? unitText}) => showDialog<int>(
  context: context,
  builder: (context) {
    FixedExtentScrollController checkController = FixedExtentScrollController();
    return Dialog(
      backgroundColor: const Color(0xfffcfcfc),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      tileText,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(unitText != null)Text(
                      "($unitText)",
                      style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: ListWheelScrollView.useDelegate(
                  controller: checkController,
                  itemExtent: MediaQuery.of(context).size.width * 0.14,
                  perspective: 0.005,
                  overAndUnderCenterOpacity: 0.6,
                  squeeze: 1,
                  magnification: 1.1,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: (oxygenMaximum - oxygenMinimum + 10) ~/ 10,
                    builder: (context, index) => Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01, horizontal: MediaQuery.of(context).size.width * .04),
                        child: Text(
                          "${oxygenMaximum - 10 * index}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.07)),
                                        elevation: const WidgetStatePropertyAll(5),
                                        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(Colors.white),
                                        foregroundColor: WidgetStatePropertyAll(
                                            Theme.of(context).primaryColorDark),
                                        textStyle: WidgetStatePropertyAll(TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(context).size.width * 0.05,
                                        ))),
                      onPressed: () {
                        Navigator.of(context).pop(oxygenMaximum - 10 * checkController.selectedItem);
                      },
                      child: const Text("Wprowadź"),
                    ),
                  ],
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
  FixedExtentScrollController secondsController = FixedExtentScrollController();
  FixedExtentScrollController minuteController = FixedExtentScrollController();

  return showDialog<int>(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: const Color(0xfffcfcfc),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              titleText,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "(min:sek)",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ListWheelScrollView.useDelegate(
                                controller: minuteController,
                                itemExtent:
                                    MediaQuery.of(context).size.width * 0.14,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 16,
                                  builder: (context, index) => Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                      child: Text("$index",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                            child: Text(":",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ListWheelScrollView.useDelegate(
                                controller: secondsController,
                                itemExtent:
                                    MediaQuery.of(context).size.width * 0.14,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 4,
                                  builder: (context, index) => Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                      child: Text("${index * 15}",
                                          //To powoduje, że Card zawierający 0 sekund jest mniejszy niż 15/30/45. Brzydkie, ale nie widzę szybkiej poprawki na to.
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(
                                        MediaQuery.of(context).size.width * 0.5,
                                        MediaQuery.of(context).size.height *
                                            0.07)),
                                    elevation: const WidgetStatePropertyAll(5),
                                    shape: const WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).primaryColorDark),
                                    textStyle: WidgetStatePropertyAll(TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ))),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      15 * secondsController.selectedItem +
                                          60 * minuteController.selectedItem);
                                },
                                child: const Text("Wprowadź")),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ));
}


  

  Future<bool?> warningDialog(BuildContext context, warningText) async {
    return showDialog<bool?>(
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
                  style: const TextStyle(fontSize: 17), // Zmieniony rozmiar czcionki treści
                ),
              ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
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
                  style: const TextStyle(fontSize: 17), // Zmieniony rozmiar czcionki treści
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
final TextEditingController locationController = TextEditingController();
  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xfffcfcfc),
        title: const Text('Wybierz pole'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Wprowadź', labelStyle: TextStyle(color:Theme.of(context).primaryColorDark), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark))),
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: (){
                        if (locationController.text.trim().isNotEmpty ) {
                          Navigator.of(context).pop(locationController.text.trim());
                        } else {
                          warningDialog(context, "Wprowadź dane");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        shape: const CircleBorder(),
                      ),
                      child: Icon(Icons.add, color: Theme.of(context).primaryColorDark,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  return ListTile(
                    leading: const Icon(Icons.location_pin),
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
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
              elevation: WidgetStatePropertyAll(5),
            ),
            child: const Text('Anuluj'),
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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  return showDialog<Worker?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xfffcfcfc),
        title: const Text('Wybierz pole'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColorDark,
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'Imię', labelStyle: TextStyle(color:Theme.of(context).primaryColorDark), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColorDark,
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Nazwisko', labelStyle: TextStyle(color:Theme.of(context).primaryColorDark), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark))),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: (){
                        if (firstNameController.text.trim().isNotEmpty && lastNameController.text.trim().isNotEmpty) {
                          Navigator.of(context).pop(Worker(name: firstNameController.text.trim(), surname: lastNameController.text.trim()));
                        } else {
                          warningDialog(context, "Wprowadź imię oraz nazwisko");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        shape: const CircleBorder(),
                      ),
                      child: Icon(Icons.add, color: Theme.of(context).primaryColorDark,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: GlobalService.currentPersonnel.team
                      .map((worker) => ListTile(
                            leading: const Icon(Icons.person),
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
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
              elevation: WidgetStatePropertyAll(5),
            ),
            child: const Text('Anuluj'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String?> textInputDialog(BuildContext context, String title, String label) async {
  final TextEditingController textController = TextEditingController();

  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(maxHeight: 300.0),
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: label),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              if(textController.text.isNotEmpty) Navigator.of(context).pop(textController.text.trim());
              warningDialog(context, "Akcja bez GPS musi być nazwana");
            },
          ),
        ],
      );
    },
  );
}

