import 'dart:async';

import 'package:OxyGuard/models/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../legacy/services/gps_service.dart';

class TeamTab extends StatefulWidget {
  const TeamTab({super.key, required this.team});

  final Team team;

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
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
    var screenHeight = MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!).viewPadding.vertical;
    var screenWidth = MediaQuery.of(context).size.width;

    final int timeRemaining =
        widget.team.isInCrisis ? widget.team.getTimeRemainingInCrisis() : widget.team.getTimeRemaining();
    final String tabText =
        '${timeRemaining ~/ 60}:${timeRemaining % 60 < 10 ? "0${timeRemaining % 60}" : "${timeRemaining % 60}"}';

    return Tab(
      height: screenHeight * 0.1,
      child: Container(
        decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.grey, width: 0.8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Stack(
                children: [
                  Text(
                    tabText,
                    style: TextStyle(
                        height: 1.0,
                        fontSize: screenWidth * 0.065,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = Colors.white),
                  ),
                  Text(tabText,
                      style: TextStyle(
                        height: 1.0,
                        color: HSVColor.lerp(HSVColor.fromColor(Colors.green), HSVColor.fromColor(Colors.red),
                                1 - (widget.team.getOxygenRemaining() - 60) / 270)!
                            .toColor(),
                        fontSize: screenWidth * 0.065,
                      )),
                ],
              ),
            ),
            Center(
              child: Text(
                widget.team.name,
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
