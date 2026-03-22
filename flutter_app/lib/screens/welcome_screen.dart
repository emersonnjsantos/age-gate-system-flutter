import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStartPressed;

  const WelcomeScreen({
    super.key,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo/Ícone
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0a7ea4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 40),

                // Título
                const Text(
                  'Verificação de Idade',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11181c),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Descrição
                const Text(
                  'Confirme sua identidade para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF687076),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Passos do processo
                _buildStepCard(
                  number: '1',
                  title: 'Informe seu CPF',
                  description: 'Digite seu CPF para iniciar o processo',
                ),
                const SizedBox(height: 16),
                _buildStepCard(
                  number: '2',
                  title: 'Capture o Documento',
                  description: 'Fotografe o verso do seu documento/CPF',
                ),
                const SizedBox(height: 16),
                _buildStepCard(
                  number: '3',
                  title: 'Validação Automática',
                  description: 'Seus dados serão validados em tempo real',
                ),
                const SizedBox(height: 50),

                // Informação sobre Lei ECA Digital
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lei nº 15.211/2025 (ECA Digital)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11181c),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Este aplicativo implementa verificação de idade em conformidade com a legislação de proteção de menores na internet.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF687076),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onStartPressed,
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
                      'Começar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0a7ea4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11181c),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF687076),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
