import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutoScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ProdutoScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["titulo"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.list))
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
              children: [
                Container(color: Colors.red),
                Container(color: Colors.green)
              ]
          ),
        ),
    );
  }
}
