export 'TelaCadastro.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TelaLogin.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              child: TextField(
                // controller: Text,
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                  // icon: Icon(Icons.person),
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
          ],
        ),
      ),
    );
  }
}
