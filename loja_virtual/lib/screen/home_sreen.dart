import 'package:flutter/material.dart';
import 'package:lojavirtual/tabs/home_tab.dart';
import 'package:lojavirtual/tabs/produto_tab.dart';
import 'package:lojavirtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _controlePagina = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controlePagina,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_controlePagina),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_controlePagina),
          body: ProdutoTab(),
        ),
        Container(color: Colors.green),
        Container(color: Colors.blue)
      ],
    );
  }
}
