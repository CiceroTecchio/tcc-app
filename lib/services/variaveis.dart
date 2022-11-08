library tcc_app.variaveis;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// var server = 'https://www.cadeobusao.com/api';
var server = 'http://10.0.0.24:3800/api';

final dados = new FlutterSecureStorage();

var resetarSenha = '$server/recuperar/senha';

var login = '$server/auth/login';

var veiculo = '$server/veiculos';

var linha = '$server/linhas';

var roteiroRegistro = '$server/registros';

getHeader() async {
  var key = await dados.read(key: 'key');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": "Bearer ${key}"
  };
  return headers;
}

getHeaderNoKey() async {
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
  return headers;
}

