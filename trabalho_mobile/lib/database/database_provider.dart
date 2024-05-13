import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/equacao.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_equacoes.db'; // Nome do banco de dados.
  static const _dbVersion = 1; // Versão do banco de dados.

  DatabaseProvider._init(); // Inicializador da classe.
  static final DatabaseProvider instance = DatabaseProvider._init(); // Cria uma instância de inicialização para controlar o banco.

  late Database _database;

  // Função para verificar se existe um banco de dados.
  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      return await _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    // Caminho do diretório do banco de dados.
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, _dbName); // Concatenação do caminho do diretório com o nome do banco.
    return await openDatabase(
      dbPath, // Caminho do banco de dados.
      version: _dbVersion, // Versão do banco de dados.
      onCreate: _onCreate, // Quanto o banco de dados foi criado (com a versão inicial do banco) - Primeira execução.
      onUpgrade: _onUpgrade, // Quanto atualiza o banco de dados.
    );
  }

  // Função para criar as tabelas do banco de dados.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${Equacao.nome_tabela} (
      ${Equacao.campo_id} INTEGER PRIMARY KEY, 
      ${Equacao.campo_equacao} TEXT NOT NULL,
      ${Equacao.campo_resultado} INTEGER NOT NULL
      );
      ''',
    );
  }

  // Função para atualizar o banco de dados.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Caso haja alguma atualização no futuro, você pode adicionar o código de migração aqui.
  }

  // Função para fechar a conexão do banco de dados junto com o aplicativo.
  Future<void> close() async {
    if (_database.isOpen) {
      await _database.close();
    }
  }
}
