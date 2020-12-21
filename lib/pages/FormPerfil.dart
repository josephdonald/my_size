import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_size/helper/DatabaseHelper.dart';
import 'package:my_size/model/Perfil.dart';

class FormPerfil extends StatefulWidget {
  @override
  _FormPerfilState createState() => _FormPerfilState();
}

class _FormPerfilState extends State<FormPerfil> {

  Perfil perfil = Perfil();

  //CORES PRIMARIA E SECUNDARIA
  Color primaryColor = Color.fromRGBO(17, 61, 79, 1);
  Color secondaryColor = Color.fromRGBO(223, 228, 230, 1);

  //TEXTO BOTAO SALVA / ATUALIZAR
  String botaoSalvarAtualizar = "Salvar";

  // bool salvar = true;

  //INSTANCIA O BANCO NA VARIAVEL
  var _db = DatabaseHelper();

  //CONTROLLERS DOS INPUTS
  TextEditingController controllerIdUsuario = TextEditingController();
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAltura = TextEditingController();
  TextEditingController controllerDtNasc = TextEditingController();
  TextEditingController controllerPesoObj = TextEditingController();

  String radioGenero = "";

  //SALVAR OU ATUALIZAR O PERFIL DO USUÁRIO
  _salvarAtualizarPerfil ({Perfil perfilAtualizado}) async {

    String nome = controllerNome.text;
    String email = controllerEmail.text;
    double altura = controllerAltura.text == "" ? null : double.parse(controllerAltura.text);
    String dtNasc = controllerDtNasc.text;
    String genero = radioGenero;
    double pesoObj = controllerPesoObj.text == "" ? null : double.parse(controllerPesoObj.text);

    if (botaoSalvarAtualizar == "Salvar"){

      //save
      Perfil novoPerfil = Perfil(nome: nome, email: email, altura: altura, dataNascimento: dtNasc, genero: genero, pesoObjetivo: pesoObj);

      int resultado = await _db.salvarPerfil(novoPerfil);

      return resultado;

    } else {

      //update
      perfilAtualizado.nome = nome;
      perfilAtualizado.email = email;
      perfilAtualizado.altura = altura;
      perfilAtualizado.dataNascimento = dtNasc;
      perfilAtualizado.genero = genero;
      perfilAtualizado.pesoObjetivo = pesoObj;

      int resultado = await _db.atualizarPerfil(perfilAtualizado);

      return resultado;

    }


  }

  Future<Perfil> getPerfilBD() async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    List dadosPerfil = await databaseHelper.getPerfil();
    
    setState(() {

      if (dadosPerfil.isNotEmpty){
        botaoSalvarAtualizar = "Atualizar";
        // print("UP PERFIL: " + dadosPerfil[0].toString());
      } else {
        botaoSalvarAtualizar = "Salvar";
      }

      for(var item in dadosPerfil){
        perfil = Perfil.fromMap(item);
        controllerNome.text = perfil.nome;
        controllerEmail.text = perfil.email;
        perfil.altura == null ? controllerAltura.text = "" : controllerAltura.text = perfil.altura.toString();
        controllerDtNasc.text = perfil.dataNascimento;
        radioGenero = perfil.genero;
        perfil.pesoObjetivo == null ? controllerPesoObj.text = "" : controllerPesoObj.text = perfil.pesoObjetivo.toString();
      }
    });

    return perfil;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPerfilBD();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 61, 79, 1),
        title: Text("Cadastro do Perfil"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        perfil.nome == null ? "Nome do usuário" : perfil.nome,
                        style: TextStyle(color: primaryColor, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: controllerNome,
                    style: TextStyle(fontSize: 22, color: primaryColor),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20, color: primaryColor),
                      labelText: "Nome",
                      hintText: "Digite seu nome",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20, color: primaryColor),
                      labelText: "E-mail",
                      hintText: "Digite seu e-mail",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: controllerAltura,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20, color: primaryColor),
                      labelText: "Altura",
                      hintText: "Digite sua altura",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: controllerDtNasc,
                    keyboardType: TextInputType.datetime,
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20, color: primaryColor),
                      labelText: "Data de nascimento",
                      hintText: "Digite sua data de nascimento",
                      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Masculino",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                    Radio(
                        activeColor: primaryColor,
                        value: "Masculino",
                        groupValue: radioGenero,
                        onChanged: (value) {
                          setState(() {
                            radioGenero = value;
                            print(radioGenero);
                          });
                        }),
                    Text(
                      "Feminino",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                    Radio(
                        activeColor: primaryColor,
                        value: "Feminino",
                        groupValue: radioGenero,
                        onChanged: (value) {
                          setState(() {
                            radioGenero = value;
                            print(radioGenero);
                          });
                        }),

                  ],

                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: controllerPesoObj,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 22,
                    color: primaryColor,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 20, color: primaryColor),
                    labelText: "Meta para o seu peso",
                    hintText: "Digite sua meta",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  color: primaryColor,
                  child: Text(
                    botaoSalvarAtualizar,
                    style: TextStyle(color: secondaryColor),
                  ),
                  onPressed: () {
                    _salvarAtualizarPerfil(perfilAtualizado: perfil);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
