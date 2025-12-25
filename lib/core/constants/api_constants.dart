/// Constantes da API NASA APOD
///
/// Configurações de conexão e endpoints da API.
class ApiConstants {
  ApiConstants._();

  /// URL base da API NASA
  static const String baseUrl = 'https://api.nasa.gov/planetary';

  /// Endpoint APOD
  static const String apodEndpoint = '/apod';

  /// API Key da NASA - carregada via --dart-define
  /// Obtenha em: https://api.nasa.gov/
  ///
  /// DEMO_KEY tem limite de 30 req/hora e 50 req/dia
  /// API Key própria: 1000 req/hora
  ///
  /// Para executar: flutter run --dart-define=NASA_API_KEY=sua_chave_aqui
  static const String apiKey = String.fromEnvironment(
    'NASA_API_KEY',
    defaultValue: 'DEMO_KEY',
  );

  /// URL do site da NASA
  static const String nasaWebsite = 'https://www.nasa.gov/';

  /// Timeout de conexão em segundos
  static const int connectionTimeout = 30;

  /// Timeout de recebimento em segundos
  static const int receiveTimeout = 30;

  /// Data mínima disponível na API APOD (16 de junho de 1995)
  static final DateTime minDate = DateTime(1995, 6, 16);

  /// Número máximo de dias para consulta por período
  static const int maxPeriodDays = 30;

  /// Número máximo de imagens aleatórias por requisição
  static const int maxRandomCount = 10;
}
