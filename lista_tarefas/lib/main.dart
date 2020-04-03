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
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: (){},
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index){
                    return CheckboxListTile(
                      title: Text(_toDoList[index]["title"]),
                      value: _toDoList[index]["ok"],
                      secondary: CircleAvatar(
                        child: Icon(_toDoList[index]["ok"]?
                        Icons.check : Icons.error),
                      ),
                    );
                }),
          )
        ],
      ),
    );
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