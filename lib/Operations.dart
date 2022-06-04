export 'Operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Operations {
  static CollectionReference<Map<String, dynamic>> getData (String tabela)  {
    return FirebaseFirestore.instance.collection(tabela);
  }



}