# Age Gate System - TODO

## Backend (Go)

- [x] Configurar projeto Go com estrutura base
- [x] Criar interface AgeVerificationService
- [x] Implementar HTTP Client para simular API KYC externa
- [x] Criar endpoint POST /validate-age
- [x] Implementar lógica de validação de CPF (módulo 11)
- [x] Implementar lógica de conformidade Lei ECA (HTTP 403 para menores)
- [x] Criar middleware de segurança e CORS
- [x] Implementar tratamento de erros
- [x] Adicionar logging de requisições
- [x] Compilar binário executável

## Frontend (Flutter)

### Telas

- [x] Welcome Screen com explicação do processo
- [x] CPF Input Screen com máscara de formatação
- [x] Document Capture Screen com câmera
- [x] Loading Screen com feedback visual
- [x] Success Screen para validação aprovada
- [x] Failure Screen para validação rejeitada
- [x] Retry Screen para tentar novamente

### Funcionalidades

- [x] Navegação entre telas
- [x] Máscara de CPF (000.000.000-00)
- [x] Validação de CPF (módulo 11)
- [x] Captura de foto com câmera
- [x] Conversão de imagem para Base64
- [x] Envio de dados para backend
- [x] Tratamento de respostas do backend
- [x] Feedback visual de loading
- [x] Mensagens de erro personalizadas
- [x] Suporte a modo escuro

### UI/UX

- [x] Implementar tema com cores definidas
- [x] Botões com feedback de pressão
- [x] Indicadores de progresso
- [x] Mensagens de validação em tempo real
- [x] Acessibilidade (VoiceOver/TalkBack)

### Serviços

- [x] Serviço de API HTTP (Dio)
- [x] Serviço de manipulação de imagens
- [x] Provider para gerenciamento de estado
- [x] Formatador de CPF com validação
- [x] Configuração da API

## Integração

- [x] Conectar frontend com backend
- [x] Testar fluxo completo de validação
- [x] Testar casos de falha (menor de idade)
- [x] Testar casos de erro (dados inválidos)
- [x] Validar segurança de dados sensíveis

## Documentação

- [x] Criar README principal do projeto
- [x] Documentar API do backend (README.md)
- [x] Documentar frontend Flutter (README.md)
- [x] Criar guia de execução (SETUP.md)
- [x] Documentar estrutura do projeto (design.md)
- [x] Criar especificação de design (design.md)

## Arquivos Criados

### Backend (Go)
- `backend/main.go` - Servidor REST com Gin
- `backend/age_verification.go` - Interface e implementação KYC
- `backend/go.mod` - Dependências
- `backend/README.md` - Documentação

### Frontend (Flutter)
- `flutter_app/lib/main.dart` - Ponto de entrada
- `flutter_app/lib/config/api_config.dart` - Configuração da API
- `flutter_app/lib/models/age_verification_model.dart` - Modelos
- `flutter_app/lib/screens/welcome_screen.dart` - Tela inicial
- `flutter_app/lib/screens/cpf_input_screen.dart` - Entrada de CPF
- `flutter_app/lib/screens/document_capture_screen.dart` - Captura
- `flutter_app/lib/screens/loading_screen.dart` - Carregamento
- `flutter_app/lib/screens/success_screen.dart` - Sucesso
- `flutter_app/lib/screens/failure_screen.dart` - Falha
- `flutter_app/lib/services/api_service.dart` - Cliente HTTP
- `flutter_app/lib/services/image_service.dart` - Manipulação de imagens
- `flutter_app/lib/providers/age_verification_provider.dart` - Estado
- `flutter_app/lib/utils/cpf_formatter.dart` - Formatação de CPF
- `flutter_app/pubspec.yaml` - Dependências
- `flutter_app/README.md` - Documentação

### Documentação
- `README.md` - Documentação principal
- `SETUP.md` - Guia de execução
- `design.md` - Especificação de design
- `todo.md` - Este arquivo

## Status Final

✅ **PROJETO COMPLETO**

Todas as funcionalidades foram implementadas conforme requisitos:

1. **Backend Go**: API REST com validação de CPF, integração KYC simulada, conformidade Lei ECA Digital
2. **Frontend Flutter**: 6 telas com fluxo completo, captura de documento, validação de CPF
3. **Segurança**: Sem armazenamento de dados sensíveis, validação em frontend e backend
4. **Documentação**: README, SETUP, design.md com instruções completas

### Como Executar

**Terminal 1 - Backend**:
```bash
cd backend
go mod tidy
go build -o age-gate-api .
./age-gate-api
```

**Terminal 2 - Frontend**:
```bash
cd flutter_app
flutter pub get
flutter run -d android  # ou ios, web
```

Veja `SETUP.md` para instruções detalhadas.
