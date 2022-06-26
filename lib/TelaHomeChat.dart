import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localstore/localstore.dart';

class TelaHomeChat extends StatefulWidget {
  const TelaHomeChat({Key? key, required this.title, required this.pessoa})
      : super(key: key);
  final String title;
  final Map<String, dynamic> pessoa;

  @override
  State<TelaHomeChat> createState() => _TelaHomeChatState(this.pessoa);
}

class _TelaHomeChatState extends State<TelaHomeChat> {
  final nome = TextEditingController();
  Localstore loginUser = Localstore.instance;

  Map<String, dynamic> pessoa;

  _TelaHomeChatState(this.pessoa) {}

  void abrirUrl(host, path) async {
    final Uri toLaunch = Uri(scheme: 'https', host: host, path: "$path/");
    if (!await launchUrl(toLaunch)) throw 'Could not launch $host';
  }

  Future<String> getImagemUser(login) async {
    final ref = FirebaseStorage.instance.ref().child('$login/img');
    var url = await ref.getDownloadURL();
    return url;
  }

  verInteresses(interesses) async {
    List<String> numeros = ["1", "2", "3", "4", "5"];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: numeros.map((e) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      color: Colors.green,
                      width: 200,
                      // height: 200,
                      child: Column(
                        children: [
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            const Icon(Icons.star),
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            Text(jsonDecode(interesses["Tag" + e])["NomeTag"]),
                          if (jsonDecode(interesses["Tag" + e])["NomeTag"] !=
                              "")
                            Text(
                              jsonDecode(interesses["Tag" + e])["Estrelas"]
                                  .toString(),
                            )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Contatos')),
        body: SingleChildScrollView(
            child: Column(
              children: verContatos(),
            )
        )
        );
  }

  verContatos() {
    var contatosUser = pessoa["contatos"];
    List<Widget> listContatos = [];
    for (var value in contatosUser) {
      var contato = Row(children: [
        GestureDetector(
            onTap: () {
              verInteresses(value["interesses"]);
            },
            child: FutureBuilder(
              future: getImagemUser(value["login"]),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    width: 50,
                    height: 50,
                    child: Image.network(snapshot.data!),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ); //
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Container();
              },
            )),
        Container(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
          width: 150,
          child: Text(
            value["nome"],
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
        IconButton(
          onPressed: () => value["RedesSociais"]["Facebook"] == ""
              ? null
              : abrirUrl("www.facebook.com", value["RedesSociais"]["Facebook"]),
          icon: Icon(FontAwesomeIcons.facebook,
              color: (value["RedesSociais"]["Facebook"] == ""
                  ? Colors.grey
                  : Colors.blue),
              size: 20.0),
        ),
        IconButton(
          onPressed: () => value["RedesSociais"]["Instagram"] == ""
              ? null
              : abrirUrl(
              "www.instagram.com", value["RedesSociais"]["Instagram"]),
          icon: Icon(FontAwesomeIcons.instagram,
              color: (value["RedesSociais"]["Instagram"] == ""
                  ? Colors.grey
                  : Colors.blue),
              size: 20.0),
        ),
        IconButton(
          onPressed: () => value["RedesSociais"]["Twitter"] == ""
              ? null
              : abrirUrl("www.twitter.com", value["RedesSociais"]["Twitter"]),
          icon: Icon(FontAwesomeIcons.twitter,
              color: (value["RedesSociais"]["Twitter"] == ""
                  ? Colors.grey
                  : Colors.blue),
              size: 20.0),
        ),
      ]);
      listContatos.add(contato);
    }
    return listContatos;
  }
}
