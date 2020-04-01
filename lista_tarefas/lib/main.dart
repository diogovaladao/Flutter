import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<File> _getFile() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/data.json");
  }

  Future<File> _saveData() async {
    String dado = json.encode(_toDoList);
    final arquivo = await _getFile();
    return arquivo.writeAsString(dado);
  }

  Future<String> _readDado() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e){
      return null;
    }
  }

}