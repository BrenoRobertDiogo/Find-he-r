
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/TelaCadastro.dart';

import 'TelaEncontros.dart';
class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    // appBar: AppBar(title: Text("Findher")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Container(
            width: 400,
            child: TextField(
              // controller: Text,
              decoration: InputDecoration(
                labelText: 'Login',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  // hintText: 'Informe seu nome'
              ),
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            width: 400,
            child: TextField(
              // controller: Text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.lock),
                  // hintText: 'Informe sua senha'
              ),

            ),
          ),
          const SizedBox(height: 16,),
          ElevatedButton(
            child: const Text('Logar'),
            style:  ElevatedButton.styleFrom(fixedSize: Size(400, 50)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaEncontros(title: '',)),
              );
            },
          ),
          const SizedBox(height: 16,),
          OutlinedButton(
            child: const Text('Cadastrar'),
            style:  ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaCadastro(title: '',)),
              );
            },
          ),

        ],
      ),
    ),
  );
  }
}