//import 'dart:html';

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

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contatos.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerversion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColuna INTEGER PRIMARY KEY, $nomeColuna TEXT, $emailColuna, TEXT, "
          "$foneColuna TEXT, $imgColuna TEXT)");
    });
  }
  //salvar contato no banco
  Future<Contato>salvarContato(Contato contato) async {
    Database dbContato = await db;
    contato.id = await dbContato.insert(contactTable, contato.toMap());
    return contato;
  }

  //buscar contato
  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(contactTable,
    columns: [idColuna, nomeColuna, emailColuna, foneColuna, imgColuna],
    where: "$idColuna = ?", whereArgs: [id]);
    if(maps.length > 0){
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //deletar contato
  Future<int>deletaContato(int id) async {
    Database dbContato = await db;
    return await dbContato.delete(contactTable,
        where: "$idColuna = ?", whereArgs: [id]);
  }

  //atualizar contato
  Future<int>updateContato(Contato contato) async {
    Database dbContato = await db;
    return await dbContato.update(contactTable,
        contato.toMap(), where: "$idColuna = ?", whereArgs: [contato.id]);
  }

  //obter todos os contatos
  Future<List> getAllContatos() async {
    Database dbContato = await db;
    List listMap = await dbContato.rawQuery("SELECT * FROM $contactTable");
    List<Contato> listaContato  = List();
    for(Map m in listMap){
      listaContato.add(Contato.fromMap(m));
    }
    return listaContato;
  }

  //retorna a quantidade de elementos na tabela
  Future<int> getNumber() async{
    Database dbContato = await db;
    return Sqflite.firstIntValue(await dbContato.rawQuery("SELECT COUNT (* FROM $contactTable)"));
  }

  //fechar banco de dados
  Future close() async {
    Database dbContato = await db;
    dbContato.close();
  }

}

class Contato {
  int id;
  String nome;
  String email;
  String fone;
  String img;

  Contato();

  //pegar contato de um mapa e passar para objeto contato
  Contato.fromMap(Map map) {
    id = map[idColuna];
    nome = map[nomeColuna];
    email = map[emailColuna];
    fone = map[foneColuna];
    img = map[imgColuna];
  }

  //pegar objeto contato e transformar em um mapa
  Map toMap() {
    Map<String, dynamic> map = {
      nomeColuna: nome,
      emailColuna: email,
      foneColuna: fone,
      imgColuna: img
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $nome, email: $email, fone: $fone, img: $img)";
  }
}
