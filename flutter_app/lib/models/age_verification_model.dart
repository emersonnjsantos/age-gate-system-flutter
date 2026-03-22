/// Modelo para requisição de validação de idade
class AgeVerificationRequest {
  final String cpf;
  final String documentPhoto; // Base64 encoded
  final String documentType;

  AgeVerificationRequest({
    required this.cpf,
    required this.documentPhoto,
    required this.documentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'document_photo': documentPhoto,
      'document_type': documentType,
    };
  }
}

/// Modelo para resposta de validação de idade
class AgeVerificationResponse {
  final bool valid;
  final int? age;
  final String? dateOfBirth;
  final bool isMinor;
  final String? reason;
  final String validationId;
  final String message;

  AgeVerificationResponse({
    required this.valid,
    this.age,
    this.dateOfBirth,
    required this.isMinor,
    this.reason,
    required this.validationId,
    required this.message,
  });

  factory AgeVerificationResponse.fromJson(Map<String, dynamic> json) {
    return AgeVerificationResponse(
      valid: json['valid'] ?? false,
      age: json['age'],
      dateOfBirth: json['date_of_birth'],
      isMinor: json['is_minor'] ?? false,
      reason: json['reason'],
      validationId: json['validation_id'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'age': age,
      'date_of_birth': dateOfBirth,
      'is_minor': isMinor,
      'reason': reason,
      'validation_id': validationId,
      'message': message,
    };
  }
}

/// Estados possíveis da validação
enum AgeVerificationState {
  initial,
  loading,
  success,
  failure,
  minorWithoutConsent,
  error,
}
