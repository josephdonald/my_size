import 'package:my_size/model/Medidas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedidasHelper{

  static final String nomeTabela = "medidas";
  static final String colunaId = "id";
  static final String colunaPeso = "peso";
  static final String colunaDataHorario = "dataHorario";

  static final MedidasHelper _medidasHelper = MedidasHelper._internal();

  Database _db;

  MedidasHelper._internal();

  factory MedidasHelper(){
    return _medidasHelper;
  }

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_medidas.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $nomeTabela ($colunaId INTEGER PRIMARY KEY AUTOINCREMENT, $colunaPeso REAL, $colunaDataHorario DATETIME)";
    await db.execute(sql);
  }

  Future<int> salvarMedidas(Medidas medidas) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, medidas.toMap());
    return resultado;
  }

  recuperarMedidas() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY $colunaDataHorario DESC";
    List listaMedidas = await bancoDados.rawQuery(sql);

    return listaMedidas;
  }

  Future<int> atualizarMedidas(Medidas medidas) async {
    var bancoDados = await db;

    return await bancoDados.update(
      nomeTabela,
      medidas.toMap(),
      where: "id = ?",
      whereArgs: [medidas.id],
    );
  }

  Future<int> removerMedidas(int id) async{

    var bancoDados = await db;

    return await bancoDados.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id],
    );

  }

}