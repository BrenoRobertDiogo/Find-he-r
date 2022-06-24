export 'TelaCadastro.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:find_her/models/Tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:date_field/date_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:find_her/TelaLogin.dart';

import 'Operations.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final login = TextEditingController();
  final nomeC = TextEditingController();
  final senha = TextEditingController();
  final instagramID = TextEditingController();
  final twitterID = TextEditingController();
  final facebookID = TextEditingController();
  DateTime dataNascimento = DateTime(0, 0, 0, 0, 0);

  final tagSelecionadaCampo = TextEditingController();
  String sexoSelecionado = "Homem";
  final campoNotaAtual = TextEditingController(text: "5");
  XFile? imagemPessoa = XFile('assets/imagemPadrao.png');
  final ImagePicker _picker = ImagePicker();
  List<String> StringsTags = [
    "Televisão",
    "Animais",
    "Beber",
    "Música",
    "Viajar",
    "Pintar",
    "Cantar"
  ];
  int tagSelecionada = -1;

  var uuid = const Uuid();
  String notaAtual = '5';

  Map<String, dynamic> dadosCadastrar = {
    "interesses": {
      "Tag1": jsonEncode(Tag("", 0).TagToSend()),
      "Tag2": jsonEncode(Tag("", 0).TagToSend()),
      "Tag3": jsonEncode(Tag("", 0).TagToSend()),
      "Tag4": jsonEncode(Tag("", 0).TagToSend()),
      "Tag5": jsonEncode(Tag("", 0).TagToSend())
    }
  };

  Future selectFile() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      imagemPessoa = image;
    });
  }

  Future uploadFile(String login) async {
    FirebaseStorage store = FirebaseStorage.instance;
    TaskSnapshot task = await store
        .ref('$login/img')
        .putData(await imagemPessoa!.readAsBytes());
  }

  void SalvarTag() {
    setState(() {
      dadosCadastrar["interesses"]["Tag" + tagSelecionada.toString()] =
          jsonEncode(
              Tag(tagSelecionadaCampo.text, int.parse(campoNotaAtual.text))
                  .TagToSend());
    });
  }

  salvaPessoa() {
    var senhaCript = sha512.convert(utf8.encode(senha.text)).toString();
    var idUsuario = uuid.v1();
    dadosCadastrar["RedesSociais"] = {
      "Facebook": facebookID.text,
      "Instagram": instagramID.text,
      "Twitter": twitterID.text
    };
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    dadosCadastrar['created'] = DateTime.parse(formatter.format(now));
    dadosCadastrar['dataNascimento'] = dataNascimento;
    dadosCadastrar["id"] = idUsuario;
    dadosCadastrar["senha"] = senhaCript;
    dadosCadastrar["login"] = login.text;
    dadosCadastrar["nome"] = nomeC.text;
    dadosCadastrar["sexo"] = sexoSelecionado;
    dadosCadastrar["contatos"] = [];
    for (var element in [1, 2, 3, 4, 5]) {
      if (dadosCadastrar["interesses"]["Tag" + element.toString()] ==
          {"NomeTag": "", "Estrelas": 0}) {
        dadosCadastrar["interesses"]["Tag" + element.toString()] = null;
      }
    }
    uploadFile(login.text);
    FirebaseFirestore.instance
        .collection("users")
        .doc(idUsuario)
        .set(dadosCadastrar);
    Navigator.of(context).pop();
  }

  void setTagSelecionada(int value) {
    setState(() {
      tagSelecionada = value;
      var decodf = json.decode(
          dadosCadastrar["interesses"]["Tag" + tagSelecionada.toString()]);
      campoNotaAtual.text = decodf["Estrelas"].toString();
      tagSelecionadaCampo.text = decodf["NomeTag"];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _valores = ['Homem', 'Mulher', 'Outros'];
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(imagemPessoa == null
                          ? 'https://st4.depositphotos.com/20838724/24940/v/450/depositphotos_249401062-stock-illustration-person-profile-circle-avatar-vector.jpg'
                          : imagemPessoa!.path))),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            ElevatedButton(
                onPressed: () => selectFile(),
                child: const Text("Selecione a imagem")),
            SizedBox(
              width: 400,
              child: TextField(
                controller: nomeC,
                decoration: const InputDecoration(
                    labelText: 'Digite seu nome',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.pending_actions),
                    hintText: 'Informe seu nome'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Data Nascimento',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    onDateSelected: (DateTime value) {
                      setaDataNascimento(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: login,
                    decoration: const InputDecoration(
                        labelText: 'Login',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                        hintText: 'Informe seu login'),
                  ),
                ),
              ],
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
            SizedBox(
              // color: Color.fromRGBO(95, 175, 2, 0.7568627450980392),
              width: 400,
              height: 60,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [1, 2, 3, 4, 5]
                      .map((e) => Ink(
                            decoration: ShapeDecoration(
                              color: dadosCadastrar["interesses"]
                                              ["Tag" + e.toString()]
                                          .toString() ==
                                      jsonEncode(Tag("", 0).TagToSend())
                                          .toString()
                                  ? Colors.grey
                                  : Color.fromRGBO(95, 175, 2, 1.0),
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.star),
                              color: Colors.white,
                              onPressed: () {
                                setTagSelecionada(e);
                                modalTags();
                              },
                            ),
                          ))
                      .toList()),
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
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: twitterID,
                    decoration: const InputDecoration(
                        labelText: 'Twitter ID',
                        border: OutlineInputBorder(),
                        icon: Icon(FontAwesomeIcons.twitter,
                            color: Colors.lightGreenAccent),
                        hintText: 'Twitter ID'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: instagramID,
                    decoration: const InputDecoration(
                        labelText: 'Instagram ID',
                        border: OutlineInputBorder(),
                        icon: Icon(FontAwesomeIcons.instagram,
                            color: Colors.lightGreenAccent),
                        hintText: 'Instagram ID'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: facebookID,
                    decoration: const InputDecoration(
                        labelText: 'Facebook ID',
                        border: OutlineInputBorder(),
                        icon: Icon(FontAwesomeIcons.facebook,
                            color: Colors.lightGreenAccent),
                        hintText: 'Facebook ID'),
                  ),
                ),
              ],
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

  void setaM(String x) {
    setState(() => {sexoSelecionado = x});
  }

  void modalTags() {
    void onChangeTag(String tag) {
      setState(() {
        tagSelecionadaCampo.text = tag;
      });
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: const Color.fromRGBO(255, 255, 255, 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          enabled: false,
                          labelText: 'Selecionado',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.thumb_up),
                        ),
                        controller: tagSelecionadaCampo,
                        onChanged: (String a) => verificaNota(a),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'O quanto eu gosto',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.numbers),
                          // hintText: 'Informe seu nome'
                        ),
                        controller: campoNotaAtual,
                        onChanged: (String a) => verificaNota(a),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: StringsTags.map((e) {
                    return Flexible(
                        flex: 25,
                        child: ElevatedButton(
                            onPressed: () {
                              onChangeTag(e);
                            },
                            child: Text(e),
                            style: ElevatedButton.styleFrom(
                                primary: e == tagSelecionada
                                    ? Colors.lightGreen
                                    : Colors.white54)));
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: ElevatedButton(
                          child: const Text("Salvar"),
                          onPressed: () {
                            SalvarTag();
                            Navigator.of(context).pop();
                          }),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void setaDataNascimento(DateTime data) {
    print(data);
    setState(() {
      dataNascimento = data;
    });
  }

  void verificaNota(String nota) {
    if (int.parse(nota) > 10) {
      campoNotaAtual.text = "10";
    } else if (int.parse(nota) < 0) {
      campoNotaAtual.text = "0";
    } else if (nota == "") {
      campoNotaAtual.text = "0";
    } else {
      campoNotaAtual.text = int.parse(nota).toString();
    }
  }
}
