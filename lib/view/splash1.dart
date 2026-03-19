import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitrabai/firebase_options.dart';
import 'package:maitrabai/view/login.dart';

class Splash1 extends StatefulWidget {
  @override
  _Splash1State createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {

  @override
  void initState() {
    super.initState();

    //espera 3 segundos do splash
    Future.delayed(Duration(seconds: 4)).then((_) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
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