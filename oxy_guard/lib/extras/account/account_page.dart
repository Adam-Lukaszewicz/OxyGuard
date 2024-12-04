import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/login/login_page.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:oxy_guard/services/internet_serivce.dart';
import 'package:watch_it/watch_it.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleCategoryTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05);
    //var subtitleCategoryTextStyle = TextStyle(fontSize: screenWidth * 0.04);
    var internetService = GetIt.I.get<InternetService>();
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
                internetService.offlineMode
                    ? Card(
                        color: Theme.of(context).primaryColorDark,
                        elevation: 5,
                        child: InkWell(
                          onTap: () async {
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
                              Icons.login,
                              size: screenWidth * 0.08,
                            ),
                            title: Text(
                              "Zaloguj się",
                              style: titleCategoryTextStyle.copyWith(
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.red,
                        elevation: 5,
                        child: InkWell(
                          onTap: () async {
                            GetIt.I
                                .get<DatabaseService>()
                                .currentPersonnel
                                .finishListening();
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false
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
