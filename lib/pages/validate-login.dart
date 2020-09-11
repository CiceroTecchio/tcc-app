import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcc_app/pages/home.dart';
import 'package:tcc_app/pages/linha.dart';
import 'package:tcc_app/pages/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tcc_app/services/variaveis.dart' as variaveis;
import 'package:tcc_app/services/funcoes.dart' as funcoes;
import 'package:tcc_app/services/requests.dart' as requests;

class ValidateScreen extends StatefulWidget {
  @override
  _ValidateWidgetState createState() => _ValidateWidgetState();
}

class _ValidateWidgetState extends State<ValidateScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => verificarLogin());
  }

    verificarRegistros() async {
    var request = await requests.buscarRegistro();
    if(request == 'timeout'){
      await funcoes.showInfoToast(context, 'Falha ao conectar ao servidor, verifique sua conexão');
      await Future.delayed(Duration(seconds: 10));
      await verificarRegistros();
    }else if (request.statusCode == 401) {
      await funcoes.desconectar(context);
    } else if (request.statusCode == 200) {
      var responseJson = json.decode(request.body);
      if (responseJson['id'] != null) {
         Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: LinhaScreen(responseJson['id'])));
      }else{
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: HomeScreen(),
                    settings: RouteSettings(name: "/HomeScreen")));
      }
    }else{
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: HomeScreen(),
                    settings: RouteSettings(name: "/HomeScreen")));
    }
  }

  verificarLogin() async {
    String value = await variaveis.dados.read(key: 'key');

    if (value != null) {
      await verificarRegistros();

    } else {
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.downToUp, child: LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/imagens/onibus.gif"), context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Image.asset(
                      'assets/imagens/onibus.gif',
                      width: 140.0,
                      height: 140.0,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text('Cadê o Busão?', style: TextStyle(color: Colors.white, fontSize: 27)),
                    )
              ]),
        )));
  }
}
