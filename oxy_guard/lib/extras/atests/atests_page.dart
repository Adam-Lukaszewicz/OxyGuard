import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/models/extinguisher_model.dart';
import 'package:oxy_guard/services/global_service.dart';

class AtestsPage extends StatelessWidget {
  const AtestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var serialTextStyle = TextStyle(fontSize: screenWidth * 0.06);
    var dateTextStyle = TextStyle(fontSize: screenWidth * 0.05);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Atesty gaśnic"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? serial = await textInputDialog(
              context,
              "Wprowadź numer seryjny",
              "Numer seryjny gaśnicy",
              "Numer seryjny nie może być pusty");
          DateTime? expirationDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 730)),
              lastDate: DateTime.now().add(const Duration(days: 730)));
          if (serial != null && expirationDate != null) {
            ExtinguisherModel newExtinguisher = ExtinguisherModel(
                serial: serial, expirationDate: expirationDate);
            GlobalService.databaseSevice.addAtest(newExtinguisher);
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColorDark,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.9,
            child: StreamBuilder(
                stream: GlobalService.databaseSevice.getAtests(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    );
                  }
                  var extinguisherList = snapshot.data!.docs;
                  extinguisherList.sort(
                    (a, b) {
                      if (a.data() is ExtinguisherModel &&
                          b.data() is ExtinguisherModel) {
                        ExtinguisherModel aModel =
                            a.data() as ExtinguisherModel;
                        ExtinguisherModel bModel =
                            b.data() as ExtinguisherModel;
                        return bModel.expirationDate
                            .compareTo(aModel.expirationDate);
                      } else {
                        return 0;
                      }
                    },
                  );
                  return ListView(
                    children: extinguisherList.map((extinguisher) {
                      if (extinguisher.data() is ExtinguisherModel) {
                        ExtinguisherModel model =
                            extinguisher.data() as ExtinguisherModel;
                        return Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: InkWell(
                              onTap: () async {
                                  DateTime? newExpirationDate =
                                      await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 730)),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 730)));
                                  if (newExpirationDate != null) {
                                    model.updateDate(newExpirationDate);
                                  }
                                },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: screenWidth * 0.02,),
                                  Text(
                                      model.serial,
                                      style: serialTextStyle,
                                    ),
                                  SizedBox(width: screenWidth * 0.05,),
                                  Text(
                                      "${model.expirationDate.day}.${model.expirationDate.month}.${model.expirationDate.year}",
                                      style: dateTextStyle,
                                    ),
                                  ElevatedButton(
                                      onPressed: () {
                                        model.remove();
                                      },
                                      style: const ButtonStyle(
                                        shape: WidgetStatePropertyAll(CircleBorder()),
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.red),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              "Błąd pobierania danych gaśnicy",
                              style: serialTextStyle,
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
