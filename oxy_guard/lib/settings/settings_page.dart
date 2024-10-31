import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? entryPressure;
  int? exitPressure;
  int? checkInterval;

  Future<void> _loadExtremePresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      exitPressure = (prefs.getInt('extremePressure') ?? 0);
    });
  }

  Future<void> _loadTimePeriod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkInterval = (prefs.getInt('timePeriod') ?? 0);
    });
  }

  Future<void> _loadStartingPresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      entryPressure = (prefs.getInt('startingPressure') ?? 0);
    });
  }

  Future<void> _setExtremePresssure(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      exitPressure = value;
      prefs.setInt('extremePressure', value);
    });
  }

  Future<void> _setTimePeriod(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkInterval = value;
      prefs.setInt('timePeriod', value);
    });
  }

  Future<void> _setStartingPresssure(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      entryPressure = value;
      prefs.setInt('startingPressure', value);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExtremePresssure();
    _loadStartingPresssure();
    _loadTimePeriod();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleCategoryTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.045);
    var subtitleCategoryTextStyle = TextStyle(fontSize: screenWidth * 0.035);
    var valueTextStyle = TextStyle(fontSize: screenWidth * 0.08);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
        title: const Text("Ustawienia"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.9,
            child: ListView(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () async {
                      var value = await checkListDialog(
                          context, 330, 160, "Wprowadź nowy pomiar",
                          unitText: "bar");
                      _setStartingPresssure(value ?? entryPressure ?? 300);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          size: screenWidth * 0.08,
                        ),
                        title: Text(
                          "Ciśnienie początkowe",
                          style: titleCategoryTextStyle,
                        ),
                        subtitle: Text(
                          "Zmień wartość ciśnienia początkowego",
                          style: subtitleCategoryTextStyle,
                        ),
                        trailing: entryPressure != null
                            ? Text(
                                "$entryPressure",
                                style: valueTextStyle,
                              )
                            : const CircularProgressIndicator()),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () async {
                      var value = await checkListDialog(
                          context, 150, 0, "Wprowadź nowy pomiar",
                          unitText: "bar");
                      _setExtremePresssure(value ?? exitPressure ?? 60);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.arrow_back_ios,
                          size: screenWidth * 0.08,
                        ),
                        title: Text(
                          "Ciśnienie wyjściowe",
                          style: titleCategoryTextStyle,
                        ),
                        subtitle: Text(
                          "Zmień wartość ciśnienia wyjściowego",
                          style: subtitleCategoryTextStyle,
                        ),
                        trailing: exitPressure != null
                            ? Text(
                                "$exitPressure",
                                style: valueTextStyle,
                              )
                            : const CircularProgressIndicator()),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () async {
                      var value =
                          await timeDialog(context, "Wprowadz nowy okres");
                      _setTimePeriod(value ?? checkInterval ?? 600);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.watch_later_outlined,
                          size: screenWidth * 0.08,
                        ),
                        title: Text(
                          "Okres pomiarów",
                          style: titleCategoryTextStyle,
                        ),
                        subtitle: Text(
                          "Zmień czas między przypomnieniami o pomiarach",
                          style: subtitleCategoryTextStyle,
                        ),
                        trailing: checkInterval != null
                            ? Text(
                                "${checkInterval! ~/ 60}:${checkInterval! % 60}",
                                style: valueTextStyle,
                              )
                            : const CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
