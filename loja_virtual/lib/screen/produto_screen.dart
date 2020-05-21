import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/dado_produto.dart';
import 'package:lojavirtual/titles/produto_title.dart';

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
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("produtos").document(snapshot.documentID)
              .collection("itens").getDocuments(),
            builder: (context, snapshot){
             if(!snapshot.hasData)
               return Center(child: CircularProgressIndicator());
             else
               return TabBarView(
                   physics: NeverScrollableScrollPhysics(),
                   children: [
                     GridView.builder(
                       padding: EdgeInsets.all(4.0),
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 2,
                         mainAxisSpacing: 4.0,
                         crossAxisSpacing: 4.0,
                         childAspectRatio: 0.65,
                       ),
                       itemCount: snapshot.data.documents.length,
                       itemBuilder: (context, index){
                         return ProdutoTitle("grid", DadoProduto.fromDocument(snapshot.data.documents[index]));
                       }
                     ),
                     ListView.builder(
                       padding: EdgeInsets.all(4.0),
                       itemCount: snapshot.data.documents.length,
                       itemBuilder:(context, index){
                         return ProdutoTitle("list", DadoProduto.fromDocument(snapshot.data.documents[index]));
                       }
                     )
                   ]
               );
            }
          )
        ),
    );
  }
}
