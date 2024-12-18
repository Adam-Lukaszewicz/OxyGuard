import 'package:flutter/material.dart';
import 'package:oxy_guard/extras/account/account_page.dart';
import 'package:oxy_guard/extras/archive/archive_page.dart';
import 'package:oxy_guard/extras/atests/atests_page.dart';
import 'package:oxy_guard/extras/personnel/shift_squad_choice.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:oxy_guard/services/internet_serivce.dart';
import 'package:watch_it/watch_it.dart';

class ExtrasPage extends WatchingStatefulWidget {
  const ExtrasPage({super.key});

  @override
  State<ExtrasPage> createState() => _ExtrasPageState();
}

class _ExtrasPageState extends State<ExtrasPage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleCategoryTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05);
    var subtitleCategoryTextStyle = TextStyle(fontSize: screenWidth * 0.04);
    var internetService = GetIt.I.get<InternetService>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Colors.white,
        title: const Text("Opcje dodatkowe"),
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
                  child: ListTile(
                    enabled: !internetService.offlineMode,
                    onTap: internetService.offlineMode
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ArchivePage()),
                            );
                          },
                    leading: Icon(
                      Icons.archive,
                      size: screenWidth * 0.08,
                    ),
                    title: Text(
                      "Archiwum",
                      style: titleCategoryTextStyle,
                    ),
                    subtitle: Text(
                      "Przejrzyj zapisy archiwalne akcji",
                      style: subtitleCategoryTextStyle,
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Stack(children: [
                    ListTile(
                      enabled: !internetService.offlineMode,
                      onTap: internetService.offlineMode
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AtestsPage()),
                              ).then((onValue) {
                                setState(() {});
                              });
                            },
                      leading: Icon(
                        Icons.fire_extinguisher,
                        size: screenWidth * 0.08,
                      ),
                      title: Text(
                        "Atesty",
                        style: titleCategoryTextStyle,
                      ),
                      subtitle: Text(
                        "Kontroluj ważności gaśnic",
                        style: subtitleCategoryTextStyle,
                      ),
                    ),
                    if (watchPropertyValue(
                        (DatabaseService db) => db.closeToExpiring))
                      const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          )),
                  ]),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountPage()));
                    },
                    leading: Icon(
                      Icons.fire_extinguisher,
                      size: screenWidth * 0.08,
                    ),
                    title: Text(
                      "Konto",
                      style: titleCategoryTextStyle,
                    ),
                    subtitle: Text(
                      "Zmień konto lub modyfikuj aktualne",
                      style: subtitleCategoryTextStyle,
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    enabled: !internetService.offlineMode,
                    onTap: internetService.offlineMode
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShiftSquadChoicePage()));
                          },
                    leading: Icon(
                      Icons.person,
                      size: screenWidth * 0.08,
                    ),
                    title: Text(
                      "Personel",
                      style: titleCategoryTextStyle,
                    ),
                    subtitle: Text(
                      "Modyfikuj dostępną załogę",
                      style: subtitleCategoryTextStyle,
                    ),
                  ),
                ),
                //Kolejne funkcje aplikacji tutaj
              ],
            ),
          ),
        ),
      ),
    );
  }
}
