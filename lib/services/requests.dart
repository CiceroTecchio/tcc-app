library tcc_app.requests;

import 'dart:convert';
import 'package:tcc_app/model/linha_model.dart';
import 'package:tcc_app/model/veiculo_model.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_app/services/variaveis.dart' as variaveis;

//Busca as Linhas e retorna para o dropdown
Future<List<LinhaModel>> getLinhasData(filter) async {
  var response = await http.get(variaveis.linha, headers: await variaveis.getHeader());
  var models = LinhaModel.fromJsonList(json.decode(response.body)['linhas']);
  return models;
}

//Busca os Veiculos e retorna para o dropdown
Future<List<VeiculoModel>> getVeiculoData(filter) async {
  var response = await http.get(variaveis.veiculo, headers: await variaveis.getHeader());
  var models = VeiculoModel.fromJsonList(json.decode(response.body)['veiculos']);
  return models;
}

resetarSenha(body) async {
  var response = await http
      .post('${variaveis.resetarSenha}', headers: await variaveis.getHeader(), body: body)
      .timeout(const Duration(seconds: 15));

  return response;
}

login(body) async {
  var response = await http
          .post('${variaveis.login}', headers: await variaveis.getHeaderNoKey(), body: body)
          .timeout(const Duration(seconds: 15));

  return response;
}

roteiroRegistroPOST(body) async {
  var response = await http
      .post('${variaveis.roteiroRegistro}', headers: await variaveis.getHeader(), body: body)
      .timeout(const Duration(seconds: 15));

  return response;
}

roteiroRegistroFINALIZAR(id) async {
  var response = await http
      .delete('${variaveis.roteiroRegistro}/$id', headers: await variaveis.getHeader())
      .timeout(const Duration(seconds: 15));

  return response;
}