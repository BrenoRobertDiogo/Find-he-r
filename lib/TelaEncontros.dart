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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localstore/localstore.dart';
import 'package:http/http.dart' as http;
import 'package:find_her/Operations.dart';
import 'models/Tag.dart';

class TelaEncontros extends StatefulWidget {
  const TelaEncontros({
    Key? key,
    required this.title,
    required this.pessoaUser,
    required this.similares,
  }) : super(key: key);
  final String title;
  final Map<String, dynamic> pessoaUser;
  final Map<String, dynamic> similares;

  @override
  State<TelaEncontros> createState() =>
      _TelaEncontrosState(this.pessoaUser, this.similares);
}

class _TelaEncontrosState extends State<TelaEncontros> {
  Map<String, dynamic> similares;

  String imagemSelecionada = '';
  Map<String, dynamic> pessoaUser;
  Map<String, dynamic> pessoa = {"NomeTag": "pessoa"};
  Map<String, dynamic> pessoaAnterior = {"NomeTag": "pessoa"};
  String pessoaSelecionada = "";
  int cont = 0;

  _TelaEncontrosState(this.pessoaUser, this.similares) {
    pessoaSelecionada = this.similares.keys.first;
    getPessoa(pessoaSelecionada);
    getImagemUser();
    pessoaAnterior = pessoa;
  }

  void mudaPessoa() async {
    setState(() {
      if (pessoaSelecionada == this.similares.keys.last) {
        pessoaSelecionada = this.similares.keys.first;
        getPessoa(pessoaSelecionada);
        cont = 0;
      } else {
        pessoaAnterior = pessoa;
        cont += 1;
        pessoaSelecionada = this.similares.keys.elementAt(cont);
        getPessoa(pessoaSelecionada);
      }
    });
    this.pessoaUser["contatos"].add(pessoa);
    FirebaseFirestore.instance
        .collection("users")
        .doc(this.pessoaUser["id"])
        .update(this.pessoaUser);
  }

  void mudaPessoaDislike() async {
    setState(() {
      if (pessoaSelecionada == this.similares.keys.last) {
        pessoaSelecionada = this.similares.keys.first;
        getPessoa(pessoaSelecionada);
        cont = 0;
      } else {
        pessoaAnterior = pessoa;
        cont += 1;
        pessoaSelecionada = this.similares.keys.elementAt(cont);
        getPessoa(pessoaSelecionada);
      }
    });
  }

  Future<String> getImagemUser() async {
    final ref = FirebaseStorage.instance.ref().child('${pessoa["login"]}/img');
    var url = await ref.getDownloadURL();

    return url;
  }

  void getPessoa(id) async {
    var user =
        await Operations.getData('users').where('id', isEqualTo: id).get();
    pessoa = user.docs.first.data();
  }

  @override
  Widget build(BuildContext context) {
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
                                title: '', pessoa: this.pessoaUser)),
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
                  Text('${pessoa["nome"]}',
                      style: const TextStyle(fontSize: 25)),
                  SizedBox(
                    child: FutureBuilder(
                      future: getImagemUser(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
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
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Container();
                      },
                    ),
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
                    onPressed: () {
                      mudaPessoa();
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: verInteresses,
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
                    onPressed: () {
                      mudaPessoaDislike();
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void verInteresses() {
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
                    Text(pessoaAnterior["nome"],
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    Text(", " + 12.toString(), //IDADECOLCA AQUI TROUXA
                        style: const TextStyle(fontSize: 32)),
                  ],
                ),
                Wrap(
                  spacing: MediaQuery.of(context).size.height * 0.02,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [1, 2, 3, 4, 5].map((e) {
                    String es = e.toString();
                    var tag = jsonDecode(pessoa["interesses"]["Tag" + es]);
                    if (pessoa["interesses"]["Tag" + es] != null) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          color: Colors.green,
                          width: 200,
                          // height: 200,
                          child: Column(
                            children: [
                              const Icon(Icons.star),
                              Text(tag["NomeTag"]),
                              Text(tag["Estrelas"].toString()),
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
  }
}
