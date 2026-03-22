import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/age_verification_provider.dart';

class FailureScreen extends StatelessWidget {
  final VoidCallback onRetryPressed;
  final VoidCallback onHomePressed;

  const FailureScreen({
    super.key,
    required this.onRetryPressed,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Consumer<AgeVerificationProvider>(
              builder: (context, provider, _) {
                final response = provider.response;
                final isMinor = response?.isMinor ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Ícone de erro
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Título
                    const Text(
                      'Validação Não Aprovada',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11181c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Mensagem específica
                    Text(
                      isMinor
                          ? 'Você é menor de 18 anos'
                          : 'Os dados fornecidos não conferem',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF687076),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Detalhes da falha
                    if (isMinor)
                      _buildMinorContent()
                    else
                      _buildInvalidDataContent(response?.reason ?? ''),
                    const SizedBox(height: 40),

                    // Informação sobre conformidade
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFECACA),
                          width: 1,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lei nº 15.211/2025 (ECA Digital)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Este aplicativo implementa proteção de menores conforme legislação. Menores de idade requerem consentimento parental.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFDC2626),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Botão Tentar Novamente
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onRetryPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0a7ea4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 2,
                          splashFactory: InkRipple.splashFactory,
                        ).copyWith(
                          overlayColor: WidgetStatePropertyAll(
                            Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: const Text(
                          'Tentar Novamente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: onHomePressed,
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('Voltar ao Início'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF687076),
                          side: const BorderSide(
                            color: Color(0xFF687076),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          splashFactory: InkRipple.splashFactory,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ).copyWith(
                          overlayColor: WidgetStatePropertyAll(
                            const Color(0xFF687076).withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botão Contato de Suporte
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contato de suporte: support@age-gate.com'),
                              backgroundColor: Color(0xFF0a7ea4),
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline),
                        label: const Text('Contato de Suporte'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0a7ea4),
                          side: const BorderSide(
                            color: Color(0xFF0a7ea4),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          splashFactory: InkRipple.splashFactory,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ).copyWith(
                          overlayColor: WidgetStatePropertyAll(
                            const Color(0xFF0a7ea4).withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinorContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.family_restroom,
            color: Color(0xFFDC2626),
            size: 40,
          ),
          SizedBox(height: 16),
          Text(
            'Consentimento Parental Necessário',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF11181c),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Para continuar, é necessário o consentimento de um responsável legal. Entre em contato com nosso suporte para mais informações.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF687076),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidDataContent(String reason) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFDC2626),
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'Dados Não Conferem',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF11181c),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            reason.isNotEmpty
                ? 'Motivo: $reason'
                : 'Os dados do documento não correspondem aos dados do CPF informado.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF687076),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Verifique se os dados estão corretos e tente novamente.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF687076),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
