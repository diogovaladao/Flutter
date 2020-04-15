import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _pesquisa;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response resposta;
    if (_pesquisa == null)
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=PPrbzDlg8lYEg01cKNQ36eZcQuyi0QbM&limit=20&rating=G");
    else
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=PPrbzDlg8lYEg01cKNQ36eZcQuyi0QbM&q=$_pesquisa&limit=20&offset=$_offset&rating=G&lang=pt");

    return json.decode(resposta.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _creatGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _creatGifTable(BuildContext context, AsyncSnapshot snapshot) {

  }
}