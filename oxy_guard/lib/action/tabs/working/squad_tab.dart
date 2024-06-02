import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/squad_model.dart';
import '../../../global_service.dart';

class TabSquad extends StatefulWidget {
  var text = "R";
  final int index;
  TabSquad({super.key, required this.text, required this.index});
  TabSquad.fromJson(Map<String, Object?> json)
      : this(text: json["Text"]! as String, index: json["Index"]! as int);

  Map<String, Object?> toJson() {
    return {"Text": text, "Index": index};
  }

  @override
  State<TabSquad> createState() => _TabSquadState();
}

class _TabSquadState extends State<TabSquad> {
  late Timer halfSec;

  @override
  void initState() {
    super.initState();
    halfSec = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight =
        MediaQuery.of(GlobalService.navigatorKey.currentContext!).size.height -
            MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .viewPadding
                .vertical;
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
                  child: Consumer<SquadModel>(builder: (context, cat, child) {
                    return Text(
                        '${cat.getTimeRemaining(widget.index) ~/ 60}:${cat.getTimeRemaining(widget.index) % 60 < 10 ? "0${cat.getTimeRemaining(widget.index) % 60}" : "${cat.getTimeRemaining(widget.index) % 60}"}',
                        style: TextStyle(
                          color: HSVColor.lerp(
                                  HSVColor.fromColor(Colors.green),
                                  HSVColor.fromColor(Colors.red),
                                  1 -
                                      (cat.getOxygenRemaining(widget.index) -
                                              60) /
                                          270)!
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
                    widget.text,
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
