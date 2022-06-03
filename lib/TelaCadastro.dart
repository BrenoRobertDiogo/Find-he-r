export 'TelaCadastro.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TelaLogin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final login = TextEditingController();
  final senha = TextEditingController();

  var uuid = const Uuid();

  // Generate a v1 (time-based) id

  void salvaPessoa() {
    var idUsuario = uuid.v1();
    DatabaseReference novoUsuario =
        FirebaseDatabase.instance.reference().child(idUsuario);
    novoUsuario.set({"login": login.text, "senha": senha.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
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
}
