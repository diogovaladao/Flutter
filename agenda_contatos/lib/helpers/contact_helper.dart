import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColuna = "idColuna";
final String nomeColuna = "nomeColuna";
final String emailColuna = "emailColuna";
final String foneColuna = "foneColuna";
final String imgColuna = "imgColuna";

class ContatctHelper {
  static final ContatctHelper _instance = ContatctHelper.internal();

  factory ContatctHelper() => _instance;

  ContatctHelper.internal();

  Database _db;
 Future<Database> get db async{
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contatos.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerversion) async{
       await db.execute(
         "CREATE TABLE $contactTable($idColuna INTEGER PRIMARY KEY, $nomeColuna TEXT, $emailColuna, TEXT, "
             "$foneColuna TEXT, $imgColuna TEXT)"
       );
    });
  }
}

class Contact {
  int id;
  String nome;
  String email;
  String fone;
  String img;

  Contact.fromMap(Map map){
    id = map[idColuna];
    nome = map[nomeColuna];
    email = map[emailColuna];
    fone = map[foneColuna];
    img = map[imgColuna];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColuna: nome,
      emailColuna: email,
      foneColuna: fone,
      imgColuna: img
    };
    if(id != null){
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $nome, email: $email, fone: $fone, img: $img)";
  }
}