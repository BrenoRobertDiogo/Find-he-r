export 'TelaCadastro.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_her/models/Tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final nomeC = TextEditingController();
  final senha = TextEditingController();
  final tagSelecionadaCampo = TextEditingController();
  String sexoSelecionado = "Homem";
  final campoNotaAtual = TextEditingController(text: "5");
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

  void SalvarTag(){
    setState(() {
      print(tagSelecionadaCampo.text + campoNotaAtual.text);
      print(dadosCadastrar["interesses"]["Tag"+tagSelecionada.toString()]);
      dadosCadastrar["interesses"]["Tag"+tagSelecionada.toString()] = jsonEncode(Tag(tagSelecionadaCampo.text, int.parse(campoNotaAtual.text)).TagToSend());

    });
    print(tagSelecionada);
    print(dadosCadastrar["interesses"]["Tag"+tagSelecionada.toString()]);

  }

  void salvaPessoa() {

    var senhaCript = sha512.convert(utf8.encode(senha.text)).toString();
    var idUsuario = uuid.v1();
    dadosCadastrar["id"]    = idUsuario;
    dadosCadastrar["senha"] = senhaCript;
    dadosCadastrar["login"] = login.text;
    dadosCadastrar["nome"]  = nomeC.text;
    dadosCadastrar["sexo"]  = sexoSelecionado;
    for (var element in [1,2,3,4,5]) {
      if(dadosCadastrar["interesses"]["Tag"+element.toString()] == "{\"NomeTag\":\"\",\"Estrelas\":0}"){
        dadosCadastrar["interesses"]["Tag"+element.toString()] = null;
      }
    }
    FirebaseFirestore.instance.collection("users").doc(idUsuario).set(dadosCadastrar);

    // Other jeito
    // DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    // DatabaseReference novoUsuario = ref.push();
    // novoUsuario
    //     .set({"id": idUsuario, "login": login.text, "senha": senhaCript});
  }

  void setTagSelecionada(int value){
    setState(() {
      tagSelecionada = value;
      print(dadosCadastrar["interesses"]["Tag"+tagSelecionada.toString()]);
      var decodf = json.decode(dadosCadastrar["interesses"]["Tag"+tagSelecionada.toString()]);
      notaAtual = decodf["QtdEstrelas"];
      campoNotaAtual.text = decodf["QtdEstrelas"];
      tagSelecionadaCampo.text = decodf["Nome"];


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
                children: [1,2,3,4,5].map((e) => Ink(
                  decoration: const ShapeDecoration(
                    color: Color.fromRGBO(95, 175, 2, 1.0),
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
                )).toList()
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
            ),/*
            Container(
              height: 200,
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Modal BottomSheet'),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () => modalTags(),
                    )
                  ],
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  void setaM(String x) {
    print('entrou aqui');
    setState(() => {sexoSelecionado = x});
  }

  void modalTags() {
    void onChangeTag(String tag) {
      print(tag);
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

                        onPressed: () => onChangeTag(e),
                        child: Text(e),
                        style: ElevatedButton.styleFrom(
                            primary: e == tagSelecionada
                                ? Colors.lightGreen
                                : Colors.white54)))
                      ;
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child:  ElevatedButton(
                          child: Text("Salvar"),
                          onPressed: () => SalvarTag()),

                    ),
                  ),
                )
                ,
              ],
            ),
          );
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
