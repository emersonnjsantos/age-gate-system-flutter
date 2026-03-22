import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

class ImageService {
  final Logger _logger = Logger();

  /// Converter arquivo de imagem para Base64
  Future<String> imageToBase64(String imagePath) async {
    try {
      _logger.i('Convertendo imagem para Base64: $imagePath');
      
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Arquivo de imagem não encontrado: $imagePath');
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      
      _logger.i('Imagem convertida com sucesso. Tamanho: ${base64String.length} caracteres');
      return base64String;
    } catch (e) {
      _logger.e('Erro ao converter imagem para Base64: $e');
      throw Exception('Erro ao converter imagem: $e');
    }
  }

  /// Comprimir imagem antes de enviar
  Future<String> compressAndConvertToBase64(String imagePath) async {
    try {
      _logger.i('Comprimindo imagem: $imagePath');
      
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Arquivo de imagem não encontrado: $imagePath');
      }

      // Ler imagem original
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Não foi possível decodificar a imagem');
      }

      // Redimensionar se necessário (máximo 1280 pixels de largura)
      img.Image resized = image;
      if (image.width > 1280) {
        resized = img.copyResize(
          image,
          width: 1280,
          height: (image.height * 1280 ~/ image.width),
        );
      }

      // Comprimir para JPEG com qualidade 85%
      final compressedBytes = img.encodeJpg(resized, quality: 85);
      final base64String = base64Encode(compressedBytes);
      
      _logger.i('Imagem comprimida com sucesso. Tamanho original: ${bytes.length}, Comprimida: ${compressedBytes.length}');
      return base64String;
    } catch (e) {
      _logger.e('Erro ao comprimir imagem: $e');
      throw Exception('Erro ao comprimir imagem: $e');
    }
  }

  /// Validar se arquivo é uma imagem válida
  bool isValidImageFile(String filePath) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    final extension = filePath.toLowerCase().split('.').last;
    return validExtensions.contains('.$extension');
  }

  /// Obter tamanho do arquivo em MB
  Future<double> getFileSizeInMB(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      _logger.e('Erro ao obter tamanho do arquivo: $e');
      return 0;
    }
  }
}
