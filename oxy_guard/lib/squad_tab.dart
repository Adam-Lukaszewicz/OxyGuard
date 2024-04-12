import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/managePage.dart';
import 'package:provider/provider.dart';

class TabSquad extends StatelessWidget {
  var text = "R";
  TabSquad({super.key, required this.text});
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
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
                      Consumer<CategoryModel>(builder: (context, cat, child) {
                    return Text(
                        '${cat.remainingTime ~/ 60}:${cat.remainingTime % 60 < 10 ? "0${cat.remainingTime % 60}" : "${cat.remainingTime % 60}"}',
                        style: TextStyle(
                          color: HSVColor.lerp(
                                  HSVColor.fromColor(Colors.green),
                                  HSVColor.fromColor(Colors.red),
                                  1 - (cat.oxygenValue - 60) / 270)!
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
