import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/api_config.dart';
import '../models/age_verification_model.dart';

class ApiService {
  late Dio _dio;
  final Logger _logger = Logger();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectionTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adicionar interceptor para logging
    _dio.interceptors.add(
      LoggingInterceptor(_logger),
    );
  }

  /// Validar idade através da API
  Future<AgeVerificationResponse> validateAge(
    AgeVerificationRequest request,
  ) async {
    try {
      _logger.i('Iniciando validação de idade para CPF: ${request.cpf}');

      final response = await _dio.post(
        ApiConfig.validateAgeEndpoint,
        data: request.toJson(),
      );

      _logger.i('Resposta da validação recebida com status: ${response.statusCode}');

      final result = AgeVerificationResponse.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      _logger.e('Erro ao validar idade: ${e.message}');
      
      // Tratar resposta com erro HTTP
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          return AgeVerificationResponse.fromJson(errorData);
        }
      }

      throw Exception('Erro ao conectar com o servidor: ${e.message}');
    } catch (e) {
      _logger.e('Erro inesperado: $e');
      throw Exception('Erro inesperado: $e');
    }
  }

  /// Verificar saúde da API
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get(ApiConfig.healthEndpoint);
      return response.statusCode == 200;
    } catch (e) {
      _logger.e('Erro ao verificar saúde da API: $e');
      return false;
    }
  }
}

/// Interceptor para logging de requisições e respostas
class LoggingInterceptor extends Interceptor {
  final Logger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('REQUEST: ${options.method} ${options.path}');
    logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      logger.d('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    logger.d('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('ERROR: ${err.message}');
    logger.e('Status: ${err.response?.statusCode}');
    if (err.response?.data != null) {
      logger.e('Error Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
