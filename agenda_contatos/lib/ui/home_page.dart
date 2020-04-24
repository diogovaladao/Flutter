import 'dart:io';

import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:agendacontatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatctHelper helper = ContatctHelper();
  List<Contato> listaContatos = List();

  @override
  void initState() {
    super.initState();
    _getAllContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: listaContatos.length,
        itemBuilder: (context, index) {
          return _cartaoContato(context, index);
        },
      ),
    );
  }

  Widget _cartaoContato(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: listaContatos[index].img != null
                            ? FileImage(File(listaContatos[index].img))
                            : AssetImage("/images/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listaContatos[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      listaContatos[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      listaContatos[index].fone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactPage(contato: listaContatos[index]);
      },
    );
  }

  void _showContactPage({Contato contato}) async {
    final recebeContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contato: contato,
                )));
    if (recebeContato != null) {
      if (contato != null) {
        await helper.updateContato(recebeContato);
      } else {
        await helper.salvarContato(recebeContato);
      }
      _getAllContatos();
    }
  }

  void _getAllContatos() {
    helper.getAllContatos().then((list) {
      setState(() {
        listaContatos = list;
      });
    });
  }
}
