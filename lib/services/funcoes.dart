import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tcc_app/pages/home.dart';
import 'package:tcc_app/pages/login.dart';
import 'package:tcc_app/services/funcoes.dart' as funcoes;
import 'package:tcc_app/services/variaveis.dart' as variaveis;
import 'package:tcc_app/services/requests.dart' as requests;

desconectar(context) async {
  await variaveis.dados.delete(key: 'key');
  await variaveis.dados.delete(key: 'user');
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            content: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child:
                  Text("Usuário desconectado", style: TextStyle(fontSize: 23)),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Confirmar",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  Navigator.pop(context);
                  await funcoes.deslogar(context);
                },
              ),
            ],
          ));
}

deslogar(context) async {
  await funcoes.loadingModal(context);
  await variaveis.dados.delete(key: 'key');
  await variaveis.dados.delete(key: 'user');
  Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade, child: LoginScreen()));
}

loadingModal(context, [texto]) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
            type: MaterialType.transparency,
            child: Center(
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
                    texto != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(texto,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold)),
                          )
                        : Container()
                  ]),
            ));
      });
}

Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    messageText:
        Text(message, style: TextStyle(fontSize: 20, color: Colors.white)),
    icon: Icon(
      Icons.error,
      size: 35.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    messageText:
        Text(message, style: TextStyle(fontSize: 20, color: Colors.white)),
    icon: Icon(
      Icons.check,
      size: 35.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

finalizarLinha(context, id) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text("Finalizar Linha?", style: TextStyle(fontSize: 23)),
            content: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("Deseja realmente finalizar a linha?",
                  style: TextStyle(fontSize: 18)),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Sim",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  Navigator.pop(context);
                  await funcoes.loadingModal(context, 'Finalizando...');
                  var request = await requests.roteiroRegistroFINALIZAR(id);
                  Navigator.pop(context);
                  if (request.statusCode == 401) {
                    await funcoes.desconectar(context);
                  } else if (request.statusCode == 409) {
                    Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: HomeScreen()));
                        funcoes.showSuccessToast(
                            context, 'Linha já estava inativa');
                  } else if (request.statusCode != 200) {
                    Navigator.pop(context);
                    funcoes.showErrorToast(context, 'Falha ao finalizar Linha');
                  } else {
                   Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: HomeScreen()));
                        funcoes.showSuccessToast(
                            context, 'Linha Finalizada');
                  }
                },
              ),
              CupertinoDialogAction(
                  child: Text("Não",
                      style: TextStyle(color: Colors.red, fontSize: 18)),
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          ));
}
