import 'dart:io';

import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contato contato;

  ContactPage({this.contato});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _foneController = TextEditingController();
  final _focoNome = FocusNode();

  bool _editarUsuario = false;
  Contato _contatoEditado;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap());
      _nomeController.text = _contatoEditado.nome;
      _emailController.text = _contatoEditado.email;
      _foneController.text = _contatoEditado.fone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // WillPopScope: widget para controlar a saída de uma tela
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contatoEditado.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoEditado.nome != null &&
                _contatoEditado.nome.isNotEmpty) {
              Navigator.pop(context, _contatoEditado);
            } else {
              FocusScope.of(context).requestFocus(_focoNome);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _contatoEditado.img != null
                              ? FileImage(File(_contatoEditado.img))
                              : AssetImage("/images/person.png"))),
                ),
              ),
              //campo para digitação
              TextField(
                controller: _nomeController,
                focusNode: _focoNome,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (titulo) {
                  _editarUsuario = true;
                  setState(() {
                    _contatoEditado.nome = titulo;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (titulo) {
                  _editarUsuario = true;
                  _contatoEditado.email = titulo;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _foneController,
                decoration: InputDecoration(labelText: "Fone"),
                onChanged: (titulo) {
                  _editarUsuario = true;
                  _contatoEditado.fone = titulo;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  // controle de saída da tela de cadastro
  Future<bool> _requestPop() {
    if (_editarUsuario) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterções?"),
              content: Text("Ao sair as alterações serão perdidas!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
