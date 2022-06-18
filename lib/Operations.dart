export 'Operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Operations {
  static CollectionReference<Map<String, dynamic>> getData (String tabela)  {
    return FirebaseFirestore.instance.collection(tabela);
  }

  static void abrirUrl(host, path) async {
    final Uri toLaunch = Uri(scheme: 'https', host: host, path: path);
    if (!await launchUrl(toLaunch)) throw 'Could not launch $host';
  }

}