import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/extras/archive/archive_page.dart';
import 'package:oxy_guard/extras/personnel/shift_squad_choice.dart';
import 'package:oxy_guard/extras/settings/settings_page.dart';
import 'package:oxy_guard/login/login_page.dart';
import 'package:oxy_guard/services/global_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
        title: const Text("Konto"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.03),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.9,
            child: ListView(
              children: [
                Card(
                  color: Colors.red,
                  elevation: 5,
                  child: InkWell(
                    onTap: () async {
                      GlobalService.currentPersonnel.finishListening();
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        color: Colors.white,
                        Icons.logout,
                        size: screenWidth * 0.08,
                      ),
                      title: Text(
                        "Wyloguj się",
                        style: titleCategoryTextStyle.copyWith(
                            color: Colors.white),
                      ),
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
