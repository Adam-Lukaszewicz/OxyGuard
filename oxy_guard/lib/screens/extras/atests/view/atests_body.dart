import 'package:OxyGuard/context_windows.dart';
import 'package:OxyGuard/screens/extras/atests/cubit/atests_cubit.dart';
import 'package:OxyGuard/screens/extras/atests/cubit/atests_state.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtestsBody extends StatelessWidget {
  const AtestsBody({super.key, required this.state});

  final AtestsLoadedState state;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var serialTextStyle = TextStyle(fontSize: screenWidth * 0.06);
    var dateTextStyle = TextStyle(fontSize: screenWidth * 0.05);
    final AtestsCubit cubit = context.read<AtestsCubit>();
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
              context, "Wprowadź numer seryjny", "Numer seryjny gaśnicy", "Numer seryjny nie może być pusty");
          DateTime? expirationDate;
          if (context.mounted) {
            expirationDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 730)),
                lastDate: DateTime.now().add(const Duration(days: 730)));
          }

          if (serial != null && expirationDate != null) {
            cubit.createAtest(serial, expirationDate);
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
            child: ListView(
              children: state.atestsList.map((Extinguisher extinguisher) {
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: InkWell(
                      onTap: () async {
                        DateTime? newExpirationDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(const Duration(days: 730)),
                            lastDate: DateTime.now().add(const Duration(days: 730)));
                        if (newExpirationDate != null) {
                          cubit.updateAtestDate(extinguisher, newExpirationDate);
                        }
                      },
                      child: Stack(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            Text(
                              extinguisher.serialNumber,
                              style: serialTextStyle,
                            ),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            Text(
                              "${extinguisher.expirationDate.day}.${extinguisher.expirationDate.month}.${extinguisher.expirationDate.year}",
                              style: dateTextStyle,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                cubit.deleteAtest(extinguisher);
                              },
                              style: const ButtonStyle(
                                shape: WidgetStatePropertyAll(CircleBorder()),
                                backgroundColor: WidgetStatePropertyAll(Colors.red),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (extinguisher.expirationDate.difference(DateTime.now()).inDays < 7)
                          const Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ))
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
