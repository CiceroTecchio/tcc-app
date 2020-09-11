library tcc_app.requests;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcc_app/model/linha_model.dart';
import 'package:tcc_app/model/veiculo_model.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_app/services/variaveis.dart' as variaveis;
import 'package:tcc_app/services/funcoes.dart' as funcoes;

//Busca as Linhas e retorna para o dropdown
Future<List<LinhaModel>> getLinhasData(filter, context) async {
  var response =
      await http.get(variaveis.linha, headers: await variaveis.getHeader());
  var models = LinhaModel.fromJsonList(json.decode(response.body)['linhas']);
  if (response.statusCode == 401) {
    if (Navigator.canPop(context) == true) {
      Navigator.pop(context);
    }
    await funcoes.desconectar(context);
  }
  return models;
}

//Busca os Veiculos e retorna para o dropdown
Future<List<VeiculoModel>> getVeiculoData(filter, context) async {
  var response =
      await http.get(variaveis.veiculo, headers: await variaveis.getHeader());
  var models =
      VeiculoModel.fromJsonList(json.decode(response.body)['veiculos']);
  if (response.statusCode == 401) {
    if (Navigator.canPop(context) == true) {
      Navigator.pop(context);
    }
    await funcoes.desconectar(context);
  }
  return models;
}

resetarSenha(body) async {
  try {
    var response = await http
        .post('${variaveis.resetarSenha}',
            headers: await variaveis.getHeader(), body: body)
        .timeout(const Duration(seconds: 30));

    return response;
  } on TimeoutException catch (_) {
    return 'timeout';
  } on SocketException catch (_) {
    return 'timeout';
  }
}

login(body) async {
  try {
    var response = await http
        .post('${variaveis.login}',
            headers: await variaveis.getHeaderNoKey(), body: body)
        .timeout(const Duration(seconds: 30));

    return response;
  } on TimeoutException catch (_) {
    return 'timeout';
  } on SocketException catch (_) {
    return 'timeout';
  }
}

buscarRegistro() async {
  try {
    var response = await http
        .get('${variaveis.roteiroRegistro}',
            headers: await variaveis.getHeader())
        .timeout(const Duration(seconds: 30));

    return response;
  } on TimeoutException catch (_) {
    return 'timeout';
  } on SocketException catch (_) {
    return 'timeout';
  }
}

roteiroRegistroPOST(body) async {
  try {
    var response = await http
        .post('${variaveis.roteiroRegistro}',
            headers: await variaveis.getHeader(), body: body)
        .timeout(const Duration(seconds: 30));

    return response;
  } on TimeoutException catch (_) {
    return 'timeout';
  } on SocketException catch (_) {
    return 'timeout';
  }
}

roteiroRegistroFINALIZAR(id) async {
  try {
    var response = await http
        .delete('${variaveis.roteiroRegistro}/$id',
            headers: await variaveis.getHeader())
        .timeout(const Duration(seconds: 30));

    return response;
  } on TimeoutException catch (_) {
    return 'timeout';
  } on SocketException catch (_) {
    return 'timeout';
  }
}
