import 'package:flutter/material.dart';

class WaitingTab extends StatelessWidget {
  var text = "R";
  final int index;
  WaitingTab({super.key, required this.text, required this.index});
  
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Tab(
      height: screenHeight * 0.1,
      child: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide(color: Colors.grey, width: 0.8))
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
