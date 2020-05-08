import 'package:flutter/material.dart';
import 'package:lojavirtual/tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {
  final _controlePagina = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controlePagina,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        HomeTab()
      ],
    );
  }
}
