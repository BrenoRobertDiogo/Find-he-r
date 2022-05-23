import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaConfigsConta extends StatefulWidget {
  const TelaConfigsConta({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaConfigsConta> createState() => _TelaConfigsContaState();
}

class _TelaConfigsContaState extends State<TelaConfigsConta> {
  @override
  Widget build(BuildContext context) {
    bool editing = true;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sua conta"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                editing = !editing;
              });
            },
            icon: Icon( (editing == false) ? Icons.edit : Icons.save, size: 60),
          )
        ],
        centerTitle: true,
      ),
      body: Center(

        child: Container(
          child: Column(
            children: [
              TextField(
                // controller: Text,
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  enabled: editing,
                  border: OutlineInputBorder(),
                ),

              ),
              TextField(
                // controller: Text,
                decoration: InputDecoration(
                  labelText: 'Seu email',
                  enabled: editing,
                  border: OutlineInputBorder(),
                ),

              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    editing = !editing;
                  });
                },
                icon: Icon( (editing == false) ? Icons.edit : Icons.save, size: 60),
              )

            ],
          ),
        ),
      ),
    );
  }
}
