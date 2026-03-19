import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitrabai/model/service.dart';

/**************/
final String nomeColecao = "servicos";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Servico>(
        fromFirestore: (snapshots, _) => Servico.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

Future<void> _aceitarServico(Map<String, dynamic> data, int id) async {
  // Obter o serviço correspondente do Firebase usando os dados fornecidos
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(nomeColecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    print(doc.data());
    if (data['nome'].compareTo(doc['nome']) == 0) {
      db.doc(doc.id).set(Servico(
          int.parse(data['id']),
          data['nome'],
          double.parse(data['valor']),
          data['descricao'],
          int.parse(data['idCriaServ']),
          id,
          data['tipoServico'],
          "false"));
    }
  }
}

final String filtro = 'true';

class Feed extends StatefulWidget {
  Feed(this.id);
  final int id;

  @override
  _FeedState createState() => _FeedState(id);
}

class _FeedState extends State<Feed> {
  /*****************/
  final Stream<QuerySnapshot>? _servicosStream =
      FirebaseFirestore.instance.collection(nomeColecao).snapshots();

  _FeedState(this.id);
  final int id;

  @override
  Widget build(BuildContext context) {
    //o widget scaffold é a estrutura que iremos traballha nas telas de nossos apps
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed', style:
        TextStyle(fontSize: 25, color: Colors.blue),),
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Padding(padding: EdgeInsets.all(10)),
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
                      .map((DocumentSnapshot document) {
                        //print("Saida: ${document.data()!}");
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        if (filtro.compareTo(data['disponivel'].toString()) ==
                            0) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(50, 50),
                                alignment: Alignment.centerLeft,
                                primary: Colors.white,
                                padding: EdgeInsets.all(25),
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Colors.blue,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                                  /*Text(
                                    "Disponibilidade:",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  Text("${data["disponivel"]}", style: TextStyle(fontSize: 18),),*/
                                ])),
                            onPressed: () => cliqueServico(context, id, data),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      })
                      .toList()
                      .cast(),
                );
              },
            ),
          )
        ],
      )),
    );
  }

  cliqueServico(BuildContext context, int id, Map<String, dynamic> data) {
    Widget voltarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text("Voltar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget aceitarButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
      child: Text(
        "Aceitar serviço",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => {
        _aceitarServico(data, id),
        Navigator.of(context).pop(),
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Serviço: ${data['nome']}'),
      actions: [
        voltarButton,
        aceitarButton,
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
