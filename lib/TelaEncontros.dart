import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_her/TelaHomeChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:find_her/TelaConfigsConta.dart';
import 'package:find_her/models/Pessoa.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:localstore/localstore.dart';
import 'package:http/http.dart' as http;
import 'package:find_her/Operations.dart';

import 'models/Tag.dart';

class TelaEncontros extends StatefulWidget {
  const TelaEncontros({Key? key, required this.title, required this.pessoa})
      : super(key: key);
  final String title;
  final Map<String, dynamic> pessoa;

  @override
  State<TelaEncontros> createState() => _TelaEncontrosState(this.pessoa);
}

class _TelaEncontrosState extends State<TelaEncontros> {
  List<Pessoa> pessoas = [
    Pessoa([
      Tag("Televisão", 5),
      Tag("Animais", 4),
      Tag("Beber", 3),
      Tag("Música", 2),
      null
    ],
        "Nicolas Cage",
        '123',
        "H",
        "https://p2.trrsf.com/image/fget/cf/648/0/images.terra.com/2022/01/07/1837881277-willyswonderland-nicolas-cage.jpg",
        40),
    Pessoa([
      Tag("Televisão", 5),
      Tag("Animais", 4),
      Tag("Beber", 3),
      Tag("Música", 2),
      null
    ],
        "Leonardo Di Caprio",
        '123',
        "H",
        "https://entertainment.time.com/wp-content/uploads/sites/3/2012/04/leonardo-dicaprio-now.jpg?w=260",
        40),
    Pessoa([
      Tag("Televisão", 5),
      Tag("Animais", 4),
      Tag("Beber", 3),
      Tag("Música", 2),
      null
    ],
        "Guilherme Briggs",
        '123',
        "H",
        "https://upload.wikimedia.org/wikipedia/commons/7/71/GuilhermeBriggs.jpg",
        40),
    Pessoa(
      [
        Tag("Televisão", 5),
        Tag("Animais", 4),
        Tag("Beber", 3),
        Tag("Música", 2),
        null
      ],
      "Will Smith",
      '123',
      "H",
      "https://s2.glbimg.com/aQu7dyXnWhTmZ74IZ_jJKW5L78w=/600x400/smart/e.glbimg.com/og/ed/f/original/2022/03/28/will-smith-oscat.jpg",
      40,
    )
  ];
  Map<String, dynamic> pessoa;
  late dynamic Usersinteresses = {};
  Pessoa pessoaSelecionada = Pessoa([
    Tag("Televisão", 5),
    Tag("Animais", 4),
    Tag("Beber", 3),
    Tag("Música", 2),
    null
  ],
      "John Wick",
      '123',
      "H",
      "https://p2.trrsf.com/image/fget/cf/648/0/images.terra.com/2022/01/07/1837881277-willyswonderland-nicolas-cage.jpg",
      40);
  String imagemSelecionada = '';

  _TelaEncontrosState(this.pessoa) {
    pessoaSelecionada = pessoas.first;
  }

  Future<void> get_interesses() async {
    final response = await http.post(
      Uri.parse('https://api-recomendacao-flutter.herokuapp.com/similar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': this.pessoa["id"],
      }),
    );
    Map<String, dynamic> unsorted = jsonDecode(response.body)["similares"];
    Usersinteresses = unsorted;
  }

  void mudaPessoa() {
    setState(() {
      if (pessoaSelecionada == pessoas.last) {
        pessoaSelecionada = pessoas.first;
      } else {
        pessoaSelecionada = pessoas[pessoas.lastIndexOf(pessoaSelecionada) + 1];
      }
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPessoa(id) async {
    var user =
        await Operations.getData('users').where('id', isEqualTo: id).get();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    get_interesses();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Findher"),
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaConfigsConta(
                                title: '', pessoa: this.pessoa)),
                      )
                    },
                icon: Image.network(
                    "https://icones.pro/wp-content/uploads/2021/02/icone-utilisateur.png") // Icon.asset

                ),
            IconButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaHomeChat(
                                  title: '',
                                )),
                      )
                    },
                icon: const Icon(Icons.chat))
          ],
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text('${pessoaSelecionada.nome}',
                      style: const TextStyle(fontSize: 25)),
                  SizedBox(
                    child: Image(
                        image: NetworkImage('${pessoaSelecionada.imagem}')),
                    width: MediaQuery.of(context).size.width *
                        0.6, // Pegando tamanho real da tela e transformando em porcentagem
                    height: MediaQuery.of(context).size.height * 0.6,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      // <-- Icon
                      Icons.thumb_up,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,

                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.06,
                          vertical: 20),
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                    label: const Text('Gostei'),
                    // style:  ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50)),
                    onPressed: mudaPessoa,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(pessoaSelecionada.nome!,
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          ", " +
                                              pessoaSelecionada.idade!
                                                  .toString(),
                                          style: const TextStyle(fontSize: 32)),
                                    ],
                                  ),
                                  Wrap(
                                    spacing:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: pessoaSelecionada.tags.map((e) {
                                      if (e != null) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: Container(
                                            color: Colors.green,
                                            width: 200,
                                            // height: 200,
                                            child: Column(
                                              children: [
                                                const Icon(Icons.star),
                                                Text(e.Nome),
                                                Text(
                                                  e.QtdEstrelas.toString(),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    }).toList(),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(000, 000, 000, 0.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                    ),
                    icon: const Icon(
                      // <-- Icon
                      Icons.info,
                      color: Colors.white,
                    ),
                    label: const Text(''),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      // <-- Icon
                      Icons.thumb_down,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.06,
                          vertical: 20),
                      shadowColor: Colors.redAccent,
                      elevation: 3,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                    label: const Text('Não gostei'),
                    // style:  ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50)),
                    onPressed: mudaPessoa,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
