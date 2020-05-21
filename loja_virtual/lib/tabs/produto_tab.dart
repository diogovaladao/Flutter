import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/titles/categoria_title.dart';

class ProdutoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          var divideTitles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((doc) {
                    return CategoriaTitle(doc);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(
            children: divideTitles,
          );
        }
      },
    );
  }
}
