import 'package:my_size/helper/DatabaseHelper.dart';

class Perfil{

  int idUsuario;
  String nome;
  String email;
  double altura;
  String dataNascimento;
  String genero;
  double pesoObjetivo;
  // String foto;


  Perfil({this.idUsuario, this.nome, this.email, this.altura, this.dataNascimento, this.genero, this.pesoObjetivo});

  Map toMap(){

    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "altura" : this.altura,
      "dtNasc" : this.dataNascimento,
      "genero" : this.genero,
      "peso_obj" : this.pesoObjetivo,
    };

    if(this.idUsuario != null){
      map["id_perfil"] = this.idUsuario;
    }
    // Map<String, dynamic> map = {
    //   DatabaseHelper.colNome : this.nome,
    //   DatabaseHelper.colEmssail : this.email,
    //   DatabaseHelper.colAltura : this.altura,
    //   DatabaseHelper.colDtNasc : this.dataNascimento,
    //   DatabaseHelper.colGenero : this.genero,
    //   DatabaseHelper.colPesoObj : this.pesoObjetivo,
    //   this.idUsuario == null : 0 != null ? DatabaseHelper.colIdPerfil = this.idUsuario as String,
    //
    //   if(this.idUsuario != null){
    //     DatabaseHelper.colIdPerfil : this.idUsuario,
    //   }
    // };



    return map;

  }

  Perfil.fromMap(Map map){

    this.idUsuario = map[DatabaseHelper.colIdPerfil];
    this.nome = map[DatabaseHelper.colNome];
    this.email = map[DatabaseHelper.colEmail];
    this.altura = map[DatabaseHelper.colAltura];
    this.dataNascimento = map[DatabaseHelper.colDtNasc];
    this.genero = map[DatabaseHelper.colGenero];
    this.pesoObjetivo = map[DatabaseHelper.colPesoObj];

  }



}