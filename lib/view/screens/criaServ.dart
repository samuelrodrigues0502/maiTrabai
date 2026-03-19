import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitrabai/model/service.dart';
import 'package:maitrabai/model/user.dart';
import 'package:maitrabai/view/principal.dart';

final String nomeColecao = "servicos";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Servico>(
        fromFirestore: (snapshots, _) => Servico.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

final String nomeColecao2 = "usuarios";
final db2 = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

Future<int> getQtdDocs(String colecao) async {
  int size = 0;
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    size++;
  }
  return size;
}

Future<int> size = getQtdDocs(nomeColecao);

class CriaServ extends StatefulWidget {
  CriaServ(this.id);
  final int id;

  @override
  _CriaServState createState() => _CriaServState(id);
}

class _CriaServState extends State<CriaServ> {
  _CriaServState(this.id);
  final int id;

  Widget build(BuildContext context) {
    //o widget scaffold é a estrutura que iremos traballha nas telas de nossos apps
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar serviço',
          style: TextStyle(color: Colors.blue, fontSize: 25),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ListView(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextField(
                  controller: _tecTitulo,
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
                    labelText: "Título do serviço:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecDescricao,
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
                    labelText: "Descrição:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecValor,
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
                    labelText: "Valor pelo serviço:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecTipoServico,
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
                    labelText: "Tipo de serviço:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                ElevatedButton(
                  onPressed: () => _cadastro(id),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      minimumSize: MaterialStateProperty.all(Size(40, 40))),
                  child: Text(
                    "Criar serviço",
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                ),
              ])
        ]),
      ),
    );
  }

  TextEditingController _tecTitulo = TextEditingController();
  TextEditingController _tecDescricao = TextEditingController();
  TextEditingController _tecValor = TextEditingController();
  TextEditingController _tecTipoServico = TextEditingController();

  _cadastro(int id) async {
    String titulo = _tecTitulo.text;
    String descricao = _tecDescricao.text;
    String valor = _tecValor.text;
    String tipoServico = _tecTipoServico.text;
    Servico novoServico;

    if (double.tryParse(valor) != null) {
      if (await size == 0) {
        novoServico = Servico(1, titulo, double.parse(valor), descricao,
            await id, 0, tipoServico, "true");
      } else {
        novoServico = Servico(await size + 1, titulo, double.parse(valor),
            descricao, await id, 0, tipoServico, "true");
      }
      FirebaseFirestore.instance
          .collection(nomeColecao)
          .add(novoServico.toJson());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Principal(id)));
    } else {
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
          _tecValor.text = "";
        });
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Falha na criação do serviço'),
      content: Text("Valor inserido inválido"),
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
