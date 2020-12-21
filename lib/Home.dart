import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_size/helper/DatabaseHelper.dart';
import 'package:my_size/helper/MedidasHelper.dart';
import 'package:my_size/model/Medidas.dart';
import 'package:my_size/model/Perfil.dart';
import 'package:my_size/pages/Estatisticas.dart';
import 'package:my_size/pages/FormPerfil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Perfil perfil = Perfil();

  //CORES PRIMARIA E SECUNDARIA
  Color primaryColor = Color.fromRGBO(17, 61, 79, 1);
  Color secondaryColor = Color.fromRGBO(223, 228, 230, 1);

  TextEditingController _pesoController = TextEditingController();
  TextEditingController _dataController = TextEditingController();

  List<Medidas> _medidas = List<Medidas>();

  // var _db = MedidasHelper();
  var _db = DatabaseHelper();

  _formatarData(String data) {
    var formatador = DateFormat("dd/MM/yy - HH:mm:ss");

    DateTime dataConvertida = DateTime.parse(data);

    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _exibirTelaCadastro({Medidas medidas, bool remover}) async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    List dadosPerfil = await databaseHelper.getPerfil();

    if (dadosPerfil.isEmpty) {
      final snackbar =
          SnackBar(content: Text("Antes das medidas, cadastre seu perfil ;) "));

      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      bool habilitaTextField;
      String textoSalvaAtualizar = "";
      String textoBotao = "";

      if (medidas == null) {
        habilitaTextField = true;
        _pesoController.clear();
        _dataController.clear();
        textoSalvaAtualizar = "Salvar medida";
        textoBotao = "Salvar";
      } else if (medidas != null && remover == null) {
        habilitaTextField = true;
        _pesoController.text = medidas.peso.toString();
        _dataController.text = medidas.data;
        textoSalvaAtualizar = "Atualizar medida";
        textoBotao = "Atualizar";
      } else if (medidas != null && remover) {
        _pesoController.text = medidas.peso.toString();
        _dataController.text = medidas.data;
        habilitaTextField = false;
        textoSalvaAtualizar = "Deseja excluir essa medida?";
        textoBotao = "Excluir";
        print("Método Excluir");
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(textoSalvaAtualizar),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _pesoController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    enabled: habilitaTextField,
                    decoration: InputDecoration(
                      labelText: "Peso",
                      hintText: "Digite o peso atual",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    _salvarAtualizarMedidas(
                        medidaAtualizada: medidas, remover: remover);
                  },
                  child: Text(textoBotao),
                )
              ],
            );
          });
    }
  }

  _recuperarMedidas() async {
    List medidasRecuperadas = await _db.recuperarMedidas();
    List<Medidas> listaTemporaria = List<Medidas>();

    print("DADOS PERFIL: " + medidasRecuperadas.toString());

    for (var item in medidasRecuperadas) {
      Medidas medidas = Medidas.fromMap(item);
      listaTemporaria.add(medidas);
    }

    setState(() {
      _medidas = listaTemporaria;
    });

    listaTemporaria = null;
  }

  _salvarAtualizarMedidas({Medidas medidaAtualizada, bool remover}) async {
    double peso = double.parse(_pesoController.text.replaceAll(',', '.'));
    String data = DateTime.now().toString();

    int idPerfilFk = 1;

    if (medidaAtualizada == null) {
      Medidas medidas = Medidas(peso: peso, data: data, idPerfilFk: idPerfilFk);
      print("teste salvar: " + peso.toString());
      int resultado = await _db.salvarMedidas(medidas);

      print("teste salvar: " + resultado.toString());
    } else if (medidaAtualizada != null && remover == null) {
      medidaAtualizada.peso = peso;

      print("TESTE SALVAR / ATUALIZAR: " +
          medidaAtualizada.idPerfilFk.toString() +
          "REMOVER: " +
          remover.toString());

      int resultado = await _db.atualizarMedidas(medidaAtualizada);

      print("medida atualizada!");
    } else if (medidaAtualizada != null && remover) {
      _removerMedidas(medidaAtualizada.id);

      print("funcao remover");
    }

    _pesoController.clear();
    _dataController.clear();

    _recuperarMedidas();

    Navigator.pop(context);
  }

  _removerMedidas(int id) async {
    await _db.removerMedidas(id);
    _recuperarMedidas();
  }

  Future<Perfil> _recuperarPerfil() async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    List dadosPerfil = await databaseHelper.getPerfil();
    setState(() {
      for (var item in dadosPerfil) {
        perfil = Perfil.fromMap(item);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarMedidas();
  }

  @override
  Widget build(BuildContext context) {
    _recuperarPerfil();
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text("My Size"),
      //   backgroundColor: Color.fromRGBO(17, 61, 79, 1),
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _medidas.length,
              itemBuilder: (context, index) {
                final item = _medidas[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: ListTile(
                      title: Text(item.peso.toString() + " kg"),
                      subtitle: Text("${_formatarData(item.data)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _exibirTelaCadastro(medidas: item);
                              print("editar");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _exibirTelaCadastro(medidas: item, remover: true);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                color: secondaryColor,
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                  _recuperarPerfil();
                  print("teste botao menu");
                },
              ),
              FloatingActionButton(
                backgroundColor: secondaryColor,
                splashColor: Colors.green,
                child: Icon(
                  Icons.add,
                  color: primaryColor,
                ),
                onPressed: () {
                  _exibirTelaCadastro();
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              arrowColor: primaryColor,
              accountName: Text(perfil.nome == null ? "Usuário" : perfil.nome),
              accountEmail:
                  Text(perfil.email == null ? "E-mail" : perfil.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                child: Text(
                  "Perfil",
                  style: TextStyle(fontSize: 20, color: primaryColor),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FormPerfil()));
                  print("perfil");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                child: Text(
                  "Estatísticas",
                  style: TextStyle(fontSize: 20, color: primaryColor),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Estatisticas()));
                  print("estatisticas");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, color: primaryColor),
                ),
                onTap: () {
                  print("logout");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
