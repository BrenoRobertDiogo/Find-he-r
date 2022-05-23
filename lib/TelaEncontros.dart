import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/TelaConfigsConta.dart';

class TelaEncontros extends StatefulWidget {
  const TelaEncontros({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaEncontros> createState() => _TelaEncontrosState();
}

class _TelaEncontrosState extends State<TelaEncontros> {
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
            MaterialPageRoute(builder: (context) => const TelaConfigsConta(title: '',)),
            )
            },
            icon: Image.network('https://icones.pro/wp-content/uploads/2021/02/icone-utilisateur.png') // Icon.asset

          )

        ],
        centerTitle: true,

      ),
      body:
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                child: Column(
                  children: [
                    Container(
                      child: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/c0/Nicolas_Cage_Deauville_2013.jpg')),
                      width: MediaQuery.of(context).size.width * 1, // Pegando tamanho real da tela e transformando em porcentagem
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
                            onPressed: () {},
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
                            onPressed: () {},
                          ),
                        ],
                      ),
                )
              ],

            ),
          )

    );
  }
}
