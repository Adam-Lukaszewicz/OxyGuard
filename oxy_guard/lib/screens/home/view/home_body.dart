import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    //TODO: Figure out offline actions and sound/vibration notifications
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                'media_files/logo_no_fire.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                        onPressed: () async {
                          //TODO: Quick start
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color(0xff1874d4)),
                        child: const Center(
                            child: Text(
                          "Szybki start",
                          style: TextStyle(
                            fontSize: 27,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                        onPressed: () {
                          router.push(RoutesNames.actionList);
                        },
                        child: const Center(
                            child: Text(
                          "Dołącz do akcji",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                        onPressed: () {
                          //TODO: Regular start
                        },
                        child: const Center(
                            child: Text(
                          "Stwórz akcję",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.325,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                              onPressed: () {
                                router.push(RoutesNames.extras);
                              },
                              child: const Center(
                                  child: Text(
                                "Dodatkowe",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ))),
                        ),
                      ]),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.325,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                            onPressed: () {
                              router.push(RoutesNames.settings);
                            },
                            child: const Center(
                                child: Text(
                              "Ustawienia",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void checkAndRequestPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }
}
