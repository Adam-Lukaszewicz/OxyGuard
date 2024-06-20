import 'package:flutter/material.dart';



Future<int?> checkListDialog(BuildContext context, FixedExtentScrollController checkController, double oxygenValue, title_text) => showDialog<int>(
      context: context,
      builder: (context) => Dialog(
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
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
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
                            childCount: (oxygenValue.toInt() - 60) ~/ 10,
                            builder: (context, index) =>
                                Text("${oxygenValue.toInt() - 10 * index}",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                          )),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(oxygenValue.toInt() -
                                  10 * checkController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

Future<int?> timeDialog(BuildContext context, FixedExtentScrollController seconds, FixedExtentScrollController minuts, title_text) => showDialog<int>(
      context: context,
      builder: (context) => Dialog(
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
                          children: [
                            Text(
                              title_text,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "(min)",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ListWheelScrollView.useDelegate(
                                controller: minuts,
                                itemExtent: 50,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 16,
                                  builder: (context, index) => Text("$index",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                          Container(
                            width: 10,
                            padding: const EdgeInsets.only(bottom: 18),
                            child: const Text(":",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
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
                                  builder: (context, index) => Text(
                                      "${index * 15}",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  15 * seconds.selectedItem +
                                      60 * minuts.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  

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