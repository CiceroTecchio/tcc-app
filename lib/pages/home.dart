import 'package:flutter/material.dart';
import 'package:tcc_app/services/variaveis.dart' as variaveis;

class HomeScreen extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[Text('home')],
    ));
  }
}
