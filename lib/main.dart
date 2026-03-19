import 'package:flutter/material.dart';
import 'package:maitrabai/view/splash1.dart';

void main() {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      title: "Maitrabai",
      home: Splash1()
  ));

}