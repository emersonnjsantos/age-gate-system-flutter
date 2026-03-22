import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/age_verification_provider.dart';
import '../utils/cpf_formatter.dart';

class CPFInputScreen extends StatefulWidget {
  final VoidCallback onNextPressed;
  final VoidCallback? onBackPressed;

  const CPFInputScreen({
    super.key,
    required this.onNextPressed,
    this.onBackPressed,
  });

  @override
  State<CPFInputScreen> createState() => _CPFInputScreenState();
}

class _CPFInputScreenState extends State<CPFInputScreen> {
  late TextEditingController _cpfController;
  bool _isValidCPF = false;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController();
    _cpfController.addListener(_validateCPF);
  }

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void _validateCPF() {
    final cpf = _cpfController.text;
    final isValid = CPFFormatter.isValidCPF(cpf);
    
    setState(() {
      _isValidCPF = isValid;
    });

    if (isValid) {
      context.read<AgeVerificationProvider>().setCPF(cpf);
    }
  }

  void _handleNextPressed() {
    if (_isValidCPF) {
      widget.onNextPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF11181c)),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            }
          },
        ),
        title: const Text(
          'Verificação de Idade',
          style: TextStyle(
            color: Color(0xFF11181c),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de progresso
                _buildProgressIndicator(step: 1),
                const SizedBox(height: 40),

                // Título
                const Text(
                  'Qual é o seu CPF?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11181c),
                  ),
                ),
                const SizedBox(height: 8),

                // Descrição
                const Text(
                  'Digite seu CPF para iniciar o processo de validação',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF687076),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Campo de entrada de CPF
                TextField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  decoration: InputDecoration(
                    hintText: '000.000.000-00',
                    hintStyle: const TextStyle(color: Color(0xFFBCC0C5)),
                    prefixIcon: const Icon(
                      Icons.credit_card,
                      color: Color(0xFF0a7ea4),
                    ),
                    suffixIcon: _isValidCPF
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF22c55e),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0a7ea4),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (value) {
                    final formatted = CPFFormatter.formatCPF(value);
                    if (formatted != _cpfController.text) {
                      _cpfController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),

                // Mensagem de validação
                if (_cpfController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _isValidCPF ? Icons.check_circle : Icons.error,
                          color: _isValidCPF
                              ? const Color(0xFF22c55e)
                              : const Color(0xFFEF4444),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isValidCPF
                              ? 'CPF válido'
                              : 'CPF inválido',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isValidCPF
                                ? const Color(0xFF22c55e)
                                : const Color(0xFFEF4444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),

                // Informação de segurança
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFBFDBFE),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lock,
                        color: Color(0xFF0a7ea4),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seus dados são criptografados e não serão armazenados',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0a7ea4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Botão Próximo
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isValidCPF ? _handleNextPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0a7ea4),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFBCC0C5),
                      disabledForegroundColor: Colors.white70,
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
                      'Próximo',
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

  Widget _buildProgressIndicator({required int step}) {
    return Row(
      children: [
        _buildProgressStep(number: 1, isActive: step >= 1, isCompleted: step > 1),
        Container(
          height: 2,
          width: 40,
          color: step > 1 ? const Color(0xFF0a7ea4) : const Color(0xFFE5E7EB),
        ),
        _buildProgressStep(number: 2, isActive: step >= 2, isCompleted: step > 2),
        Container(
          height: 2,
          width: 40,
          color: step > 2 ? const Color(0xFF0a7ea4) : const Color(0xFFE5E7EB),
        ),
        _buildProgressStep(number: 3, isActive: step >= 3, isCompleted: step > 3),
      ],
    );
  }

  Widget _buildProgressStep({
    required int number,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive || isCompleted
            ? const Color(0xFF0a7ea4)
            : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
