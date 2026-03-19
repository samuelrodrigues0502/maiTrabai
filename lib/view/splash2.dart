import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitrabai/model/user.dart';
import 'package:maitrabai/view/principal.dart';
import 'package:flutter/material.dart';

final String nomeColecao2 = "usuarios";
final db2 = FirebaseFirestore.instance
    .collection(nomeColecao2)
    .withConverter<Usuario>(
    fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
    toFirestore: (objeto, _) => objeto.toJson());

Future<int> getIdUsuario(String colecao, String usuarioLogado) async {
  final completer = Completer<int>();
  QuerySnapshot colec =
  await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    if (usuarioLogado.compareTo(doc['nomeUsuario']) == 0) {
      completer.complete(int.parse(doc['id']));
      break;
    }
  }
  return completer.future;
}

class Splash2 extends StatefulWidget {
  Splash2(this.usuarioLogado);
  final String usuarioLogado;

  @override
  _Splash2State createState() => _Splash2State(usuarioLogado);

}

class _Splash2State extends State<Splash2> {
  _Splash2State(this.usuarioLogado);
  final String usuarioLogado;
  int? id;

  @override
  void initState() {
    super.initState();
    getIdUsuario(nomeColecao2, usuarioLogado).then((value) {
      setState(() {
        id = value;
      });
    });
    //espera 3 segundos do splash
    Future.delayed(Duration(seconds: 4)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Principal(id!)));
    });
  }


  //constroe a tela do splash
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/MaiTrabai.jpg'),
            height: 250,
            width: 250,
          ),
          CircularProgressIndicator(color: Colors.blue,)],
      ),
    );
  }
}