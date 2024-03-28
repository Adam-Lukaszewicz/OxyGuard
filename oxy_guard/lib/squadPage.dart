import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SquadPage extends StatefulWidget{
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  var oxygenValue = 120.0;
  var squadTextStyle = const TextStyle(
    fontSize: 22,
  );
  var infoTextStyle = const TextStyle(
    fontSize: 20,
  );
  var varTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  var unitTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  var bottomButtonStyle = const ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.grey),
    foregroundColor: MaterialStatePropertyAll(Colors.black),
    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
  );
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
                flex: 68,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_pin),
                                  Text("Lokalizacja", style: squadTextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.fire_extinguisher),
                                  Text("Jacek Jaworek", style: squadTextStyle,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.fire_extinguisher),
                                  Text("Jakub Nalepa", style: squadTextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.fire_extinguisher),
                                  Text("Janusz Kowalski", style: squadTextStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 8,
                          right: 8,
                          ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text("Intensywność", style: infoTextStyle),
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle,),
                                        Text("min", style: unitTextStyle),
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text("Bezp. czas.", style: infoTextStyle,), //TODO: Rozszerzanie zależnie od szerokości kontenera
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle,),
                                        Text("min", style: unitTextStyle)
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text("Ostatni pomiar", style: infoTextStyle),
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle),
                                        Text("min", style: unitTextStyle)
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text("Punkt pracy", style: infoTextStyle),
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle),
                                        Text("min", style: unitTextStyle)
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 3),
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: const Text(
                                            "BAR",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            )
                                            ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text("powrót z P.P.", style: infoTextStyle),
                                        ),
                                      ],
                                    ),//TODO: Rozszerzanie zależnie od szerokości kontenera
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle),
                                        Text("BAR", style: unitTextStyle)
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 3),
                                          decoration: const BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: const Text(
                                            "BAR",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            )
                                            ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Text("zał. wyjście", style: infoTextStyle),
                                        ),
                                      ],
                                    ),//TODO: Rozszerzanie zależnie od szerokości kontenera
                                    ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(child: Row(
                                      children: [
                                        Text("TODO", style: varTextStyle),
                                        Text("BAR", style: unitTextStyle)
                                      ],
                                    )),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      )
                  ],
                )
              ),
              Expanded(
                flex: 32,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025, horizontal: screenWidth * 0.042),
                  child: Container(
                    height: screenHeight * 0.7,
                    decoration:  BoxDecoration(
                      border: Border.all(color: Colors.blueGrey.withOpacity(0.8), width: 7),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        ),
                    ),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints){
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Center(child: Text("R2", style: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 65, fontWeight: FontWeight.bold)),),
                          ),
                          Positioned(
                          top: constraints.maxHeight - (oxygenValue * constraints.maxHeight/300.0),
                          left: 1,
                          right: 1,
                          child: ElevatedButton(
                            onPressed: (){
                              //TODO: wprowadzanie
                            },
                            child: Align(alignment:Alignment.center, child: Text(oxygenValue.toInt().toString()))
                            ),
                        ),
                        Positioned(
                          top: 50,
                          left: -3,
                          child: ClipPath(
                            clipper: LeftTriangle(),
                            child: Container(
                              color: Colors.grey,
                              height: 20,
                              width: 20,
                                                    ),
                          )
                        ),
                        Positioned(
                          top: 90,
                          right: -3,
                          child: ClipPath(
                            clipper: RightTriangle(),
                            child: Container(
                              color: Colors.blue,
                              height: 20,
                              width: 20,
                                                    ),
                          )
                        ),
                        Positioned(
                          top: 20,
                          left: 0,
                          right: 0,
                          child: Center(child: Text("330", style: varTextStyle),),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(child: Text("60", style: varTextStyle),),
                        ),
                        
                        ],
                      );},
                    ),
                  ),
                )
              ),
            ],
            ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 40, child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0), child: ElevatedButton(onPressed: (){}, style: bottomButtonStyle, child: Center(child: Text("START PRACY", style: varTextStyle,),)))),
              Expanded(flex: 60,child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0), child: ElevatedButton(onPressed: (){}, style: bottomButtonStyle, child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("OST.POMIAR: ${100}", style: varTextStyle,),
                  Text("BAR", style: unitTextStyle,)
                ],
              ),)))),
            ],
            ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 40,child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0), child: ElevatedButton(onPressed: (){}, style: bottomButtonStyle, child: Center(child: Text("EDYTUJ", style: varTextStyle),)))),
              Expanded(flex: 60,child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0), child: ElevatedButton(onPressed: (){}, style: bottomButtonStyle, child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("CZAS WYJŚCIA: ${5}", style: varTextStyle,),
                  Text("MIN", style: unitTextStyle,)
                ],
              ),)))),
            ],
          ),
        ),
      ],
    );
  }
}

class LeftTriangle extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height/2.0);
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class RightTriangle extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height/2.0);
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}