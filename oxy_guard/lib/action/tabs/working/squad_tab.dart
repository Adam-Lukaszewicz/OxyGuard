import 'package:flutter/material.dart';
import 'package:oxy_guard/action/manage_page.dart';
import 'package:oxy_guard/main.dart';
import 'package:provider/provider.dart';

import '../../../models/action_model.dart';

class TabSquad extends StatelessWidget {
  var text = "R";
  final int index;
  TabSquad({super.key, required this.text, required this.index});
  TabSquad.fromJson(Map<String, Object?> json) : this(
    text: json["Text"]! as String,
    index: json["Index"]! as int
  );

  Map<String, Object?> toJson(){
    return{
      "Text": text,
      "Index": index
    };
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.height - MediaQuery.of(NavigationService.navigatorKey.currentContext!).viewPadding.vertical;
    return Tab(
      height: screenHeight * 0.1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          //color: Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child:
                      Consumer<ActionModel>(builder: (context, cat, child) {
                    return Text(
                        '${cat.getTimeRemaining(index) ~/ 60}:${cat.getTimeRemaining(index) % 60 < 10 ? "0${cat.getTimeRemaining(index) % 60}" : "${cat.getTimeRemaining(index) % 60}"}',
                        style: TextStyle(
                          color: HSVColor.lerp(
                                  HSVColor.fromColor(Colors.green),
                                  HSVColor.fromColor(Colors.red),
                                  1 - (cat.getOxygenRemaining(index) - 60) / 270)!
                              .toColor(),
                          fontSize: 30,
                        ));
                  }),
                ),
              ),
               Positioned(
                top: 34,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
