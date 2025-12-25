import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_constants.dart';
import '../data/datasources/local/database_helper.dart';
import '../data/datasources/local/favorites_local_datasource.dart';
import '../data/datasources/local/settings_local_datasource.dart';
import '../data/datasources/remote/apod_remote_datasource.dart';
import '../data/repositories/apod_repository_impl.dart';
import '../data/repositories/favorites_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/apod_repository.dart';
import '../domain/repositories/favorites_repository.dart';
import '../domain/repositories/settings_repository.dart';

/// Container de injeção de dependências
class DependencyInjection {
  DependencyInjection._();

  static final DependencyInjection _instance = DependencyInjection._();
  static DependencyInjection get instance => _instance;

  // Dependências externas
  late final SharedPreferences _sharedPreferences;
  late final Dio _dio;

  // Datasources
  late final ApodRemoteDataSource _apodRemoteDataSource;
  late final FavoritesLocalDataSource _favoritesLocalDataSource;
  late final SettingsLocalDataSource _settingsLocalDataSource;

  // Repositórios
  late final ApodRepository _apodRepository;
  late final FavoritesRepository _favoritesRepository;
  late final SettingsRepository _settingsRepository;

  bool _isInitialized = false;

  /// Inicializa todas as dependências
  Future<void> initialize() async {
    if (_isInitialized) return;

    // SharedPreferences
    _sharedPreferences = await SharedPreferences.getInstance();

    // Dio com configurações
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptors para logging (apenas em debug)
    assert(() {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint('🌐 $object'),
        ),
      );
      return true;
    }());

    // Datasources
    _apodRemoteDataSource = ApodRemoteDataSourceImpl(dio: _dio);
    _favoritesLocalDataSource = FavoritesLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    _settingsLocalDataSource = SettingsLocalDataSourceImpl(
      sharedPreferences: _sharedPreferences,
    );

    // Repositórios
    _apodRepository = ApodRepositoryImpl(
      remoteDataSource: _apodRemoteDataSource,
    );
    _favoritesRepository = FavoritesRepositoryImpl(
      localDataSource: _favoritesLocalDataSource,
    );
    _settingsRepository = SettingsRepositoryImpl(
      localDataSource: _settingsLocalDataSource,
    );

    _isInitialized = true;
  }

  // Getters para acesso às dependências
  SharedPreferences get sharedPreferences => _sharedPreferences;
  Dio get dio => _dio;
  
  ApodRemoteDataSource get apodRemoteDataSource => _apodRemoteDataSource;
  FavoritesLocalDataSource get favoritesLocalDataSource => _favoritesLocalDataSource;
  SettingsLocalDataSource get settingsLocalDataSource => _settingsLocalDataSource;
  
  ApodRepository get apodRepository => _apodRepository;
  FavoritesRepository get favoritesRepository => _favoritesRepository;
  SettingsRepository get settingsRepository => _settingsRepository;
}

/// Acesso global ao container de DI
DependencyInjection get di => DependencyInjection.instance;
