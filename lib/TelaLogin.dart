import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:find_her/TelaCadastro.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'TelaEncontros.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class User {
  final String login;
  final String senha;

  User(this.login, this.senha);
}

class _TelaLoginState extends State<TelaLogin> {
  final login = TextEditingController();
  final senha = TextEditingController();

  Future<void> logar() async {
    var senhaCript = sha512.convert(utf8.encode(senha.text)).toString();
    var users = await FirebaseFirestore.instance.collection('users').get();

    users.docs.first.data().keys.forEach((x) => print(x));
    users.docs.forEach((x) => {print(x.data().keys)});
  }

  List<Widget> printLogin(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      print(document.get('login'));
    });
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
