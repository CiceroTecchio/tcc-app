import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcc_app/pacotes/flutter_login/lib/flutter_login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tcc_app/pages/home.dart';
import 'package:tcc_app/services/requests.dart' as requests;
import 'package:tcc_app/services/variaveis.dart' as variaveis;

class LoginScreen extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Requisição para a API enviar e-mail de recuperação
  Future<String> resetPassword(String email) async {
    var body = json.encode({'email': email});

    try {
      //Envia a Requisição
      final response = await requests.resetarSenha(body);

      //se houve o timeout
      if(response == 'timeout'){
        return 'Falha ao realizar login, tente novamente';
      }

      //Transforma a response em um JSON
      var responseJSON = json.decode(response.body);

      //Se E-mail foi enviado
      if (response.statusCode == 200) {
        return null;

        //Caso não exista usuário com o e-mail informado
      } else if (responseJSON['errors']['email'][0] ==
          'Não encontramos um usuário com esse endereço de e-mail.') {
        return 'Nenhum usuário com o e-mail informado';

        //Caso já tenha sido enviado e-mail
      } else if (responseJSON['errors']['email'][0] ==
          'Aguarde antes de tentar novamente.') {
        return 'Um link já foi enviado, verifique seu e-mail';
      } else {
        return 'Falha ao enviar e-mail, tente novamente';
      }

      //TimeOut
    } on TimeoutException catch (e) {
      return 'Falha ao enviar e-mail, tente novamente';
    }
  }

//Requisição para login
  Future<String> login(LoginData dados) async {
    var body = json.encode({'email': dados.name, 'senha': dados.password});

      //Envia a Requisição
      final response = await requests.login(body);

      //se houve o timeout
      if(response == 'timeout'){
        return 'Falha ao realizar login, tente novamente';
      }

      //Transforma a response em um JSON
      var responseJSON = json.decode(response.body);

      //Se o login foi realizado
      if (response.statusCode == 200) {
        // Write value
        await variaveis.dados
            .write(key: 'key', value: responseJSON['api_token']);
        await variaveis.dados.write(key: 'user', value: responseJSON['user']);
        return null;

        //Caso os dados estejam incorretos
      } else if (response.statusCode == 401) {
        return 'Usuário ou senha inválidos';

        //Caso tenham sido realizadas muitas tentativas de login
      } else if (response.statusCode == 429) {
        return 'Muitas tentativas, aguarde para tentar novamente';
      } else {
        return 'Falha ao realizar login, tente novamente';
      }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: FlutterLogin(
          headerMarginTop: 40,
          title: 'Cadê o Busão?',
          logo: 'assets/imagens/onibus.gif',
          onSubmitAnimationCompleted: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: HomeScreen(),
                    settings: RouteSettings(name: "/HomeScreen")));
          },
          theme: LoginTheme(
            titleStyle: TextStyle(fontFamily: 'Quicksand', fontSize: 40),
          ),
          onLogin: login,
          onRecoverPassword: resetPassword,
          hideButtonSignUp: true,
          messages: LoginMessages(
            usernameHint: 'E-Mail',
            passwordHint: 'Senha',
            loginButton: 'ENTRAR',
            recoverPasswordIntro: 'Recupere sua senha',
            forgotPasswordButton: 'Esqueceu sua senha?',
            recoverPasswordButton: 'RECUPERAR',
            goBackButton: 'VOLTAR',
            recoverPasswordDescription:
                'Um link de recuperação de senha será enviado no e-mail',
            recoverPasswordSuccess: 'Link de recuperação enviado',
          ),
        ));
  }
}
