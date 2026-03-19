import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:maitrabai/model/user.dart';
import 'package:maitrabai/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String nomeColecao = "usuarios";
final db = FirebaseFirestore.instance
    .collection(nomeColecao)
    .withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (objeto, _) => objeto.toJson());

Future<bool> verificaExisteUser(String colecao, String usuario) async {
  bool retorno = false;
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    print(doc.data());
    if (usuario.compareTo(doc['nomeUsuario']) == 0) {
      retorno = true;
    }
  }
  return retorno;
}

Future<int> getQtdDocs(String colecao) async {
  int size = 0;
  QuerySnapshot colec =
      await FirebaseFirestore.instance.collection(colecao).get();
  final docsSnap = await colec.docs;
  for (final doc in docsSnap) {
    if(int.parse(doc['id']) > size) {
      size = int.parse(doc['id']);
    }
  }
  return size;
}

class Cadastro extends StatefulWidget {

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de novo usuário", style: TextStyle(color: Colors.blue, fontSize: 25)),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }),
      ),
      body: Center(
        child: ListView(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
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
                    labelText: "Digite seu usuário:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecNomeReal,
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
                    labelText: "Digite seu nome:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                DateTimePicker(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  controller: _tecData,
                  type: DateTimePickerType.date,
                  dateMask: 'dd/MM/yyyy',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  decoration: InputDecoration(
                    labelText: 'Data de nascimento:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      maxHeight: 70,
                      maxWidth: 350,
                    ),
                  ),
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecCpf,
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
                    labelText: "Digite seu CPF:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _tecSenha,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      maxHeight: 70,
                      maxWidth: 350,
                    ),
                    labelText: "Digite a senha:",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                ElevatedButton(
                  onPressed: _cadastro,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black),
                      minimumSize: MaterialStateProperty.all(Size(40, 40))),
                  child: Text(
                    "Criar conta",
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                ),
              ])
        ]),
      ),
    );
  }

  TextEditingController _tecNomeUsuario = TextEditingController();
  TextEditingController _tecNomeReal = TextEditingController();
  TextEditingController _tecSenha = TextEditingController();
  TextEditingController _tecCpf = TextEditingController();
  TextEditingController _tecData = TextEditingController();

  _cadastro() async {
    String nomeUsuario = _tecNomeUsuario.text;
    String nomeReal = _tecNomeReal.text;
    String cpf = _tecCpf.text;
    String dataNasc = _tecData.text;
    String senha = _tecSenha.text;
    Usuario novoUsuario;

    Future<int> size = getQtdDocs(nomeColecao);
    Future<bool> verifica = verificaExisteUser(nomeColecao, nomeUsuario);
    if (await verifica == false && verificaCPF(cpf) == true) {
      if (await size == 0) {
        novoUsuario =
            Usuario(1, nomeUsuario, nomeReal, senha, cpf, dataNasc, 0);
      } else {
        novoUsuario = Usuario(
            await size + 1, nomeUsuario, nomeReal, senha, cpf, dataNasc, 0);
      }

      FirebaseFirestore.instance
          .collection(nomeColecao)
          .add(novoUsuario.toJson());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }else{
      alertDialog(context);
    }
  }

  bool verificaCPF(String cpf){

    // Remover caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    // Verificar se possui 11 dígitos
    if (cpf.length != 11) {
      return false;
    }

    // Verificar se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false;
    }

    // Validar dígitos verificadores
    List<int> digits = cpf.split('').map(int.parse).toList();
    int sum1 = 0;
    int sum2 = 0;
    int i;

    // Verificar o primeiro dígito verificador
    for (i = 0; i < 9; i++) {
      sum1 += digits[i] * (10 - i);
      sum2 += digits[i] * (11 - i);
    }
    int remainder1 = (sum1 % 11) < 2 ? 0 : 11 - (sum1 % 11);
    if (digits[9] != remainder1) {
      return false;
    }

    // Verificar o segundo dígito verificador
    sum2 += remainder1 * 2;
    int remainder2 = (sum2 % 11) < 2 ? 0 : 11 - (sum2 % 11);
    if (digits[10] != remainder2) {
      return false;
    }

    return true;
  }

  alertDialog(BuildContext context) {
    Widget voltarButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Colors.black),),
      child: Text("Voltar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
        });
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text('Falha no cadastro'),
      content: Text("Nome de usuário já existente ou CPF incorreto"),
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
