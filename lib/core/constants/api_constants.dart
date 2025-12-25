/// Constantes da API NASA APOD
///
/// Configurações de conexão e endpoints da API.
class ApiConstants {
  ApiConstants._();

  /// URL base da API NASA
  static const String baseUrl = 'https://api.nasa.gov/planetary';

  /// Endpoint APOD
  static const String apodEndpoint = '/apod';

  /// API Key da NASA (substituir pela sua chave)
  /// Obtenha em: https://api.nasa.gov/
  ///
  /// DEMO_KEY tem limite de 30 req/hora e 50 req/dia
  /// API Key própria: 1000 req/hora
  static const String apiKey = 'dMTbAJJ8UgDsExFy6YgEknRNauf5KIkJe6ycj0GK';

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
