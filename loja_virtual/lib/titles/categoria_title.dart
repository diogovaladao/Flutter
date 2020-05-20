import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriaTitle extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoriaTitle(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icone"]),
      ),
      title: Text(snapshot.data["titulo"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){

      },
    );
  }
}
