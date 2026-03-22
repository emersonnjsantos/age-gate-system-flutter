import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/age_verification_provider.dart';

class SuccessScreen extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final VoidCallback onHomePressed;

  const SuccessScreen({
    super.key,
    required this.onContinuePressed,
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Ícone de sucesso
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22c55e),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Título
                    const Text(
                      'Validação Aprovada',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11181c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Mensagem
                    Text(
                      response?.message ?? 'Você atende aos requisitos de idade',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF687076),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Informações de validação
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFBBF7D0),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            label: 'Status',
                            value: 'Validado',
                            icon: Icons.verified,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            label: 'Idade',
                            value: '${response?.age ?? '--'} anos',
                            icon: Icons.cake,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            label: 'ID de Validação',
                            value: response?.validationId ?? '--',
                            icon: Icons.fingerprint,
                            isCode: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Informação sobre conformidade
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFBFDBFE),
                          width: 1,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conformidade Lei ECA Digital',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0a7ea4),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Você confirmou que é maior de 18 anos e atende aos requisitos de acesso conforme Lei nº 15.211/2025.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0a7ea4),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Botão Continuar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onContinuePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22c55e),
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
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botão Voltar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: onHomePressed,
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
                        ).copyWith(
                          overlayColor: WidgetStatePropertyAll(
                            const Color(0xFF0a7ea4).withOpacity(0.1),
                          ),
                        ),
                        child: const Text(
                          'Voltar ao Início',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    bool isCode = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF22c55e),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF687076),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isCode ? 10 : 14,
                  color: const Color(0xFF11181c),
                  fontWeight: FontWeight.bold,
                  fontFamily: isCode ? 'monospace' : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
