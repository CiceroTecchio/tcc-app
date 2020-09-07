import 'package:flutter/material.dart';
import 'package:tcc_app/pages/validate-login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff00b5ad),
      ),
      home: ValidateScreen(),
    );
  }
}