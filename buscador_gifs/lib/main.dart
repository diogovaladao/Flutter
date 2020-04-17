import 'package:buscadorgifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:buscadorgifs/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    home: GifPage(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}