import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/squad_model.dart';
import '../../../services/global_service.dart';

class SquadTab extends StatefulWidget {
  var text = "R";
  final int index;
  SquadTab({super.key, required this.text, required this.index});
  SquadTab.fromJson(Map<String, Object?> json)
      : this(text: json["Text"]! as String, index: json["Index"]! as int);

  Map<String, Object?> toJson() {
    return {"Text": text, "Index": index};
  }

  @override
  State<SquadTab> createState() => _SquadTabState();
}

class _SquadTabState extends State<SquadTab> {
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Tab(
      height: screenHeight * 0.1,
      child: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide(color: Colors.grey, width: 0.8))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Consumer<SquadModel>(builder: (context, cat, child) {
                var tabText = '${cat.getTimeRemaining(widget.index) ~/ 60}:${cat.getTimeRemaining(widget.index) % 60 < 10 ? "0${cat.getTimeRemaining(widget.index) % 60}" : "${cat.getTimeRemaining(widget.index) % 60}"}';
                return Stack(
                  children: [
                    Text(
                      tabText,
                      style: TextStyle(
                        height: 1.0,
                        fontSize: screenWidth * 0.065,
                        foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white
                      ),
                    ),
                    Text(
                      tabText,
                      style: TextStyle(
                        height: 1.0,
                        color: HSVColor.lerp(
                                HSVColor.fromColor(Colors.green),
                                HSVColor.fromColor(Colors.red),
                                1 -
                                    (cat.getOxygenRemaining(widget.index) -
                                            60) /
                                        270)!
                            .toColor(),
                        fontSize: screenWidth * 0.065,
                      )),
                  ],
                );
              }),
            ),
            Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: screenWidth * 0.075,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
