import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TelaConfigsConta extends StatefulWidget {
  const TelaConfigsConta({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaConfigsConta> createState() => _TelaConfigsContaState();
}

class _TelaConfigsContaState extends State<TelaConfigsConta> {
  bool editing = false;

  void modoEditar() {
    setState(() {
      editing = !editing;
    });
  }

  void salvarAlteracoes() {
    setState(() {
      editing = !editing;
    });
  }

  void cancelarAlteracoes() {
    setState(() {
      editing = !editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sua conta"),
        actions: [
          IconButton(
            onPressed: !editing ? modoEditar : null,
            icon: Icon((!editing) ? Icons.edit : null),
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextField(
                // controller: Text,
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  enabled: editing,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextField(
                // controller: Text,
                decoration: InputDecoration(
                  labelText: 'Seu email',
                  enabled: editing,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (editing)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  onPressed: cancelarAlteracoes,
                  icon: const Icon(Icons.cancel_outlined),
                ),
                IconButton(
                  onPressed: salvarAlteracoes,
                  icon: const Icon(Icons.save),
                )
              ]),
          ],
        ),
      ),
    );
  }
}
