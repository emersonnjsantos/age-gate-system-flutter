import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/age_verification_model.dart';
import 'providers/age_verification_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/cpf_input_screen.dart';
import 'screens/document_capture_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/success_screen.dart';
import 'screens/failure_screen.dart';

void main() {
  runApp(const AgeGateApp());
}

class AgeGateApp extends StatelessWidget {
  const AgeGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgeVerificationProvider()),
      ],
      child: MaterialApp(
        title: 'Age Gate - Verificação de Idade',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0a7ea4),
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0a7ea4),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const AgeGateHome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AgeGateHome extends StatefulWidget {
  const AgeGateHome({super.key});

  @override
  State<AgeGateHome> createState() => _AgeGateHomeState();
}

class _AgeGateHomeState extends State<AgeGateHome> {
  int _currentStep = 0; // 0: Welcome, 1: CPF, 2: Document, 3: Loading, 4: Result

  @override
  Widget build(BuildContext context) {
    return Consumer<AgeVerificationProvider>(
      builder: (context, provider, _) {
        // Determinar qual tela mostrar baseado no estado
        if (_currentStep == 0) {
          return WelcomeScreen(
            onStartPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
          );
        } else if (_currentStep == 1) {
          return CPFInputScreen(
            onNextPressed: () {
              setState(() {
                _currentStep = 2;
              });
            },
            onBackPressed: () {
              setState(() {
                _currentStep = 0;
              });
            },
          );
        } else if (_currentStep == 2) {
          return DocumentCaptureScreen(
            onValidatePressed: () async {
              setState(() {
                _currentStep = 3;
              });

              // Iniciar validação
              await provider.validateAge();

              // Aguardar um pouco para mostrar loading
              await Future.delayed(const Duration(seconds: 2));

              // Navegar para resultado
              if (mounted) {
                setState(() {
                  _currentStep = 4;
                });
              }
            },
            onBackPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
          );
        } else if (_currentStep == 3) {
          return const LoadingScreen();
        } else if (_currentStep == 4) {
          // Mostrar resultado baseado no estado
          if (provider.state == AgeVerificationState.success) {
            return SuccessScreen(
              onContinuePressed: () {
                // Aqui você pode navegar para a próxima tela do seu app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Acesso concedido! Bem-vindo ao aplicativo.'),
                    backgroundColor: Color(0xFF22c55e),
                  ),
                );
              },
              onHomePressed: () {
                provider.reset();
                setState(() {
                  _currentStep = 0;
                });
              },
            );
          } else if (provider.state == AgeVerificationState.minorWithoutConsent ||
              provider.state == AgeVerificationState.failure) {
            return FailureScreen(
              onRetryPressed: () {
                provider.retry();
                setState(() {
                  _currentStep = 1;
                });
              },
              onHomePressed: () {
                provider.reset();
                setState(() {
                  _currentStep = 0;
                });
              },
            );
          } else if (provider.state == AgeVerificationState.error) {
            return _buildErrorScreen(
              provider.errorMessage ?? 'Erro desconhecido',
              () {
                provider.retry();
                setState(() {
                  _currentStep = 1;
                });
              },
            );
          }
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildErrorScreen(String errorMessage, VoidCallback onRetry) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Erro na Validação',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11181c),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF687076),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0a7ea4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tentar Novamente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
}
