import 'package:my_size/model/Perfil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PerfilHelper{

  static final String nomeTabela = "perfil";

  static final String colunaId = "idPerfil";
  static final String colunaNome = "nome";
  static final String colunaEmail = "email";
  static final String colunaAltura = "altura";
  static final String colunaDtNasc = "dtNasc";
  static final String colunaGenero = "genero";
  static final String colunaPesoObj = "peso_objetivo";

  static final PerfilHelper _perfilHelper = PerfilHelper._internal();

  Database _db;

  PerfilHelper._internal();


  factory PerfilHelper(){
    return _perfilHelper;
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
    String sql = "CREATE TABLE $nomeTabela ("
        "$colunaId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colunaNome TEXT, "
        "$colunaEmail TEXT,"
        "$colunaAltura REAL,"
        "$colunaDtNasc DATETIME,"
        "$colunaGenero TEXT,"
        "$colunaPesoObj REAL"
        ");";

    await db.execute(sql);
  }

  Future<int> salvarPerfil(Perfil perfil) async {

  print("perfil no banco: " + perfil.toMap().toString());

    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, perfil.toMap());

    return resultado;

  }


}