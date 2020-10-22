import 'package:my_size/model/Medidas.dart';
import 'package:my_size/model/Perfil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final String nomeTabMedidas = "medidas";
  static final String colIdMedidas = "id_medidas";
  static final String colunaPeso = "peso";
  static final String colunaDataHorario = "dataHorario";

  static final String nomeTabPerfil = "perfil";
  static String colIdPerfil = "id_perfil";
  static final String colNome = "nome";
  static final String colEmail = "email";
  static final String colAltura = "altura";
  static final String colDtNasc = "dtNasc";
  static final String colGenero = "genero";
  static final String colPesoObj = "peso_obj";

  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Database _dbMySize;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<Database> get databaseMySize async {
    if (_dbMySize != null) {
      return _dbMySize;
    } else {
      _dbMySize = await inicializarDB();
      return _dbMySize;
    }
  }

  Future<Database> inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_medidas.db");

    var dbInit =
        await openDatabase(localBancoDados, version: 2, onCreate: _onCreate);

    return dbInit;
  }

  _onCreate(Database db, int version) async {
    String sqlPerfil = "CREATE TABLE $nomeTabPerfil ("
        "$colIdPerfil INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colNome TEXT, "
        "$colEmail TEXT, "
        "$colAltura REAL, "
        "$colDtNasc DATETIME, "
        "$colGenero TEXT, "
        "$colPesoObj REAL"
        ");";

    await db.execute(sqlPerfil);

    String sqlMedidas =
        "CREATE TABLE $nomeTabMedidas ($colIdMedidas INTEGER PRIMARY KEY AUTOINCREMENT, $colunaPeso REAL, $colunaDataHorario DATETIME)";
    await db.execute(sqlMedidas);
  }

  //###### METODOS TABELA MEDIDAS #########
  Future<int> salvarMedidas(Medidas medidas) async {
    var bancoDados = await databaseMySize;
    int resultado = await bancoDados.insert(nomeTabMedidas, medidas.toMap());
    // databaseMySize.close();
    return resultado;
  }

  recuperarMedidas() async {
    var bancoDados = await databaseMySize;
    String sql =
        "SELECT * FROM $nomeTabMedidas ORDER BY $colunaDataHorario DESC";
    List listaMedidas = await bancoDados.rawQuery(sql);
    // databaseMySize.close();
    return listaMedidas;
  }

  Future<int> atualizarMedidas(Medidas medidas) async {
    var bancoDados = await databaseMySize;

    return await bancoDados.update(
      nomeTabMedidas,
      medidas.toMap(),
      where: "id = ?",
      whereArgs: [medidas.id],
    );
  }

  Future<int> removerMedidas(int id) async {
    var bancoDados = await databaseMySize;

    return await bancoDados.delete(
      nomeTabMedidas,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //###### METODOS TABELA PERFIL #########
  Future<int> salvarPerfil(Perfil perfil) async {
    // Map<String, dynamic> dadosTemp = {
    //   "nome" : 'Donald',
    //   "email" : 'donald@gmail.com',
    //   "altura" : '1.69',
    //   "dtNasc" : '05/03/1986',
    //   "genero" : 'Masculino',
    //   "peso_obj" : '75.5',
    // };

    try {
      Database bancoDados = await this.databaseMySize;
      int resultado = await bancoDados.insert(nomeTabPerfil, perfil.toMap());
      // var resultado = await bancoDados.insert(nomeTabPerfil, dadosTemp);
      print("resultado: " + resultado.toString());
      return resultado;
    } catch (e) {
      print("erro: " + e.toString());
      // return;
    }
  }

  Future<int> atualizarPerfil(Perfil perfil) async {

    try {
      var bancoDados = await this.databaseMySize;
      int resultado = await bancoDados.update(
        nomeTabPerfil,
        perfil.toMap(),
        where: "$colIdPerfil = ?",
        whereArgs: [perfil.idUsuario],
      );

      print("atualizar: " + resultado.toString());
      return resultado;
    } catch (e) {
      print("Erro: " + e.toString() );
    }
  }

  Future<List> getPerfil() async {
    var bancoDados = await this.databaseMySize;

    String sql = "SELECT * FROM $nomeTabPerfil limit 1;";

    List perfilObtido = await bancoDados.rawQuery(sql);

    return perfilObtido;
  }
}
