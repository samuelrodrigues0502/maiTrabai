import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitrabai/model/service.dart';
import 'package:maitrabai/model/user.dart';
import 'package:maitrabai/view/login.dart';
import 'package:maitrabai/view/screens/listaServicos.dart';

final String nomeColecao = "servicos";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Servico>(
    fromFirestore: (snapshots, _) => Servico.fromJson(snapshots.data()!),
    toFirestore: (objeto, _) => objeto.toJson());

final String nomeColecao2 = "usuarios";
final db2 = FirebaseFirestore.instance
    .collection(nomeColecao2)
    .withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

Future<Usuario> getUsuarioLogado(String colecao, int id) async {
  Usuario user = Usuario.vazio();
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    if (id.compareTo(int.parse(doc['id'])) == 0) {
      user = Usuario(
          int.parse(doc['id']),
          doc['nomeUsuario'],
          doc['nomeReal'],
          doc['senha'],
          doc['senha'],
          doc['dataNasc'],
          int.parse(doc['qtdLike']));
      break;
    }
  }
  return user;
}

Future<void> _excluirUsuario(Usuario user) async {
  // Obter o serviço correspondente do Firebase usando os dados fornecidos
  QuerySnapshot colec =
  await FirebaseFirestore.instance.collection(nomeColecao2).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    if (user.nomeUsuario.compareTo(doc['nomeUsuario']) == 0) {
      db2.doc(doc.id).delete();
    }
  }
  QuerySnapshot colec2 =
  await FirebaseFirestore.instance.collection(nomeColecao).get();
  final docsSnap2 = await colec2.docs;
  for (final doc in docsSnap2) {
    if (user.id.compareTo(int.parse(doc['idCriaServ'])) == 0) {
      db.doc(doc.id).delete();
    }
    if (user.id.compareTo(int.parse(doc['idPegaServ'])) == 0) {
      db.doc(doc.id).set(Servico(
          int.parse(doc['id']),
          doc['nome'],
          double.parse(doc['valor']),
          doc['descricao'],
          int.parse(doc['idCriaServ']),
          0,
          doc['tipoServico'],
          "true"));
    }
  }
}

class Perfil extends StatefulWidget {
  Perfil(this.id);
  final int id;

  @override
  _PerfilState createState() => _PerfilState(id);
}

class _PerfilState extends State<Perfil> {
  _PerfilState(this.id);
  final int id;

  @override
  Widget build(BuildContext context) {
    Future<Usuario> usuario = getUsuarioLogado(nomeColecao2, id);
    //o widget scaffold é a estrutura que iremos traballha nas telas de nossos apps
    return FutureBuilder<Usuario>(
      future: usuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Aguardando o resultado
          return CircularProgressIndicator(); // ou qualquer outro widget de carregamento
        } else if (snapshot.hasError) {
          // Ocorreu um erro ao obter o resultado
          return Text('Erro ao carregar usuário');
        } else {
          // Resultado obtido com sucesso
          final usuario = snapshot.data;

          if (usuario == null) {
            return Text(
                'Usuário não encontrado'); // ou qualquer outro widget adequado
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil', style: TextStyle(color: Colors.blue, fontSize: 25),),
              backgroundColor: Colors.black,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: [
                        Card(
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(1)),
                          ),
                          shadowColor: Colors.blue,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Informações do perfil:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Padding(padding: EdgeInsets.all(10)),
                              Text("ID: ${usuario.id}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("Username: ${usuario.nomeUsuario}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("Nome: ${usuario.nomeReal}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("Cpf: ${usuario.cpf}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("Data de nascimento: ${usuario.dataNasc}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(50, 50)),
                          ),
                          onPressed: () => _listServicos(),
                          child: Text('Listar serviços acoplados ao usuário', style: TextStyle(fontSize: 20)),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(50, 50)),
                          ),
                          onPressed: () => cliqueExcluir(context, usuario),
                          child: Text('Excluir conta', style: TextStyle(fontSize: 20)),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(50, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => Login()));},
                          child: Text('Sair', style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  _listServicos() async {
    if (id != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListaServicos(id)));
    }
  }

  _excluiConta(Usuario user) async {
    _excluirUsuario(user);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));

  }

  cliqueExcluir(BuildContext context, Usuario user) {
    Widget voltarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text("Voltar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget excluirButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text(
        "Excluir Conta",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => {
        _excluiConta(user),
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Realmente deseja excluir a conta?'),
      actions: [
        voltarButton,
        excluirButton,
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
