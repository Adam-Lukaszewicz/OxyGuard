import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:flutter/material.dart';

class ExtrasBody extends StatefulWidget {
  const ExtrasBody({super.key});

  @override
  State<ExtrasBody> createState() => _ExtrasBodyState();
}

class _ExtrasBodyState extends State<ExtrasBody> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleCategoryTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05);
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
                  child: ListTile(
                    onTap: () {
                      router.push(RoutesNames.archive);
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
                      onTap: () {
                        router.push(RoutesNames.atests);
                        //TODO: add cubit to handle expiring atest alert
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
                  ]),
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      router.push(RoutesNames.account);
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
                    onTap: () {
                      router.push(RoutesNames.team);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
