import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitrabai/model/service.dart';
import 'package:maitrabai/view/principal.dart';

final String nomeColecao = "servicos";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Servico>(
    fromFirestore: (snapshots, _) => Servico.fromJson(snapshots.data()!),
    toFirestore: (objeto, _) => objeto.toJson());

Future<void> _excluirServico(Map<String, dynamic> data) async {
  // Obter o serviço correspondente do Firebase usando os dados fornecidos
  QuerySnapshot colec =
  await FirebaseFirestore.instance.collection(nomeColecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    print(doc.data());
    if (data['nome'].compareTo(doc['nome']) == 0) {
      db.doc(doc.id).delete();
    }
  }
}

Future<void> _desistirServico(Map<String, dynamic> data) async {
  // Obter o serviço correspondente do Firebase usando os dados fornecidos
  QuerySnapshot colec =
  await FirebaseFirestore.instance.collection(nomeColecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    if (data['nome'].compareTo(doc['nome']) == 0) {
      db.doc(doc.id).set(Servico(
          int.parse(data['id']),
          data['nome'],
          double.parse(data['valor']),
          data['descricao'],
          int.parse(data['idCriaServ']),
          0,
          data['tipoServico'],
          "true"));
    }
  }
}

class ListaServicos extends StatefulWidget{
  ListaServicos(this.id);
  final int id;

  @override
  _ListaServicosState createState() => _ListaServicosState(id);
}

class _ListaServicosState extends State<ListaServicos>{
  _ListaServicosState(this.id);
  final int id;
  //final String usuarioLogado;

  final Stream<QuerySnapshot>? _servicosStream =
  FirebaseFirestore.instance.collection(nomeColecao).snapshots();

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de serviços', style: TextStyle(color: Colors.blue, fontSize: 25)),
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Principal(id)));
              }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Criados pelo usuário:", style: TextStyle(fontSize: 20),),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _servicosStream!,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          padding: EdgeInsets.all(10),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document){
                            print(
                                "Saida serviços logado: ${document.data()!}");
                            Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                            //print("id: $id, idCriaServ: ${data['idCriaServ']}");
                            if (id.toString().compareTo(data['idCriaServ']) == 0){
                              return ElevatedButton(
                                  onPressed: () => cliqueServicoCriado(context, data),
                                  style: ElevatedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      primary: Colors.white,
                                      padding: EdgeInsets.all(25),
                                      side: const BorderSide(
                                        width: 2.0,
                                        color: Colors.blue,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Título do serviço:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["nome"]}",style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(10)),
                                            Text(
                                              "Descrição:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["descricao"]}", style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Valor a ser pago:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("R\$ ${data["valor"]}", style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Tipo de serviço:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["tipoServico"]}", style: TextStyle(fontSize: 18),),
                                            /*Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Disponibilidade:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text("${data["disponivel"]}"),*/
                                          ])));
                            } else {
                              return SizedBox.shrink();
                            }
                          })
                              .toList()
                              .cast(),
                        );
                      })),
              Padding(padding: EdgeInsets.all(10)),
              Text("Adquiridos pelo usuário:", style: TextStyle(fontSize: 20)),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _servicosStream!,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          padding: EdgeInsets.all(10),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document){
                            print(
                                "Saida serviços logado: ${document.data()!}");
                            Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                            //print("id: $id, idCriaServ: ${data['idCriaServ']}");
                            if (id.toString().compareTo(data['idPegaServ']) == 0){
                              return ElevatedButton(
                                  onPressed: () => cliqueServicoPego(context, id, data),
                                  style: ElevatedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      primary: Colors.white,
                                      padding: EdgeInsets.all(25),
                                      side: const BorderSide(
                                        width: 2.0,
                                        color: Colors.blue,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                  child: Card(
                                      child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Título do serviço:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["nome"]}", style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(10)),
                                            Text(
                                              "Descrição:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["descricao"]}", style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Valor a ser pago:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("R\$ ${data["valor"]}", style: TextStyle(fontSize: 18),),
                                            Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Tipo de serviço:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["tipoServico"]}", style: TextStyle(fontSize: 18),),
                                            /*Padding(padding: EdgeInsets.all(5)),
                                            Text(
                                              "Disponibilidade:",
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text("${data["disponivel"]}", style: TextStyle(fontSize: 18),),*/
                                          ])));
                            } else {
                              return SizedBox.shrink();
                            }
                          })
                              .toList()
                              .cast(),
                        );
                      })),

      ]))
    );
  }

  cliqueServicoCriado(BuildContext context, Map<String, dynamic> data) {
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
        "Excluir serviço",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => {
        _excluirServico(data),
        Navigator.of(context).pop(),
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Serviço: ${data['nome']}'),
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

  cliqueServicoPego(BuildContext context, int id, Map<String, dynamic> data) {
    Widget voltarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text("Voltar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget desistirButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      child: Text(
        "Desistir",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => {
        _desistirServico(data),
        Navigator.of(context).pop(),
      },
    );

    Widget terminarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text(
        "Terminar",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => {
        _excluirServico(data),
        Navigator.of(context).pop(),
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Serviço: ${data['nome']}'),
      actions: [
        voltarButton,
        terminarButton,
        desistirButton,
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