// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';

/// Helper para gerenciamento do banco SQLite
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  /// Obtém a instância do banco de dados
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    Logger.info('Inicializando banco de dados SQLite');

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Cria as tabelas do banco
  Future<void> _onCreate(Database db, int version) async {
    Logger.info('Criando tabelas do banco de dados');

    // Tabela de favoritos
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        apod_date TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        explanation TEXT NOT NULL,
        url TEXT NOT NULL,
        hdurl TEXT,
        media_type TEXT NOT NULL,
        copyright TEXT,
        thumbnail_url TEXT,
        favorited_at TEXT NOT NULL
      )
    ''');

    // Índice para busca por data
    await db.execute('''
      CREATE INDEX idx_favorites_apod_date ON favorites(apod_date)
    ''');

    // Índice para busca por título
    await db.execute('''
      CREATE INDEX idx_favorites_title ON favorites(title)
    ''');

    // Tabela de cache de APODs
    await _createApodCacheTable(db);

    Logger.info('Tabelas criadas com sucesso');
  }

  /// Cria a tabela de cache de APODs
  Future<void> _createApodCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE apod_cache (
        date TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        explanation TEXT NOT NULL,
        url TEXT NOT NULL,
        hdurl TEXT,
        media_type TEXT NOT NULL,
        copyright TEXT,
        thumbnail_url TEXT,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');

    // Índice para limpeza de cache expirado
    await db.execute('''
      CREATE INDEX idx_apod_cache_expires ON apod_cache(expires_at)
    ''');

    // Índice para busca por data de cache
    await db.execute('''
      CREATE INDEX idx_apod_cache_cached_at ON apod_cache(cached_at)
    ''');

    Logger.info('Tabela apod_cache criada com sucesso');
  }

  /// Atualiza o banco para novas versões
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Logger.info('Atualizando banco de dados de v$oldVersion para v$newVersion');

    // Migração da versão 1 para 2: adiciona tabela apod_cache
    if (oldVersion < 2) {
      Logger.info('Migrando para v2: criando tabela apod_cache');
      await _createApodCacheTable(db);
    }
  }

  /// Fecha o banco de dados
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
      Logger.info('Banco de dados fechado');
    }
  }

  /// Limpa todo o banco de dados
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('favorites');
    Logger.info('Banco de dados limpo');
  }
}
