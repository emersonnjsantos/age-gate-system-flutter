import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinner de carregamento
              LoadingAnimationWidget.staggeredDotsWave(
                color: const Color(0xFF0a7ea4),
                size: 60,
              ),
              const SizedBox(height: 40),

              // Mensagem principal
              const Text(
                'Validando seus dados...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF11181c),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Submensagem
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Isso pode levar alguns segundos. Por favor, aguarde.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF687076),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Indicador de progresso com passos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    _buildProgressStep(
                      title: 'Validando CPF',
                      isComplete: true,
                    ),
                    const SizedBox(height: 12),
                    _buildProgressStep(
                      title: 'Analisando documento',
                      isComplete: true,
                    ),
                    const SizedBox(height: 12),
                    _buildProgressStep(
                      title: 'Verificando biometria',
                      isComplete: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required String title,
    required bool isComplete,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isComplete
                ? const Color(0xFF22c55e)
                : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(6),
          ),
          child: isComplete
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isComplete
                  ? const Color(0xFF22c55e)
                  : const Color(0xFF687076),
              fontWeight: isComplete ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
