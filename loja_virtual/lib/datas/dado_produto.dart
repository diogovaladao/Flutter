import 'package:cloud_firestore/cloud_firestore.dart';

class DadoProduto {

  String categoria;
  String id;
  String titulo;
  String descricao;
  double preco;
  List imagens;
  List tamanhos;

  DadoProduto.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    titulo = snapshot.data["titulo"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"];
    imagens = snapshot.data["image"];
    tamanhos =- snapshot.data["tamanho"];
  }
}