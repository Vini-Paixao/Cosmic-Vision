import 'package:flutter/foundation.dart';

/// Estado base para ViewModels
enum ViewState { initial, loading, success, error }

/// ViewModel base com gerenciamento de estado comum
abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.initial;
  String? _errorMessage;

  /// Estado atual do ViewModel
  ViewState get state => _state;

  /// Mensagem de erro (quando state == error)
  String? get errorMessage => _errorMessage;

  /// Indica se está carregando
  bool get isLoading => _state == ViewState.loading;

  /// Indica se houve sucesso
  bool get isSuccess => _state == ViewState.success;

  /// Indica se houve erro
  bool get isError => _state == ViewState.error;

  /// Indica se é o estado inicial
  bool get isInitial => _state == ViewState.initial;

  /// Atualiza o estado para loading
  @protected
  void setLoading() {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  /// Atualiza o estado para sucesso
  @protected
  void setSuccess() {
    _state = ViewState.success;
    _errorMessage = null;
    notifyListeners();
  }

  /// Atualiza o estado para erro
  @protected
  void setError(String message) {
    _state = ViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Reseta o estado para inicial
  @protected
  void resetState() {
    _state = ViewState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa a mensagem de erro sem mudar o estado
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
