import 'package:find_her/Operations.dart';
import 'package:find_her/models/Pessoa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:find_her/TelaCadastro.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:localstore/localstore.dart';
import 'package:http/http.dart' as http;

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
    var user = await Operations.getData('users')
        .where('login', isEqualTo: login.text)
        .where('senha', isEqualTo: senhaCript)
        .get();

    if (user.docs.isEmpty) {
      return _exibirDialogo();
    }
    Map<String, dynamic> userId = user.docs.first.data();
    Map<String, dynamic> similares = await getInteresses(userId["id"]);
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TelaEncontros(
                title: "",
                pessoaUser: user.docs.first.data(),
                similares: similares,
              )),
    );
  }

  Future<Map<String, dynamic>> getInteresses(id) async {
    final response = await http.post(
      Uri.parse('https://api-recomendacao-flutter.herokuapp.com/similar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    Map<String, dynamic> Usersinteresses =
        await jsonDecode(response.body)["similares"];

    return Usersinteresses;
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
