import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _todoList = [];

  void _addToDo(){
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = _toDoController.text;
        _toDoController.text = "";
        newToDo["ok"] = false;
        _todoList.add(newToDo);
      });
  }

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
                    controller: _toDoController,
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
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: (context, index){
                  return CheckboxListTile(
                    title: Text(_todoList[index]["title"]),
                    value: _todoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(_todoList[index]["ok"]?
                      Icons.check: Icons.error),
                    ),
                    onChanged: (c){
                      setState(() {
                        _todoList[index]["ok"] = c;
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  // pegar arquivo
  Future<File> _getFile() async {
    final directorio = await getApplicationDocumentsDirectory();
    return File("${directorio.path}/data.json");
  }

  //salvar arquivo
  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final arquivo = await _getFile();
    return arquivo.writeAsString(data);
  }

  //ler arquivo
  Future<String> _readData() async{
    try{
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch(e){
      return null;
    }
  }
}
// isso foi um teste