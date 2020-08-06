library tcc_app.variaveis;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var server = 'http://10.0.0.23:3800/api';

final dados = new FlutterSecureStorage();

var resetarSenha = '$server/recuperar/senha';

var login = '$server/auth/login';

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

