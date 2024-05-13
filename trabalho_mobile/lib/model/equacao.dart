import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Equacao {
  static const nome_tabela = 'equacoes';
  static const campo_id = '_id';
  static const campo_equacao = 'equacao';
  static const campo_resultado = 'resultado';

  int? id;
  String equacao;
  int resultado;

  Equacao({required this.id, required this.equacao, required this.resultado});

  // Método para inserir informações no banco de dados.
  Map<String, dynamic> toMap() => <String, dynamic>{
    campo_id: id,
    campo_equacao: equacao,
    campo_resultado: resultado,
  };

  // Método para recuperar as informações do banco de dados.
  factory Equacao.fromMap(Map<String, dynamic> map) => Equacao(
    id: map[campo_id] as int?,
    equacao: map[campo_equacao] as String,
    resultado: map[campo_resultado] as int,
  );
}

class EquacaoDao {
  final dbProvider = DatabaseProvider.instance;

  // Função para salvar ou atualizar uma equação no banco de dados.
  Future<bool> salvar(Equacao equacao) async {
    final db = await dbProvider.database;
    if (equacao.id == null) {
      // Inserir uma nova equação.
      equacao.id = await db.insert(Equacao.nome_tabela, equacao.toMap());
      return true;
    } else {
      // Atualizar uma equação existente.
      final registrosAtualizados = await db.update(
        Equacao.nome_tabela,
        equacao.toMap(),
        where: '${Equacao.campo_id} = ?',
        whereArgs: [equacao.id],
      );
      return registrosAtualizados > 0;
    }
  }

  // Função para excluir uma equação do banco de dados.
  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(
      Equacao.nome_tabela,
      where: '${Equacao.campo_id} = ?',
      whereArgs: [id],
    );
    return removerRegistro > 0;
  }

  // Função para listar todas as equações do banco de dados.
  Future<List<Equacao>> listarEquacoes() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> equacoes = await db.query(Equacao.nome_tabela);
    return equacoes.map((e) => Equacao.fromMap(e)).toList();
  }
}

class DatabaseProvider {
  static const _dbName = 'cadastro_equacoes.db';
  static const _dbVersion = 1;

  DatabaseProvider._(); // Construtor privado para evitar instâncias acidentais.
  static final DatabaseProvider instance = DatabaseProvider._();

  late Database _database;

  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      return await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, _dbName);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Equacao.nome_tabela} (
        ${Equacao.campo_id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Equacao.campo_equacao} TEXT NOT NULL,
        ${Equacao.campo_resultado} INTEGER NOT NULL
      )
    ''');
  }

  
}
