/// Utilitário para formatação e validação de CPF
class CPFFormatter {
  /// Formatar CPF com máscara (000.000.000-00)
  static String formatCPF(String cpf) {
    // Remover caracteres não numéricos
    final cleanCPF = cpf.replaceAll(RegExp(r'\D'), '');

    // Limitar a 11 dígitos
    final truncated = cleanCPF.substring(0, cleanCPF.length > 11 ? 11 : cleanCPF.length);

    // Aplicar máscara
    if (truncated.isEmpty) {
      return '';
    } else if (truncated.length <= 3) {
      return truncated;
    } else if (truncated.length <= 6) {
      return '${truncated.substring(0, 3)}.${truncated.substring(3)}';
    } else if (truncated.length <= 9) {
      return '${truncated.substring(0, 3)}.${truncated.substring(3, 6)}.${truncated.substring(6)}';
    } else {
      return '${truncated.substring(0, 3)}.${truncated.substring(3, 6)}.${truncated.substring(6, 9)}-${truncated.substring(9)}';
    }
  }

  /// Remover formatação do CPF
  static String removeCPFFormatting(String cpf) {
    return cpf.replaceAll(RegExp(r'\D'), '');
  }

  /// Validar CPF (verificar dígitos verificadores)
  static bool isValidCPF(String cpf) {
    final cleanCPF = removeCPFFormatting(cpf);

    // Verificar comprimento
    if (cleanCPF.length != 11) {
      return false;
    }

    // Verificar se todos os dígitos são iguais (CPF inválido)
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanCPF)) {
      return false;
    }

    // Validar primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanCPF[i]) * (10 - i);
    }
    int remainder = sum % 11;
    int firstDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(cleanCPF[9]) != firstDigit) {
      return false;
    }

    // Validar segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanCPF[i]) * (11 - i);
    }
    remainder = sum % 11;
    int secondDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(cleanCPF[10]) != secondDigit) {
      return false;
    }

    return true;
  }

  /// Obter CPF sem formatação para envio à API
  static String getCPFForAPI(String cpf) {
    return removeCPFFormatting(cpf);
  }
}
