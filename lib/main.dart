import 'dart:convert';

import 'package:flutter/material.dart'
    show AppBar, BuildContext, ButtonStyle, Center, CircularProgressIndicator, Color, Colors, Column, Container, ElevatedButton, FloatingActionButton, Icon, Icons, InputBorder, InputDecoration, Key, MainAxisAlignment, MaterialApp, MaterialPageRoute, MaterialStateProperty, Navigator, OutlineInputBorder, RaisedButton, Scaffold, State, StatefulWidget, StatelessWidget, Text, TextButton, TextEditingController, TextField, Theme, ThemeData, Widget, Wrap, runApp;
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:hello_world/TelaLogin.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world/models/Romance.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const TelaLogin(title: 'Tela de Login'),
    );
  }
}

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _app = Firebase.initializeApp();
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: FutureBuilder(
        future: _app,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            print('Deu erro ${snapshot.error}');
            return Text('Deu erro');
          } else if(snapshot.hasData){
              return const TelaLogin(title: 'Tela de Login');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
      // const TelaLogin(title: 'Tela de Login'),
    );
  }
}
*/
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Romance romance = Romance("", "", "", "");
  TextEditingController nome1 = TextEditingController();
  TextEditingController nome2 = TextEditingController();
  String resultadoMatch = "";

  Future<Romance> darMatch(String p1, String p2) async {
    const Map<String, String>  headers = {
      'Connection': 'keep-alive',
      'sec-ch-ua':
      '" Not A;Brand";v="99", "Chromium";v="99", "Opera GX";v="85"',
      'Pragma': 'no-cache',
      'x-rapidapi-key': '94f454f271mshf275648a95e2a8dp1e6250jsnce28684e324a',
      'sec-ch-ua-mobile': '?0',
      'User-Agent':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.72',
      'x-rapidapi-ua': 'RapidAPI-Playground',
      'x-rapidapi-host': 'love-calculator.p.rapidapi.com',
      'Accept': 'application/json, text/plain, */*',
      'Expires': '0',
      'Cache-Control': 'no-cache',
      'useQueryString': 'true',
      'sec-ch-ua-platform': '"Windows"',
      'Origin': 'https://rapidapi.com',
      'Sec-Fetch-Site': 'same-site',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Dest': 'empty',
      'Referer': 'https://rapidapi.com/',
      'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
      'Accept-Encoding': 'gzip',
    };

    var params = {
      'sname': p1,
      'fname': p2,
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var url = Uri.parse(
        'https://love-calculator.p.rapidapi.com/getPercentage?$query');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    var decode = jsonDecode(res.body);
    print(res.body);
    return Romance(decode["fname"], decode["sname"], decode["percentage"],
        decode["result"]);
  }

  void handleClickDarMatch() async {
    Romance resp = await darMatch(nome1.text, nome2.text);
    setState(() {
      resultadoMatch = resp.result;
      romance.result = resp.result;
      romance.porcentagem = resp.porcentagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: double.parse(romance.porcentagem) / 100,
              center: Text(
                "${romance.porcentagem}%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: Text(
                romance.result,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.pink,
            ),
            Container(
              width: 400,
              child: TextField(
                controller: nome1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    hintText: 'Informe seu nome'),
              ),
            ),
            Container(
              width: 400,
              child: TextField(
                controller: nome2,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    hintText: 'Informe o nome da outra pessoa'),
              ),
            ),

            // Text(romance.result),
            Container(
              width: 400,
              child: ElevatedButton(
                onPressed: handleClickDarMatch,
                child: Wrap(children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  Text('Esse é o seu amor?')
                ]),
              ),
            ),
            ElevatedButton(
              child: Text('Abrir rota(tela)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SegundaRota()),
                );
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SegundaRota extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Rota (tela)"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Retornar !'),
              ),
              ElevatedButton(
                child: Text('Terceira rota(tela)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TerceiraRota()),
                  );
                },
              ),
            ],
          )),
    );
  }
}

class TerceiraRota extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terceira (tela)"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Retornar !'),
              ),
            ],
          )),
    );
  }
}
