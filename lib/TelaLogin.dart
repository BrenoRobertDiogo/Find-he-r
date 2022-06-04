import 'package:find_her/Operations.dart';
import 'package:find_her/models/Pessoa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:find_her/TelaCadastro.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'TelaEncontros.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final login = TextEditingController();
  final senha = TextEditingController();

  logar() async {
    var senhaCript = sha512.convert(utf8.encode(senha.text)).toString();
    // QuerySnapshot users = Operations.getData('users').get();// FirebaseFirestore.instance.collection('users').get();
    var compara = await Operations.getData('users').where('login', isEqualTo: login.text).where('senha', isEqualTo: senhaCript).get();
    print(compara);
    if(compara.docs.isEmpty) {
      return _exibirDialogo();
    }
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const TelaEncontros(title: "")),
    );/*
    for (var user in users.docs) {
      Map<String, dynamic>? userAtual = user.data() as Map<String, dynamic>?;
      if (login.text == userAtual!["login"] &&
          senhaCript == userAtual!["senha"]) {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TelaEncontros(title: "")),
        );
      }
    }*/
  }

  void _exibirDialogo() {
    // Limpa caixa de texto
    login.clear();
    senha.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login error"),
          content:
              const Text("Login ou senha estão errados, tente novamente !"),
          actions: <Widget>[
            // define os botões na base do dialogo
            ElevatedButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Findher")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: TextField(
                autofocus: true,
                controller: login,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  // hintText: 'Informe seu nome'
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: senha,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.lock),
                  // hintText: 'Informe sua senha'
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                child: const Text('Logar'),
                style: ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
                onPressed: logar //() {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const TelaEncontros(
                //               title: '',
                //             )),
                //   );
                // },
                ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              child: const Text('Cadastrar'),
              style: ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TelaCadastro(
                            title: '',
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
