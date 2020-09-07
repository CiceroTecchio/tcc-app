import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tcc_app/model/linha_model.dart';
import 'package:tcc_app/model/veiculo_model.dart';
import 'package:tcc_app/pages/linha.dart';
import 'package:tcc_app/pages/login.dart';
import 'package:tcc_app/services/funcoes.dart' as funcoes;
import 'package:tcc_app/services/requests.dart' as requests;
import 'package:tcc_app/services/variaveis.dart' as variaveis;
import 'package:tcc_app/pacotes/dropdown_search/lib/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String user = 'Nome';
  VeiculoModel veiculo;
  LinhaModel linha;
  int id_veiculo;
  int id_linha;
  bool loadIcon = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setValues() async {
    var us = await variaveis.dados.read(key: 'user');
    setState(() {
      if (us != null) {
        user = us;
      }
    });
  }

  logout() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Sair da Conta?", style: TextStyle(fontSize: 23)),
              content: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Deseja realmente sair da sua conta?",
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
                    _scaffoldKey.currentState.openEndDrawer();
                    Navigator.pop(context);
                    funcoes.deslogar(context);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Center(
                  child: Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Text('Iniciar Linha',
                    style: GoogleFonts.concertOne(
                        color: Colors.white, fontSize: 30),
                    textAlign: TextAlign.center),
              )),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child:
                                        Image.asset('assets/imagens/user.png'),
                                  )),
                            ],
                          ),
                        ),
                        Text(user,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Sair da Conta', style: TextStyle(fontSize: 18)),
                    onTap: () => logout(),
                    trailing: Icon(FontAwesomeIcons.signOutAlt,
                        color: Colors.red[300]),
                  ),
                  Divider()
                ],
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                    key: _formKey,
                    child:
                        ListView(padding: EdgeInsets.only(top: 50), children: <
                            Widget>[
                      Card(
                          elevation: 10,
                          child: DropdownSearch<VeiculoModel>(
                            mode: Mode.MENU,
                            autoFocusSearchBox: true,
                            showClearButton: true,
                            showSearchBox: true,
                            label: 'Veículo',
                            validator: (VeiculoModel u) =>
                                u == null ? "Selecione um Veículo" : null,
                            onFind: (String filter) =>
                                requests.getVeiculoData(filter),
                            onSaved: (VeiculoModel data) =>
                                id_veiculo = data.id,
                            onChanged: (VeiculoModel data) {
                              veiculo = data;
                            },
                            dropdownBuilder: _dropdownVeiculo,
                            popupItemBuilder: _dropdownVeiculoItem,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Card(
                            elevation: 10,
                            child: DropdownSearch<LinhaModel>(
                              mode: Mode.MENU,
                              autoFocusSearchBox: true,
                              showClearButton: true,
                              showSearchBox: true,
                              label: 'Linha',
                              validator: (LinhaModel u) =>
                                  u == null ? "Selecione uma Linha" : null,
                              onFind: (String filter) =>
                                  requests.getLinhasData(filter),
                              onSaved: (LinhaModel data) => id_linha = data.id,
                              onChanged: (LinhaModel data) {
                                linha = data;
                              },
                              dropdownBuilder: _dropdownLinha,
                              popupItemBuilder: _dropdownLinhaItem,
                            )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 80.0, left: 50, right: 50),
                        child: CupertinoButton(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                await funcoes.loadingModal(
                                    context, 'Iniciando...');
                                var body = json.encode({
                                  'cod_veiculo': id_veiculo,
                                  'cod_linha': id_linha
                                });
                                var request =
                                    await requests.roteiroRegistroPOST(body);
                                Navigator.pop(context);
                                if (request.statusCode == 401) {
                                  await funcoes.desconectar(context);
                                } else if (request.statusCode != 201) {
                                  funcoes.showErrorToast(
                                      context, 'Falha ao Iniciar Linha');
                                } else {
                                  var responseJSON = json.decode(request.body);
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child:
                                              LinhaScreen(responseJSON['id'])));
                                }
                              }
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.play_arrow_solid,
                                      size: 35),
                                  Text(
                                    " INICIAR",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ptSans(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 25),
                                  )
                                ])),
                      )
                    ])))));
  }

  Widget _dropdownVeiculo(
      BuildContext context, VeiculoModel item, String itemDesignation) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
          veiculo == null ? "Nenhum veículo selecionado" : veiculo.toString()),
    ));
  }

  Widget _dropdownVeiculoItem(
      BuildContext context, VeiculoModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
      ),
    );
  }

  Widget _dropdownLinha(
      BuildContext context, LinhaModel item, String itemDesignation) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.all(0),
      title:
          Text(linha == null ? "Nenhuma linha selecionada" : linha.toString()),
    ));
  }

  Widget _dropdownLinhaItem(
      BuildContext context, LinhaModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
      ),
    );
  }
}
