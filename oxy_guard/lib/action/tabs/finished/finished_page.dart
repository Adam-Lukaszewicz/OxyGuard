import 'package:flutter/material.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:provider/provider.dart';

class FinishedPage extends StatelessWidget {
  FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: ListView(
            children: Provider.of<SquadModel>(context, listen: false)
                .finishedSquads
                .values
                .toList()
                .map((fin) => Card(
                      child: ListTile(
                        leading: Text(fin.name),
                        title: Text(fin.averageUse.toString()),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
