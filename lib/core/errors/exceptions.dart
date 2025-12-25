/// Classes de exceções do aplicativo
///
/// Exceções são lançadas na camada de dados e convertidas
/// em Failures na camada de domínio.
abstract class AppException implements Exception {
  const AppException({this.message, this.code});

  final String? message;
  final String? code;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Exceção de servidor
class ServerException extends AppException {
  const ServerException({super.message, super.code, this.statusCode});

  final int? statusCode;
}

/// Exceção de rede
class NetworkException extends AppException {
  const NetworkException({super.message = 'Sem conexão com a internet'});
}

/// Exceção de cache
class CacheException extends AppException {
  const CacheException({super.message = 'Erro ao acessar cache'});
}

/// Exceção de banco de dados
class DatabaseException extends AppException {
  const DatabaseException({super.message = 'Erro no banco de dados'});
}

/// Exceção de validação
class ValidationException extends AppException {
  const ValidationException({super.message = 'Dados inválidos'});
}

/// Exceção de API Key
class ApiKeyException extends AppException {
  const ApiKeyException({super.message = 'API Key inválida'});
}

/// Exceção de rate limit
class RateLimitException extends AppException {
  const RateLimitException({super.message = 'Limite de requisições excedido'});
}

/// Exceção de data inválida
class InvalidDateException extends AppException {
  const InvalidDateException({super.message = 'Data inválida'});
}
