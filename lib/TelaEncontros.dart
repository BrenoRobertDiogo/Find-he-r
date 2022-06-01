import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/TelaConfigsConta.dart';
import 'package:hello_world/models/Pessoa.dart';

class TelaEncontros extends StatefulWidget {
  const TelaEncontros({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaEncontros> createState() => _TelaEncontrosState();
}

class _TelaEncontrosState extends State<TelaEncontros> {
  List<Pessoa> pessoas = [
    Pessoa(
        "Nicolas Cage",
        "H",
        "https://p2.trrsf.com/image/fget/cf/648/0/images.terra.com/2022/01/07/1837881277-willyswonderland-nicolas-cage.jpg",
        40),
    Pessoa(
        "Leonardo Di Caprio",
        "H",
        "https://entertainment.time.com/wp-content/uploads/sites/3/2012/04/leonardo-dicaprio-now.jpg?w=260",
        40),
    Pessoa(
        "Guilherme Briggs",
        "H",
        "https://upload.wikimedia.org/wikipedia/commons/7/71/GuilhermeBriggs.jpg",
        40),
    Pessoa(
        "Will Smith",
        "H",
        "https://s2.glbimg.com/aQu7dyXnWhTmZ74IZ_jJKW5L78w=/600x400/smart/e.glbimg.com/og/ed/f/original/2022/03/28/will-smith-oscat.jpg",
        40)
  ];
  Pessoa pessoaSelecionada = Pessoa(
      "John Wick",
      "H",
      "https://p2.trrsf.com/image/fget/cf/648/0/images.terra.com/2022/01/07/1837881277-willyswonderland-nicolas-cage.jpg",
      40);
  String imagemSelecionada = '';
  _TelaEncontrosState() {
    pessoaSelecionada = pessoas.first;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Findher"),
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaConfigsConta(
                                  title: '',
                                )),
                      )
                    },
                icon: Image.network(
                    "https://icones.pro/wp-content/uploads/2021/02/icone-utilisateur.png") // Icon.asset

                )
          ],
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text('${pessoaSelecionada.nome}',
                        style: TextStyle(fontSize: 25)),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      child: Text('Gostei'),
                      // style:  ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50)),
                      onPressed: mudaPessoa,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        shadowColor: Colors.redAccent,
                        elevation: 3,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      child: Text('Não gostei'),
                      // style:  ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50)),
                      onPressed: mudaPessoa,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
