import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:maitrabai/view/screens/feed.dart';
import 'package:maitrabai/view/screens/criaServ.dart';
import 'package:maitrabai/view/screens/perfil.dart';

final styleLabel = TextStyle(color: Colors.white, fontSize: 25);

class Principal extends StatefulWidget {
  Principal(this.id);
  final int id;

  @override
  _PrincipalState createState() => _PrincipalState(id);
}

class _PrincipalState extends State<Principal> {

  final int id;
  _PrincipalState(this.id);

  int _indiceAtual = 0;
  List<Widget> _telas = [];

  @override
  void initState(){
    super.initState();
    _telas = [
      Feed(id),
      CriaServ(id),
      Perfil(id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //o widget scaffold é a estrutura que iremos traballha nas telas de nossos apps
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.adb),
              label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Criar serviço",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      if(id != null) {
        _indiceAtual = index;
      }
    });
  }
}