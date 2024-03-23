import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SquadPage extends StatefulWidget{
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  var oxygenValue = 150.0;
  @override
  Widget build(BuildContext context){
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.red,
                )
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025, horizontal: screenWidth * 0.1),
                  child: Container(
                    height: screenHeight * 0.7,
                    decoration:  BoxDecoration(
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        ),
                    ),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                      return Stack(
                        children: [Positioned(
                          top: constraints.maxHeight - (oxygenValue * constraints.maxHeight/300.0),
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          child: ElevatedButton(
                            onPressed: (){
                              //TODO: wprowadzanie
                            },
                            child: Align(alignment:Alignment.center, child: Text(oxygenValue.toInt().toString()))
                            ),
                        )],
                      );},
                    ),
                  ),
                )
              ),
            ],
            ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              ElevatedButton(onPressed: (){}, child: Center(child: Text("Start pracy"),)),
              ElevatedButton(onPressed: (){}, child: Center(child: Text("Edytuj"),)),
            ],
            ),
        ),
      ],
    );
  }
}