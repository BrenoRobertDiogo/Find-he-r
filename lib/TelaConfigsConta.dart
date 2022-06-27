import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import 'Operations.dart';
import 'models/Tag.dart';

class TelaConfigsConta extends StatefulWidget {
  final Map<String, dynamic> pessoa;
  const TelaConfigsConta({Key? key, required this.title, required this.pessoa})
      : super(key: key);
  final String title;

  @override
  State<TelaConfigsConta> createState() => _TelaConfigsContaState(pessoa);
}

class _TelaConfigsContaState extends State<TelaConfigsConta> {
  final Map<String, dynamic> pessoa;
  _TelaConfigsContaState(this.pessoa);
  @override
  void initState() {
    super.initState();
    login = TextEditingController(text: pessoa['login']);
    nome = TextEditingController(text: pessoa['nome']);
    TagsUser = [1, 2, 3, 4, 5].map((e) {
      var decoded = jsonDecode(pessoa['interesses']['Tag' + e.toString()]);
      return TextEditingController(text: decoded['NomeTag']);
    }).toList();
    NotasUser = [1, 2, 3, 4, 5].map((e) {
      var decoded = jsonDecode(pessoa['interesses']['Tag' + e.toString()]);
      return TextEditingController(text: decoded['Estrelas'].toString());
    }).toList();

    getImagemUser();
  }

  Future<String> getImagemUser() async {
    final ref = FirebaseStorage.instance.ref().child('${pessoa["login"]}/img');
    var url = await ref.getDownloadURL();
    return url;
  }

  TextEditingController? login;
  TextEditingController? nome;

  Map<String, dynamic> USER_LOGADO_DATA = {
    "RedesSociais": {"Facebook": "", "Instagram": "", "Twitter": ""},
    "id": "",
    "interesses": {"Tag1": "", "Tag2": "", "Tag3": "", "Tag4": "", "Tag5": ""},
    "login": "",
    "nome": "",
    "senha": "",
    "sexo": ""
  };

  List<TextEditingController>? TagsUser;
  List<TextEditingController>? NotasUser;
  Localstore loginUser = Localstore.instance;
  String urlImagem =
      "https://s2.glbimg.com/aQu7dyXnWhTmZ74IZ_jJKW5L78w=/600x400/smart/e.glbimg.com/og/ed/f/original/2022/03/28/will-smith-oscat.jpg";

  bool editing = false;

  Future<void> modoEditar() async {
    print(NotasUser!);
    setState(() {
      editing = !editing;
      for (var i in [1, 2, 3, 4, 5]) {
        int notaUser = NotasUser![i - 1].text == ''
            ? 0
            : int.parse(NotasUser![i - 1].text);
        String tagUser = TagsUser![i - 1].text;
        USER_LOGADO_DATA['interesses']['Tag' + i.toString()] =
            jsonEncode(Tag(tagUser, notaUser).TagToSend());
      }
      USER_LOGADO_DATA['nome'] = nome!.text;
      USER_LOGADO_DATA['login'] = login!.text;
    });
  }

  Future<void> salvarAlteracoes() async {
    final users = await Operations.getData('users').doc(pessoa['id']);
    users.update({
      "login": login!.text,
      "nome": nome!.text,
      "interesses": {
        'Tag1': jsonEncode(
            Tag(TagsUser![0].text, int.parse(NotasUser![0].text)).TagToSend()),
        'Tag2': jsonEncode(
            Tag(TagsUser![1].text, int.parse(NotasUser![1].text)).TagToSend()),
        'Tag3': jsonEncode(
            Tag(TagsUser![2].text, int.parse(NotasUser![2].text)).TagToSend()),
        'Tag4': jsonEncode(
            Tag(TagsUser![3].text, int.parse(NotasUser![3].text)).TagToSend()),
        'Tag5': jsonEncode(
            Tag(TagsUser![4].text, int.parse(NotasUser![4].text)).TagToSend()),
      }
    });
    setState(() {
      editing = !editing;
    });
  }

  void cancelarAlteracoes() {
    setState(() {
      editing = !editing;
      for (var i in [1, 2, 3, 4, 5]) {
        var decoded =
            jsonDecode(USER_LOGADO_DATA['interesses']['Tag' + i.toString()]);
        NotasUser![i - 1].text = decoded['Estrelas'].toString();
        TagsUser![i - 1].text = decoded['NomeTag'];
      }
      nome!.text = USER_LOGADO_DATA['nome'];
      login!.text = USER_LOGADO_DATA['login'];
    });
  }

  verInteresses() async {
    final dataUser = pessoa;
    Map<String, dynamic> interesses = await dataUser["interesses"];
    List<String> numeros = ["1", "2", "3", "4", "5"];
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
                            Text(jsonDecode(interesses["Tag" + e])["NomeTag"]),
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

  void verificaNota(String nota, int i) {
    if (int.parse(nota) > 10) {
      NotasUser![i].text = "10";
    } else if (int.parse(nota) < 0) {
      NotasUser![i].text = "0";
    } else if (nota == "") {
      NotasUser![i].text = "0";
    } else {
      NotasUser![i].text = int.parse(nota).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getUser();
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
            FutureBuilder(
              future: getImagemUser(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    width: 300,
                    height: 250,
                    child: Image.network(snapshot.data!),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ); //
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Container();
              },
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
                  labelText: 'Seu login',
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
              child: Text((editing ? 'Editar' : 'Ver') + ' Interesses'),
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
