export 'TelaCadastro.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final login = TextEditingController();
  final senha = TextEditingController();
  String sexoSelecionado = "Alfas";

  var uuid = const Uuid();

  void salvaPessoa() {
    var senhaCript = sha512.convert(utf8.encode(senha.text)).toString();
    var idUsuario = uuid.v1();

    FirebaseFirestore.instance.collection("users").doc(idUsuario).set({
      "id": idUsuario,
      "login": login.text,
      "senha": senhaCript,
      "testando": {"Tag1": 5, "Tag2": 5, "Tag3": 5, "Tag4": 5, "Tag5": 5}
    });
    // Other jeito
    // DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    // DatabaseReference novoUsuario = ref.push();
    // novoUsuario
    //     .set({"id": idUsuario, "login": login.text, "senha": senhaCript});
  }

  @override
  Widget build(BuildContext context) {
    List<String> _valores = ['Alfas', 'Betas', 'Resto'];
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 400,
              child: TextField(
                // controller: login,
                decoration: InputDecoration(
                    labelText: 'Digite seu nome',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.pending_actions),
                    hintText: 'Informe seu nome'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: login,
                decoration: const InputDecoration(
                    labelText: 'Login',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    hintText: 'Informe seu login'),
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
                    hintText: 'Informe sua senha'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              // color: Color.fromRGBO(95, 175, 2, 0.7568627450980392),
              width: 400,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(95, 175, 2, 1.0),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.star),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(95, 175, 2, 1.0),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.star),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(95, 175, 2, 1.0),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.star),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(95, 175, 2, 1.0),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.star),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(95, 175, 2, 1.0),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.star),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownButton<String>(
              items: _valores.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (String? x) => {
                if (x != null) {setaM(x)}
              },
              value: sexoSelecionado,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
              child: const Text('Cadastrar'),
              onPressed: salvaPessoa,
            ),
          ],
        ),
      ),
    );
  }

  void setaM(String x) {
    print('entrou aqui');
    setState(() => {sexoSelecionado = x});
  }
}
