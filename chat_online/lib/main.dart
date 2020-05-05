import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(MyApp());
}

final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<FirebaseUser> _usuarioLogado() async {
  GoogleSignInAccount usuarioLogado = googleSignIn.currentUser;

  if (usuarioLogado == null) {
    usuarioLogado = await googleSignIn.signInSilently();
  }
  if (usuarioLogado == null) {
    usuarioLogado = await googleSignIn.signIn();
  }
  if (usuarioLogado == null) {
    usuarioLogado = await googleSignIn.signIn();
  }

  //autenticando no firebase
  if (await auth.currentUser() == null) {
    final GoogleSignInAccount usuarioGoogle = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await usuarioGoogle.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}

_handleSubmited(String text) async {
  await _usuarioLogado();
  _enviarMensagem(text: text);
}

void _enviarMensagem({String text, String imgUrl}) {
  Firestore.instance.collection("messages").add({
    "text": text,
    "imgUrl": imgUrl,
    "senderMame": googleSignIn.currentUser.displayName,
    "senderUrlfoto": googleSignIn.currentUser.photoUrl
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("messages").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            List listaReversa = snapshot.data.documents.reversed.toList();
                            return ChatMessage(
                                listaReversa[index].data);
                          },
                        );
                    }
                  }),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final _textController = TextEditingController();

  void _resetar() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera),
                      onPressed: () async{
                        await _usuarioLogado();
                        File arquivoImagem = await ImagePicker.pickImage(source: ImageSource.camera);
                        if(arquivoImagem == null){
                          return;
                        }
                        StorageUploadTask task = FirebaseStorage.instance.ref().
                        child(googleSignIn.currentUser.id.toString() +
                            DateTime.now().millisecondsSinceEpoch.toString()).putFile(arquivoImagem);
                        StorageTaskSnapshot taskSnapshot = await task.onComplete;
                        String url = await taskSnapshot.ref.getDownloadURL();
                        _enviarMensagem(imgUrl: url);
                      }
                  ),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                /*onSubmitted: (text){
                  _handleSubmited(text);
                },*/
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposing
                            ? () {
                                _handleSubmited(_textController.text);
                                _resetar();
                              }
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () {
                                _handleSubmited(_textController.text);
                                _resetar();
                              }
                            : null,
                      ))
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderUrlfoto"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["senderMame"],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data["imgUrl"] != null
                      ? Image.network(data["imgUrl"], width: 250.0)
                      : Text(data["text"]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
