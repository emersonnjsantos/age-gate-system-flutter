import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/age_verification_provider.dart';

class DocumentCaptureScreen extends StatefulWidget {
  final VoidCallback onValidatePressed;
  final VoidCallback? onBackPressed;

  const DocumentCaptureScreen({
    super.key,
    required this.onValidatePressed,
    this.onBackPressed,
  });

  @override
  State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
}

class _DocumentCaptureScreenState extends State<DocumentCaptureScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _captureImage() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (photo != null) {
        if (mounted) {
          context.read<AgeVerificationProvider>().setImagePath(photo.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar imagem: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null) {
        if (mounted) {
          context.read<AgeVerificationProvider>().setImagePath(photo.path);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _handleValidatePressed() {
    final provider = context.read<AgeVerificationProvider>();
    if (provider.selectedImagePath != null) {
      widget.onValidatePressed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma imagem do documento'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
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
                _buildProgressIndicator(step: 2),
                const SizedBox(height: 40),

                // Título
                const Text(
                  'Capture o verso do seu documento',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11181c),
                  ),
                ),
                const SizedBox(height: 8),

                // Descrição
                const Text(
                  'Fotografe o verso do seu CPF ou documento de identidade',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF687076),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Área de visualização/captura
                Consumer<AgeVerificationProvider>(
                  builder: (context, provider, _) {
                    if (provider.selectedImagePath != null) {
                      return _buildImagePreview(provider.selectedImagePath!);
                    } else {
                      return _buildCaptureGuide();
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Instruções
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFCD34D),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Color(0xFFF59E0B),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Certifique-se que o documento está bem iluminado e legível',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Botões de ação
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _captureImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tirar Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0a7ea4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 2,
                      splashFactory: InkRipple.splashFactory,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).copyWith(
                      overlayColor: WidgetStatePropertyAll(
                        Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Botão alternativo para galeria
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.image),
                    label: const Text('Selecionar da Galeria'),
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
                const SizedBox(height: 40),

                // Botão Enviar para Validação
                Consumer<AgeVerificationProvider>(
                  builder: (context, provider, _) {
                    final hasImage = provider.selectedImagePath != null;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: hasImage ? _handleValidatePressed : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22c55e),
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
                          'Enviar para Validação',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureGuide() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Retângulo tracejado
          Container(
            width: 220,
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF0a7ea4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const DashedRect(
              color: Color(0xFF0a7ea4),
              strokeWidth: 2,
              gap: 5,
            ),
          ),
          // Ícone de câmera
          const Icon(
            Icons.camera_alt,
            size: 48,
            color: Color(0xFF0a7ea4),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF22c55e),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF22c55e),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                context.read<AgeVerificationProvider>().clearImage();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
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

/// Widget para desenhar retângulo tracejado
class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  const DashedRect({
    super.key,
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        gap: gap,
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _drawDashedRect(canvas, rect, paint);
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    const dashWidth = 10;
    const dashSpace = 5;
    double startX = rect.left;
    double startY = rect.top;

    // Top line
    while (startX < rect.right) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset((startX + dashWidth).clamp(0, rect.right), startY),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right line
    startX = rect.right;
    startY = rect.top;
    while (startY < rect.bottom) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, (startY + dashWidth).clamp(0, rect.bottom)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom line
    startX = rect.right;
    startY = rect.bottom;
    while (startX > rect.left) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset((startX - dashWidth).clamp(rect.left, rect.right), startY),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left line
    startX = rect.left;
    startY = rect.bottom;
    while (startY > rect.top) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, (startY - dashWidth).clamp(rect.top, rect.bottom)),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedRectPainter oldDelegate) => false;
}
