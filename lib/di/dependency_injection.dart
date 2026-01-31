import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_constants.dart';
import '../data/datasources/local/apod_local_datasource.dart';
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
import '../services/cache_service.dart';
import '../services/favorites_sync_service.dart';

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
  late final ApodLocalDataSource _apodLocalDataSource;
  late final FavoritesLocalDataSource _favoritesLocalDataSource;
  late final SettingsLocalDataSource _settingsLocalDataSource;

  // Repositórios
  late final ApodRepository _apodRepository;
  late final FavoritesRepository _favoritesRepository;
  late final SettingsRepository _settingsRepository;

  bool _isInitialized = false;

  /// Inicializa todas as dependências
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ [DI] Já inicializado, ignorando...');
      return;
    }

    debugPrint('🔧 [DI] Iniciando injeção de dependências...');

    try {
      // SharedPreferences
      debugPrint('💾 [DI] Inicializando SharedPreferences...');
      _sharedPreferences = await SharedPreferences.getInstance();
      debugPrint('✅ [DI] SharedPreferences OK');

      // Dio com configurações
      debugPrint('🌐 [DI] Configurando Dio HTTP client...');
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
      debugPrint('✅ [DI] Dio configurado - BaseURL: ${ApiConstants.baseUrl}');

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
      debugPrint('📡 [DI] Criando datasources...');
      _apodRemoteDataSource = ApodRemoteDataSourceImpl(dio: _dio);
      debugPrint('✅ [DI] ApodRemoteDataSource OK');

      _apodLocalDataSource = ApodLocalDataSourceImpl(
        databaseHelper: DatabaseHelper.instance,
      );
      debugPrint('✅ [DI] ApodLocalDataSource OK');
      
      _favoritesLocalDataSource = FavoritesLocalDataSourceImpl(
        databaseHelper: DatabaseHelper.instance,
      );
      debugPrint('✅ [DI] FavoritesLocalDataSource OK');
      
      _settingsLocalDataSource = SettingsLocalDataSourceImpl(
        sharedPreferences: _sharedPreferences,
      );
      debugPrint('✅ [DI] SettingsLocalDataSource OK');

      // Repositórios
      debugPrint('📦 [DI] Criando repositórios...');
      _apodRepository = ApodRepositoryImpl(
        remoteDataSource: _apodRemoteDataSource,
        localDataSource: _apodLocalDataSource,
      );
      debugPrint('✅ [DI] ApodRepository OK (com cache local)');
      
      _favoritesRepository = FavoritesRepositoryImpl(
        localDataSource: _favoritesLocalDataSource,
      );
      debugPrint('✅ [DI] FavoritesRepository OK');
      
      _settingsRepository = SettingsRepositoryImpl(
        localDataSource: _settingsLocalDataSource,
      );
      debugPrint('✅ [DI] SettingsRepository OK');

      // Inicializa o serviço de sincronização de favoritos
      debugPrint('🔄 [DI] Inicializando FavoritesSyncService...');
      await _initializeFavoritesSyncService();
      debugPrint('✅ [DI] FavoritesSyncService OK');

      // Inicializa o serviço de cache
      debugPrint('💾 [DI] Inicializando CacheService...');
      _initializeCacheService();
      debugPrint('✅ [DI] CacheService OK');

      _isInitialized = true;
      debugPrint('🎉 [DI] Injeção de dependências concluída com sucesso!');
    } catch (e, stack) {
      debugPrint('❌ [DI] ERRO na inicialização: $e');
      debugPrint('❌ [DI] Stack trace: $stack');
      rethrow;
    }
  }
  
  /// Inicializa o serviço de sincronização de favoritos
  Future<void> _initializeFavoritesSyncService() async {
    try {
      final result = await _favoritesRepository.getAllFavorites();
      result.fold(
        onSuccess: (favorites) {
          final favoriteDates = favorites.map((f) => f.apod.date).toSet();
          FavoritesSyncService.instance.initialize(favoriteDates);
          debugPrint('✅ [DI] Favoritos carregados: ${favoriteDates.length} itens');
        },
        onFailure: (failure) {
          debugPrint('⚠️ [DI] Falha ao carregar favoritos: $failure');
          // Se falhar, inicializa com conjunto vazio
          FavoritesSyncService.instance.initialize({});
        },
      );
    } catch (e, stack) {
      debugPrint('❌ [DI] Erro ao inicializar FavoritesSyncService: $e');
      debugPrint('❌ [DI] Stack: $stack');
      // Continua com conjunto vazio
      FavoritesSyncService.instance.initialize({});
    }
  }

  /// Inicializa o serviço de cache
  void _initializeCacheService() {
    CacheService.instance.initialize(
      localDataSource: _apodLocalDataSource,
      remoteDataSource: _apodRemoteDataSource,
      prefs: _sharedPreferences,
    );

    // Inicia pré-carregamento em background após inicialização
    Future.delayed(const Duration(seconds: 5), () {
      debugPrint('🚀 [DI] Iniciando pré-carregamento de APODs em background...');
      CacheService.instance.preloadRecentApods().then((count) {
        if (count > 0) {
          debugPrint('✅ [DI] Pré-carregamento concluído: $count novos APODs');
        }
      }).catchError((e) {
        debugPrint('⚠️ [DI] Erro no pré-carregamento: $e');
      });
    });
  }

  // Getters para acesso às dependências
  SharedPreferences get sharedPreferences => _sharedPreferences;
  Dio get dio => _dio;
  
  ApodRemoteDataSource get apodRemoteDataSource => _apodRemoteDataSource;
  ApodLocalDataSource get apodLocalDataSource => _apodLocalDataSource;
  FavoritesLocalDataSource get favoritesLocalDataSource => _favoritesLocalDataSource;
  SettingsLocalDataSource get settingsLocalDataSource => _settingsLocalDataSource;
  
  ApodRepository get apodRepository => _apodRepository;
  FavoritesRepository get favoritesRepository => _favoritesRepository;
  SettingsRepository get settingsRepository => _settingsRepository;
}

/// Acesso global ao container de DI
DependencyInjection get di => DependencyInjection.instance;
