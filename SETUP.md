# Guia de Execução - Age Gate System

Instruções completas para executar o sistema de Age Gate com Flutter (frontend) e Go (backend).

## 📋 Pré-requisitos

### Sistema Operacional
- Linux, macOS ou Windows
- Terminal/Console

### Backend (Go)
- Go 1.18 ou superior
- Instalação: https://golang.org/doc/install

### Frontend (Flutter)
- Flutter 3.19 ou superior
- Dart 3.3 ou superior
- Instalação: https://flutter.dev/docs/get-started/install

### Dispositivo/Emulador
- Android Studio (para Android)
- Xcode (para iOS)
- Ou navegador web (para testes)

## 🚀 Execução Rápida

### Terminal 1: Backend (Go)

```bash
# Navegar para pasta do backend
cd age-gate-system/backend

# Baixar dependências
go mod tidy

# Compilar
go build -o age-gate-api .

# Executar
./age-gate-api

# Saída esperada:
# Iniciando servidor Age Gate API na porta 8080
```

**Verificar se está rodando**:
```bash
curl http://localhost:8080/health
# Resposta: {"status":"ok","service":"age-gate-api","version":"1.0.0"}
```

### Terminal 2: Frontend (Flutter)

```bash
# Navegar para pasta do Flutter
cd age-gate-system/flutter_app

# Instalar dependências
flutter pub get

# Executar em desenvolvimento
# Para Android:
flutter run -d android

# Para iOS:
flutter run -d ios

# Para Web (testes):
flutter run -d web
```

## 📱 Fluxo de Teste

1. **Abrir o aplicativo Flutter**
   - Tela inicial com "Welcome Screen"

2. **Clicar em "Começar"**
   - Navega para "CPF Input Screen"

3. **Digitar um CPF válido**
   - Exemplo: `123.456.789-00` (será validado)
   - Botão "Próximo" será habilitado

4. **Clicar em "Próximo"**
   - Navega para "Document Capture Screen"

5. **Capturar ou selecionar uma imagem**
   - Tirar foto com câmera
   - Ou selecionar da galeria

6. **Clicar em "Enviar para Validação"**
   - Mostra "Loading Screen"
   - Faz requisição POST para `http://localhost:8080/validate-age`

7. **Receber resposta**
   - **Sucesso (HTTP 200)**: Mostra "Success Screen"
   - **Menor de idade (HTTP 403)**: Mostra "Failure Screen" com mensagem de consentimento parental
   - **Dados inválidos (HTTP 401)**: Mostra "Failure Screen" com mensagem de erro

## 🔧 Configuração

### Backend (Go)

**Variáveis de Ambiente** (opcional):
```bash
export PORT=8080                    # Porta padrão
export KYC_API_URL=https://...      # URL da API KYC (opcional)
```

**Arquivo**: `backend/main.go`

### Frontend (Flutter)

**Configurar URL da API**:
Editar `flutter_app/lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8080';  // Mudar aqui se necessário
  static const String validateAgeEndpoint = '/validate-age';
}
```

## 📡 Testando a API com curl

### Teste 1: Validação bem-sucedida

```bash
curl -X POST http://localhost:8080/validate-age \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "123.456.789-00",
    "document_photo": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "document_type": "CPF"
  }'
```

**Resposta esperada (HTTP 200)**:
```json
{
  "valid": true,
  "age": 25,
  "date_of_birth": "1999-03-18",
  "is_minor": false,
  "validation_id": "VAL-1710768000-123456789",
  "message": "Validação aprovada. Acesso concedido."
}
```

### Teste 2: CPF inválido

```bash
curl -X POST http://localhost:8080/validate-age \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "000.000.000-00",
    "document_photo": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "document_type": "CPF"
  }'
```

**Resposta esperada (HTTP 401)**:
```json
{
  "valid": false,
  "is_minor": false,
  "reason": "Invalid CPF format",
  "validation_id": "VAL-1710768000-987654321",
  "message": "Validação falhou. Os dados fornecidos não conferem."
}
```

## 🐛 Troubleshooting

### Backend não inicia

**Erro**: `Port already in use`
```bash
# Encontrar processo usando porta 8080
lsof -i :8080

# Matar processo
kill -9 <PID>

# Ou usar porta diferente
PORT=8081 ./age-gate-api
```

**Erro**: `go: command not found`
```bash
# Verificar instalação do Go
go version

# Se não estiver instalado, instalar em: https://golang.org/doc/install
```

### Flutter não conecta com backend

**Erro**: `Connection refused`
1. Verificar se backend está rodando: `curl http://localhost:8080/health`
2. Verificar URL em `lib/config/api_config.dart`
3. Se em emulador Android, usar `10.0.2.2` em vez de `localhost`:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8080';
   ```

**Erro**: `CORS error`
- Backend tem CORS habilitado, deve funcionar
- Verificar logs do backend

### Imagem não é capturada

**Android**: Verificar permissões em `AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

**iOS**: Verificar `Info.plist`
```xml
<key>NSCameraUsageDescription</key>
<string>Precisamos acessar sua câmera para capturar o documento</string>
```

## 📊 Estrutura de Pastas

```
age-gate-system/
├── backend/                    # Backend Go
│   ├── main.go
│   ├── age_verification.go
│   ├── go.mod
│   ├── go.sum
│   ├── age-gate-api           # Binário compilado
│   └── README.md
│
├── flutter_app/               # Frontend Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── providers/
│   │   └── utils/
│   ├── pubspec.yaml
│   └── README.md
│
├── design.md                  # Especificação de design
├── todo.md                    # Rastreamento de funcionalidades
├── README.md                  # Documentação principal
└── SETUP.md                   # Este arquivo
```

## 🧪 Testes Manuais

### Teste 1: Validação de CPF

1. Abrir app Flutter
2. Clicar "Começar"
3. Digitar CPF válido: `123.456.789-00`
4. Verificar se botão "Próximo" fica habilitado
5. Digitar CPF inválido: `000.000.000-00`
6. Verificar se botão "Próximo" fica desabilitado

### Teste 2: Captura de Documento

1. Clicar "Próximo" com CPF válido
2. Clicar "Tirar Foto"
3. Capturar foto de um documento
4. Verificar preview da imagem
5. Clicar "X" para remover
6. Clicar "Selecionar da Galeria"
7. Selecionar imagem da galeria

### Teste 3: Validação Completa

1. Preencher CPF válido
2. Capturar/selecionar imagem
3. Clicar "Enviar para Validação"
4. Verificar "Loading Screen"
5. Aguardar resposta
6. Verificar "Success Screen" ou "Failure Screen"

## 📚 Documentação Adicional

- `README.md`: Visão geral do projeto
- `backend/README.md`: Documentação do backend Go
- `flutter_app/README.md`: Documentação do frontend Flutter
- `design.md`: Especificação de design da interface

## 🚀 Deploy

### Build Android

```bash
cd flutter_app
flutter build apk --release
# APK gerado em: build/app/outputs/flutter-app-release.apk
```

### Build iOS

```bash
cd flutter_app
flutter build ios --release
# Arquivo gerado em: build/ios/iphoneos/Runner.app
```

### Build Backend (Docker)

```bash
cd backend
docker build -t age-gate-api .
docker run -p 8080:8080 age-gate-api
```

## 📞 Suporte

Para problemas ou dúvidas:
1. Verificar logs do backend: `./age-gate-api` (modo debug)
2. Verificar logs do Flutter: `flutter run -v`
3. Consultar documentação em `README.md` e `design.md`

---

**Última atualização**: Março 2026  
**Versão**: 1.0.0
