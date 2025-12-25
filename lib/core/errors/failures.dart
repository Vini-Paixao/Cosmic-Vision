/// Classes de falhas do aplicativo
///
/// Seguindo o padrão de Clean Architecture para tratamento de erros.
abstract class Failure {
  const Failure({this.message, this.code});

  final String? message;
  final String? code;

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Falha de servidor (erro HTTP)
class ServerFailure extends Failure {
  const ServerFailure({super.message, super.code, this.statusCode});

  final int? statusCode;

  @override
  String toString() =>
      'ServerFailure(message: $message, code: $code, statusCode: $statusCode)';
}

/// Falha de conexão (sem internet)
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sem conexão com a internet'});
}

/// Falha de cache local
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Erro ao acessar dados locais'});
}

/// Falha de banco de dados
class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message = 'Erro no banco de dados'});
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Dados inválidos'});
}

/// Falha de permissão
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permissão negada'});
}

/// Falha desconhecida
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Erro desconhecido'});
}

/// Falha de API Key
class ApiKeyFailure extends Failure {
  const ApiKeyFailure({super.message = 'API Key inválida ou expirada'});
}

/// Falha de rate limit
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'Limite de requisições excedido. Tente novamente mais tarde.',
  });
}

/// Falha de data inválida
class InvalidDateFailure extends Failure {
  const InvalidDateFailure({super.message = 'Data inválida ou fora do intervalo permitido'});
}
