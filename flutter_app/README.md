# Age Gate Frontend - Aplicativo Flutter

Aplicativo móvel para verificação de idade real conforme Lei nº 15.211/2025 (ECA Digital), desenvolvido em Flutter.

## 🏗️ Arquitetura

```
flutter_app/
├── lib/
│   ├── main.dart                          # Ponto de entrada
│   ├── config/
│   │   └── api_config.dart                # Configuração da API
│   ├── models/
│   │   └── age_verification_model.dart    # Modelos de dados
│   ├── screens/
│   │   ├── welcome_screen.dart            # Tela de boas-vindas
│   │   ├── cpf_input_screen.dart          # Entrada de CPF
│   │   ├── document_capture_screen.dart   # Captura de documento
│   │   ├── loading_screen.dart            # Tela de carregamento
│   │   ├── success_screen.dart            # Tela de sucesso
│   │   └── failure_screen.dart            # Tela de falha
│   ├── services/
│   │   ├── api_service.dart               # Cliente HTTP
│   │   └── image_service.dart             # Manipulação de imagens
│   ├── providers/
│   │   └── age_verification_provider.dart # Gerenciamento de estado
│   └── utils/
│       └── cpf_formatter.dart             # Formatação de CPF
├── pubspec.yaml                           # Dependências
└── README.md                              # Este arquivo
```

## 🚀 Início Rápido

### Pré-requisitos

- Flutter 3.19+ com Dart 3.3+
- Android Studio ou Xcode
- Emulador ou dispositivo físico

### Instalação

1. **Instalar dependências**:
```bash
flutter pub get
```

2. **Executar em desenvolvimento**:
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d web
```

3. **Compilar para produção**:
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

## 📱 Telas

### 1. Welcome Screen
Apresentação inicial com explicação do processo

### 2. CPF Input Screen
Entrada de CPF com máscara e validação

### 3. Document Capture Screen
Captura de documento via câmera

### 4. Loading Screen
Tela de carregamento durante validação

### 5. Success Screen
Confirmação de validação aprovada (HTTP 200)

### 6. Failure Screen
Mensagem de validação rejeitada (HTTP 403 ou 401)

## 📦 Dependências

- camera, image_picker: Captura e seleção de imagens
- dio: Cliente HTTP
- provider: Gerenciamento de estado
- image: Manipulação de imagens
- loading_animation_widget: Animações

## 🔐 Segurança

- Validação de CPF com módulo 11
- Compressão de imagens antes de enviar
- Conversão para Base64
- Sem armazenamento local de dados sensíveis

## 📡 Integração com Backend

Configure a URL da API em `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8080';
```

---

**Versão**: 1.0.0 | **Status**: Produção
