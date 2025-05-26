import 'package:flutter/material.dart';

class WaitingTab extends StatelessWidget {
  const WaitingTab({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Tab(
      height: screenHeight * 0.1,
      child: Container(
        decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.grey, width: 0.8))),
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(
              fontSize: screenWidth * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
