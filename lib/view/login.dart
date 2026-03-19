import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitrabai/model/user.dart';
import 'package:maitrabai/view/cadastro.dart';
import 'package:maitrabai/view/splash2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String nomeColecao = "usuarios";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

Future<bool> verificatTodosDocumentsDeColecao(
    String colecao, String user, String pass) async {
  bool retorno = false;
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    print(doc['nomeUsuario'] + "," + doc['senha']);
    if ((user == doc['nomeUsuario']) && (pass == doc['senha'])) {
      retorno = true;
    }
  }
  return retorno;
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.blue, fontSize: 25)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ListView(
            children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                TextField(
                  controller: _tecNomeUsuario,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      maxHeight: 70,
                      maxWidth: 350,
                    ),
                    labelText: "Usuário:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecSenha,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      constraints: BoxConstraints(
                        maxHeight: 70,
                        maxWidth: 350,
                      ),
                      labelText: "Senha:"),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _logar,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(Size(40, 40))),
                      child: Text(
                        "Efetuar login",
                        style: TextStyle(color: Colors.blue, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cadastro()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(Size(40, 40))),
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.blue, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ])
        ]),
      ),
    );
  }

  TextEditingController _tecNomeUsuario = TextEditingController();
  TextEditingController _tecSenha = TextEditingController();

  _logar() async {
    Future<bool> verifica = verificatTodosDocumentsDeColecao(
        nomeColecao, _tecNomeUsuario.text, _tecSenha.text);
    String usuarioLogado = _tecNomeUsuario.text;
    if (await verifica) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash2(usuarioLogado)));
    } else {
      print("Falha no login");
        alertDialog(context);

    }
  }

  alertDialog(BuildContext context) {
    Widget voltarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all(Colors.black),),
      child: Text("Voltar", style: TextStyle(color: Colors.red),),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _tecNomeUsuario.text = "";
          _tecSenha.text = "";
        });
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Falha no login'),
      content: Text("Usuário ou senha incorretos"),
      actions: [
        voltarButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
