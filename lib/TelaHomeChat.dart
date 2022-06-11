import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class TelaHomeChat extends StatefulWidget {
  const TelaHomeChat({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TelaHomeChat> createState() => _TelaHomeChatState();
}

class _TelaHomeChatState extends State<TelaHomeChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Conversas')),
    );
  }
}
