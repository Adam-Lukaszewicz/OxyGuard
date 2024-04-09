import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late FixedExtentScrollController pressureController;
  late FixedExtentScrollController secondsController;
  late FixedExtentScrollController minuteController;
  var genericButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.grey),
      foregroundColor: MaterialStatePropertyAll(Colors.black),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      )));

  @override
  void initState() {
    pressureController = FixedExtentScrollController();
    secondsController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    pressureController.dispose();
    secondsController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.05,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Konfiguracja startowa"),
          centerTitle: true,
        ),
        body: SizedBox(
          height: screenHeight * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Wybór kadry"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var exitTime = await timeDialog();
                },
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Okres pomiarów"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var lowPressure = await pressureDialog();
                },
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Ciśnienie graniczne"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var highPressure = await pressureDialog();
                },
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Ciśnienie początkowe"),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Zatwierdź"),
                ),
              ),
            ],
          ),
        ));
  }

  Future<int?> pressureDialog() => showDialog<int>(
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
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "Wprowadź nowy pomiar",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 6,
                      child: ListWheelScrollView.useDelegate(
                          controller: pressureController,
                          itemExtent: 50,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 34,
                            builder: (context, index) =>
                                Text("${330 - 10 * index}",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    )),
                          )),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(330 - 10 * pressureController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  Future<int?> timeDialog() => showDialog<int>(
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
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "Wprowadź czas wyjścia",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ListWheelScrollView.useDelegate(
                                controller: minuteController,
                                itemExtent: 50,
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
                                controller: secondsController,
                                itemExtent: 50,
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
                                  15 * secondsController.selectedItem +
                                      60 * minuteController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));
}
