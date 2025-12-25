import '../errors/failures.dart';

/// Classe Result para tratamento de sucesso/erro
///
/// Implementação do padrão Either simplificado para
/// retornar ou um valor de sucesso ou uma falha.
sealed class Result<T> {
  const Result();

  /// Factory para criar um resultado de sucesso
  static Success<T> success<T>(T value) => Success<T>(value);

  /// Factory para criar um resultado de erro
  static Error<T> error<T>(Failure failure) => Error<T>(failure);

  /// Verifica se é sucesso
  bool get isSuccess => this is Success<T>;

  /// Verifica se é falha
  bool get isFailure => this is Error<T>;

  /// Obtém o valor se for sucesso, ou null se for falha
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Error<T>() => null,
      };

  /// Obtém a falha se for erro, ou null se for sucesso
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  /// Executa uma função baseada no resultado
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final value) => onSuccess(value),
        Error<T>(:final failure) => onFailure(failure),
      };

  /// Transforma o valor de sucesso
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success<T>(:final value) => Success(transform(value)),
        Error<T>(:final failure) => Error(failure),
      };

  /// Transforma o valor de sucesso com um Result
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        Success<T>(:final value) => transform(value),
        Error<T>(:final failure) => Error(failure),
      };
}

/// Representa um resultado de sucesso
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Representa um resultado de erro
final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  String toString() => 'Error($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;
}
