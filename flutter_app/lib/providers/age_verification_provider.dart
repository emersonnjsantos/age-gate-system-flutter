import 'package:flutter/material.dart';
import '../models/age_verification_model.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';

class AgeVerificationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();

  AgeVerificationState _state = AgeVerificationState.initial;
  AgeVerificationResponse? _response;
  String? _errorMessage;
  String? _selectedImagePath;
  String? _cpf;

  // Getters
  AgeVerificationState get state => _state;
  AgeVerificationResponse? get response => _response;
  String? get errorMessage => _errorMessage;
  String? get selectedImagePath => _selectedImagePath;
  String? get cpf => _cpf;

  /// Definir CPF
  void setCPF(String cpf) {
    _cpf = cpf;
    notifyListeners();
  }

  /// Definir caminho da imagem selecionada
  void setImagePath(String imagePath) {
    _selectedImagePath = imagePath;
    notifyListeners();
  }

  /// Limpar imagem selecionada
  void clearImage() {
    _selectedImagePath = null;
    notifyListeners();
  }

  /// Validar idade
  Future<void> validateAge() async {
    if (_cpf == null || _cpf!.isEmpty) {
      _state = AgeVerificationState.error;
      _errorMessage = 'CPF não informado';
      notifyListeners();
      return;
    }

    if (_selectedImagePath == null || _selectedImagePath!.isEmpty) {
      _state = AgeVerificationState.error;
      _errorMessage = 'Imagem do documento não selecionada';
      notifyListeners();
      return;
    }

    _state = AgeVerificationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Converter imagem para Base64
      final imageBase64 = await _imageService.compressAndConvertToBase64(
        _selectedImagePath!,
      );

      // Criar requisição
      final request = AgeVerificationRequest(
        cpf: _cpf!,
        documentPhoto: imageBase64,
        documentType: 'CPF',
      );

      // Enviar requisição
      final result = await _apiService.validateAge(request);
      _response = result;

      // Definir estado baseado na resposta
      if (result.valid) {
        _state = AgeVerificationState.success;
      } else if (result.isMinor) {
        _state = AgeVerificationState.minorWithoutConsent;
      } else {
        _state = AgeVerificationState.failure;
      }

      _errorMessage = null;
    } catch (e) {
      _state = AgeVerificationState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Resetar estado
  void reset() {
    _state = AgeVerificationState.initial;
    _response = null;
    _errorMessage = null;
    _selectedImagePath = null;
    _cpf = null;
    notifyListeners();
  }

  /// Tentar novamente
  void retry() {
    reset();
  }
}
