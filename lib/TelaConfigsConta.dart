import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:localstore/localstore.dart';

import 'models/Tag.dart';

class TelaConfigsConta extends StatefulWidget {
  final Map<String, dynamic> pessoa;
  const TelaConfigsConta({Key? key, required this.title, required this.pessoa}) : super(key: key);
  final String title;

  @override
  State<TelaConfigsConta> createState() => _TelaConfigsContaState(pessoa);
}

class _TelaConfigsContaState extends State<TelaConfigsConta> {
  final Map<String, dynamic> pessoa;
  _TelaConfigsContaState(this.pessoa);
  @override
  void initState() {
    print(this.pessoa['teste']);
    this.login = TextEditingController(text: this.pessoa['teste']);
    this.nome = TextEditingController(text: "this.pessoa['teste']");
  }

  TextEditingController? login;
  TextEditingController? nome;

  Map<String, dynamic> USER_LOGADO_DATA = {
    "RedesSociais": {
      "Facebook": "",
      "Instagram": "",
      "Twitter": ""
    },
    "id": "",
    "interesses": {
      "Tag1": "",
      "Tag2": "",
      "Tag3": "",
      "Tag4": "",
      "Tag5": ""
    },
    "login": "",
    "nome": "",
    "senha": "",
    "sexo": ""
  };

  List<TextEditingController> TagsUser = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  Localstore loginUser = Localstore.instance;


  Future getUserData() async {
    final dataUser = await loginUser.collection('users').doc("user").get();
    Map<String, dynamic> interesses = await dataUser!["interesses"];
  }

  bool editing = false;

  void getUser() async {
    final dataUser = await loginUser.collection('users').doc("user").get();
    setState(() {
      login!.text = dataUser!["login"];
      nome!.text = dataUser["nome"];
    });
  }

  Future<void> modoEditar() async {
    final dataUser = await loginUser.collection('users').doc("user").get();
    print(dataUser);
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

  verInteresses() async {
    final dataUser = await loginUser.collection('users').doc("user").get();
    Map<String, dynamic> interesses = await dataUser!["interesses"];
    List<String> numeros = ["1", "2", "3", "4", "5"];
    numeros.forEach((e) {
      if(jsonDecode(interesses["Tag" + e.toString()])["NomeTag"] != ""){
        print('teste');
        print(jsonDecode(interesses["Tag" + e.toString()])["NomeTag"]);
        TagsUser[int.parse(e)-1].text = jsonDecode(interesses["Tag" + e.toString()])["NomeTag"];
        TagsUser[int.parse(e)-1].text = "asasasddasasdasdsd";
      }
    });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: numeros.map((e) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      color: Colors.green,
                      width: 200,
                      // height: 200,
                      child: Column(
                        children: [
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            const Icon(Icons.star),
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextField(
                                controller: nome,
                                decoration: InputDecoration(
                                  labelText: 'Seu nome',
                                  enabled: editing,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            Text(
                              jsonDecode(interesses["Tag" + e])["Estrelas"]
                                  .toString(),
                            )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
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
            Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://s2.glbimg.com/aQu7dyXnWhTmZ74IZ_jJKW5L78w=/600x400/smart/e.glbimg.com/og/ed/f/original/2022/03/28/will-smith-oscat.jpg"))),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextField(
                controller: nome,
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
                controller: login,
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
              child: const Text('Ver Interesses'),
              onPressed: verInteresses,
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