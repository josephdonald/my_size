import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_size/helper/DatabaseHelper.dart';
import 'package:my_size/helper/MedidasHelper.dart';
import 'package:my_size/model/Medidas.dart';
import 'package:my_size/model/Perfil.dart';

class Estatisticas extends StatefulWidget {
  @override
  _EstatisticasState createState() => _EstatisticasState();
}

class _EstatisticasState extends State<Estatisticas> {

  double tamEntreLinhasTop = 5;
  double tamEntreLinhasBottom = 5;
  double tamFonte = 18;
  String nomeEstatist = "";
  double pesoObj = 0;
  double altura = 0;
  double imc = 0;
  String categIMC = "";
  String diferenPeso = "";

  Perfil perfilEstat = Perfil();
  Medidas medidas = Medidas();
  Medidas maiorPesoMedidas = Medidas();
  Medidas menorPesoMedidas = Medidas();
  Medidas mediaPesoMedidas = Medidas();

  Future<Perfil> _getPerfilBD() async {

    DatabaseHelper databaseHelper = DatabaseHelper();
    List dadosPerfil = await databaseHelper.getPerfil();

    Perfil(nome: nomeEstatist, pesoObjetivo: pesoObj, altura: altura);

    for (var item in dadosPerfil){
      setState(() {
        perfilEstat = Perfil.fromMap(item);
      });

    }

  }

  Future<Medidas> _getMedidas() async {
      MedidasHelper medidasHelper = MedidasHelper();

      List medidasPerfil = await medidasHelper.recuperarMedidas();
      List maiorPeso = await medidasHelper.recuperaMaiorPeso();
      List menorPeso = await medidasHelper.recuperaMenorPeso();
      List mediaPeso = await medidasHelper.recuperaPesoMedio();


      setState(() {

        for (var item in medidasPerfil){
          medidas = Medidas.fromMap(item);
        }

        for (var item in maiorPeso){
          maiorPesoMedidas = Medidas.fromMap(item);
        }

        for (var item in menorPeso){
          menorPesoMedidas = Medidas.fromMap(item);
        }

        for (var item in mediaPeso){
          mediaPesoMedidas = Medidas.fromMap(item);
        }

      });

      _calculaDiferencaPeso(perfilEstat.pesoObjetivo, medidas.peso);
      _calculaIMC(perfilEstat.altura, medidas.peso);

  }

  double _calculaDiferencaPeso(double pesoObj, double pesoAtual){

    double diferencaPeso = 0;

    setState(() {
      if (pesoAtual > pesoObj){
        diferencaPeso = pesoAtual - pesoObj;
        diferenPeso = "+ " + diferencaPeso.toStringAsPrecision(4);
      } else {
        diferencaPeso = pesoAtual - pesoObj;
        diferenPeso = diferencaPeso.toStringAsPrecision(4);
      }

    });

  }

  double _calculaIMC(double altura, double peso) {

    double imcLocal = peso / pow(altura, 2);

    String classeIMC = "";

    if (imcLocal < 18.5 ){
      classeIMC = "Abaixo do peso";
    } else if (imcLocal >= 18.5 && imcLocal < 25){
      classeIMC = "Peso normal";
    }else if (imcLocal >= 25 && imcLocal < 29.9){
      classeIMC = "Sobrepeso";
    } else if (imcLocal >= 30){
      classeIMC = "Obesidade";
    }

    setState(() {
      imc = imcLocal;
      categIMC = classeIMC;
    });

  }

  _formatarData(String data) {
    var formatador = DateFormat("dd/MM/yy - HH:mm:ss");

    DateTime dataConvertida = DateTime.parse(data);

    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPerfilBD();
    _getMedidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 61, 79, 1),
        title: Text("Suas medidas"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                  perfilEstat.nome == null ? "Olá!" : "Olá " + perfilEstat.nome+"! ",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                    imc == null ? "Índice IMC: Sem dados. Você precisa informar a altura e o peso" : "Índice IMC: " + imc.toStringAsPrecision(4),
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                  categIMC == null ? "Categoria IMC: Sem índice" : "Categoria IMC: " + categIMC,
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                    medidas.peso == null ? "Último peso: " : "Último peso: " + medidas.peso.toString() + " kg - " + _formatarData(medidas.data),
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                    perfilEstat.pesoObjetivo == null ? "Meta: " : "Meta: " + perfilEstat.pesoObjetivo.toString() + " kg ",
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                  diferenPeso == null ? "Diferença:" : "Diferença: ${diferenPeso} kg",
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                  maiorPesoMedidas.peso == null ? "Maior peso:" : "Maior peso: ${maiorPesoMedidas.peso} kg",
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                  menorPesoMedidas.peso == null ? "Menor peso:" : "Menor peso: ${menorPesoMedidas.peso} kg",
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: tamEntreLinhasTop, bottom: tamEntreLinhasBottom),
                child: Text(
                    mediaPesoMedidas.peso == null ? "Peso médio:" : "Peso médio: ${mediaPesoMedidas.peso.toStringAsPrecision(4)} kg",
                  style: TextStyle(fontSize: tamFonte),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}
