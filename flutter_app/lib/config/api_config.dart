/// Configuração da API do Age Gate
class ApiConfig {
  // URL base da API (Google Cloud Run)
  static const String baseUrl = 'https://age-gate-api-685297311649.us-east1.run.app';
  
  // Endpoints
  static const String validateAgeEndpoint = '/validate-age';
  static const String healthEndpoint = '/health';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  /// Obter URL completa do endpoint
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
