import 'package:flutter/material.dart';
import 'package:oxy_guard/extras/account/account_page.dart';
import 'package:oxy_guard/extras/archive/archive_page.dart';
import 'package:oxy_guard/extras/personnel/shift_squad_choice.dart';
import 'package:oxy_guard/settings/settings_page.dart';

class ExtrasPage extends StatelessWidget {
  const ExtrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleCategoryTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05);
    var subtitleCategoryTextStyle = TextStyle(fontSize: screenWidth * 0.04);
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ArchivePage()),
                      );
                    },
                    child: ListTile(
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
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      //TODO: Inżynierka - atesty
                    },
                    child: ListTile(
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
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage()));
                    },
                    child: ListTile(
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
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ShiftSquadChoicePage()));
                    },
                    child: ListTile(
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
