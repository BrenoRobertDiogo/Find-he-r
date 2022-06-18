import 'package:cloud_firestore/cloud_firestore.dart';
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
  const TelaHomeChat({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaHomeChat> createState() => _TelaHomeChatState();
}

class _TelaHomeChatState extends State<TelaHomeChat> {
  final nome = TextEditingController();
  Localstore loginUser = Localstore.instance;

  void abrirUrl(host, path) async {
    final Uri toLaunch = Uri(scheme: 'https', host: host, path: path);
    if (!await launchUrl(toLaunch)) throw 'Could not launch $host';
  }

  verInteresses() async {
    final dataUser = await loginUser.collection('users').doc("user").get();
    Map<String, dynamic> interesses = await dataUser!["interesses"];
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
        appBar: AppBar(centerTitle: true, title: const Text('Conversas')),
        body: Row(children: [
          GestureDetector(
              onTap: () {
                verInteresses();
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(40.0, 20.0, 20.0, 20.0),
                width: 70.0,
                height: 70.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://s2.glbimg.com/aQu7dyXnWhTmZ74IZ_jJKW5L78w=/600x400/smart/e.glbimg.com/og/ed/f/original/2022/03/28/will-smith-oscat.jpg"))),
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
            width: 150,
            child: const Text(
              "Will Smith",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
          IconButton(
            onPressed: () => abrirUrl("www.facebook.com", "VenomExtreme/"),
            icon: const Icon(FontAwesomeIcons.facebook,
                color: Colors.blue, size: 20.0),
          ),
          IconButton(
            onPressed: () => abrirUrl("www.instagram.com", "brdds.br/"),
            icon: const Icon(FontAwesomeIcons.instagram,
                color: Colors.blue, size: 20.0),
          ),
          IconButton(
            onPressed: () => abrirUrl("www.twitter.com", "nocntxt_tdm/"),
            icon: const Icon(FontAwesomeIcons.twitter,
                color: Colors.blue, size: 20.0),
          ),
        ]));
  }
}
