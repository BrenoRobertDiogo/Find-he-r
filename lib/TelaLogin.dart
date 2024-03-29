import 'package:find_her/Operations.dart';
import 'package:flutter/material.dart';
import 'package:find_her/TelaCadastro.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Map<String, dynamic> similares =
        await getInteresses(userId["id"]); //.sort((x, y) => a);

    List<Map<String, dynamic>> alinhado = similares.keys.map((String x) {
      return {"id": x, "nota": similares[x]};
    }).toList();

    alinhado.sort((x, y) {
      return x["nota"].compareTo(y["nota"]);
    });

    similares = {};
    alinhado.forEach((x) {
      similares[x["id"]] = x["nota"];
    });

    QuerySnapshot<Map<String, dynamic>> primeiroUserQuery =
        await Operations.getData('users')
            .where('id', isEqualTo: similares.keys.first)
            .get();

    Map<String, dynamic> primeiroUser = primeiroUserQuery.docs.first.data();

    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TelaEncontros(
                title: "",
                pessoa: user.docs.first.data(),
                similares: similares,
                primeiroUser: primeiroUser,
              )),
    );
  }

  Future<Map<String, dynamic>> getInteresses(id) async {
    final response = await http.post(
      Uri.parse('https://api-recomendacao-flutter.herokuapp.com/similar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control_Allow_Origin": "*"
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    Map<String, dynamic> usersInteresses =
        await jsonDecode(response.body)["similares"];

    return usersInteresses;
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

  void sobreNos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sobre Nós"),
          content: Text(
              "O aplicativo aqui presente foi ministrado pelo professor André Ribeiro da Silva,referente a materia de Aplicativos Mobile 2022/1 e tem como objetivo simular aplicativos de relacionamento como tinder utilizando agoritimo de distância euclidiana.\n\nDesenvolvido pelos alunos: \nAquiles Aguiar \nBreno Robert \nCaio Roberto"),
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
      appBar: AppBar(
        title: const Text("Findher"),
        actions: [
          IconButton(onPressed: sobreNos, icon: Icon(Icons.info) // Icon.asset
              )
        ],
      ),
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
                onPressed: logar),
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
            )
          ],
        ),
      ),
    );
  }
}
