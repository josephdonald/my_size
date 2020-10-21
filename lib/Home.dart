import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_size/helper/MedidasHelper.dart';
import 'package:my_size/model/Medidas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _pesoController = TextEditingController();
  TextEditingController _dataController = TextEditingController();

  List<Medidas> _medidas = List<Medidas>();

  var _db = MedidasHelper();

  _formatarData(String data) {
    var formatador = DateFormat("dd/MM/yy - HH:mm:ss");

    DateTime dataConvertida = DateTime.parse(data);

    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _exibirTelaCadastro({Medidas medidas, bool remover}) {
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

  _recuperarMedidas() async {
    List medidasRecuperadas = await _db.recuperarMedidas();
    List<Medidas> listaTemporaria = List<Medidas>();

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

    if (medidaAtualizada == null) {
      Medidas medidas = Medidas(peso, data);
      print("teste salvar: " + peso.toString());
      int resultado = await _db.salvarMedidas(medidas);

      print("teste salvar: " + resultado.toString());
    } else if (medidaAtualizada != null && remover == null) {
      medidaAtualizada.peso = peso;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarMedidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(17, 61, 79, 1),
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
                color: Color.fromRGBO(223, 228, 230, 1),
                onPressed: () {
                  print("botao menu");
                },
              ),
              FloatingActionButton(
                backgroundColor: Color.fromRGBO(223, 228, 230, 1),
                splashColor: Colors.green,
                child: Icon(Icons.add, color: Color.fromRGBO(17, 61, 79, 1),),
                onPressed: () {
                  _exibirTelaCadastro();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
