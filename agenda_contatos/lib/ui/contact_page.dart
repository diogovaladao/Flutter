import 'dart:html';

import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {

  final Contato contato;

  ContactPage({this.contato});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contato _contatoEditado;
  @override
  void initState() {
    super.initState();
    if(widget.contato == null){
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_contatoEditado.nome ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }

}
