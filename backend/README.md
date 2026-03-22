# Age Gate Backend - API REST em Go

Backend REST API para o sistema de verificação de idade Age Gate, desenvolvido com Go e Gin.

## 🏗️ Arquitetura

```
backend/
├── main.go                 # Servidor REST e endpoints
├── age_verification.go     # Interface AgeVerificationService e implementação KYC
├── go.mod                  # Dependências
├── go.sum                  # Lock de dependências
└── age-gate-api            # Binário compilado
```

## 🚀 Início Rápido

### Compilar

```bash
go mod tidy
go build -o age-gate-api .
```

### Executar

```bash
./age-gate-api
# Servidor iniciado em http://localhost:8080
```

### Verificar Saúde

```bash
curl http://localhost:8080/health
```

## 📡 Endpoints

### GET /health

Verifica o status da API.

**Resposta**:
```json
{
  "status": "ok",
  "service": "age-gate-api",
  "version": "1.0.0"
}
```

### POST /validate-age

Valida a idade do usuário através de CPF e foto do documento.

**Requisição**:
```json
{
  "cpf": "123.456.789-00",
  "document_photo": "iVBORw0KGgoAAAANSUhEUgAAAAUA...",
  "document_type": "CPF"
}
```

**Resposta (HTTP 200 - Validado e Maior)**:
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

**Resposta (HTTP 403 - Menor de Idade)**:
```json
{
  "valid": false,
  "age": null,
  "date_of_birth": null,
  "is_minor": true,
  "reason": "Minor without parental consent",
  "validation_id": "VAL-1710768000-987654321",
  "message": "Menor de idade. Consentimento parental necessário."
}
```

**Resposta (HTTP 401 - Dados Inválidos)**:
```json
{
  "valid": false,
  "age": null,
  "date_of_birth": null,
  "is_minor": false,
  "reason": "Document or biometric data does not match",
  "validation_id": "VAL-1710768000-555555555",
  "message": "Validação falhou. Os dados fornecidos não conferem."
}
```

## 🔐 Segurança

### Validação de CPF

O backend valida o CPF usando o algoritmo de dígitos verificadores (módulo 11):

1. Verifica se tem 11 dígitos
2. Verifica se não são todos iguais
3. Calcula e valida primeiro dígito verificador
4. Calcula e valida segundo dígito verificador

### Integração KYC Simulada

A implementação `KYCService` simula uma chamada HTTP para uma API externa de validação de documentos:

```go
type KYCService struct {
    httpClient *http.Client
    kycAPIURL  string
}
```

**Fluxo**:
1. Recebe CPF e foto do documento (Base64)
2. Valida formato do CPF
3. Faz requisição HTTP POST para API KYC
4. Processa resposta e calcula idade
5. Retorna resultado com status HTTP apropriado

### Sem Armazenamento de Dados Sensíveis

- CPF não é persistido no banco de dados
- Foto do documento não é armazenada
- Apenas ID de validação é registrado
- Dados sensíveis são transmitidos apenas via HTTPS

### CORS

Middleware CORS habilitado para aceitar requisições do frontend:

```go
func corsMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
        c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET")
        // ...
    }
}
```

## 📊 Fluxo de Validação

```
1. Requisição POST /validate-age
   ↓
2. Validar payload JSON
   ↓
3. Validar formato de CPF
   ↓
4. Chamar KYCService.ValidateAge()
   ↓
5. Fazer HTTP POST para API KYC externa
   ↓
6. Processar resposta KYC
   ↓
7. Calcular idade a partir de data de nascimento
   ↓
8. Verificar se é menor de 18 anos
   ↓
9. Retornar resposta com status HTTP apropriado
   ├─ HTTP 200: Validado e maior de 18 anos
   ├─ HTTP 403: Menor de 18 anos
   └─ HTTP 401: Dados não conferem
```

## 🧪 Testes

### Testar com curl

**Validação bem-sucedida**:
```bash
curl -X POST http://localhost:8080/validate-age \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "123.456.789-00",
    "document_photo": "base64encodedimage...",
    "document_type": "CPF"
  }'
```

**CPF inválido**:
```bash
curl -X POST http://localhost:8080/validate-age \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "000.000.000-00",
    "document_photo": "base64encodedimage...",
    "document_type": "CPF"
  }'
```

### Testes unitários

```bash
go test ./...
```

## 🔧 Configuração

### Variáveis de Ambiente

```bash
PORT=8080                    # Porta do servidor (padrão: 8080)
KYC_API_URL=https://...      # URL da API KYC externa (opcional)
```

### Timeout

- Conexão: 30 segundos
- Recebimento: 30 segundos

## 📦 Dependências

- `github.com/gin-gonic/gin v1.9.1`: Framework web
- `github.com/google/uuid v1.3.0`: Geração de IDs

## 🏛️ Conformidade Legal

### Lei nº 15.211/2025 (ECA Digital)

O backend implementa conformidade com:

1. **Validação de Idade Real**: Não apenas validação matemática de CPF
2. **Integração KYC**: Simula consumo de API externa de validação
3. **Proteção de Menores**: Retorna HTTP 403 para menores de 18 anos
4. **Sem Armazenamento**: CPF não é persistido
5. **Segurança**: Dados sensíveis não são transmitidos em texto plano

## 🚀 Deploy

### Docker

```dockerfile
FROM golang:1.21-alpine

WORKDIR /app
COPY . .

RUN go mod download
RUN go build -o age-gate-api .

EXPOSE 8080
CMD ["./age-gate-api"]
```

### Build Docker

```bash
docker build -t age-gate-api .
docker run -p 8080:8080 age-gate-api
```

## 📝 Logging

O servidor registra:

- Requisições recebidas
- Respostas enviadas
- Erros de validação
- Chamadas para API KYC

## 🔍 Debugging

Habilitar modo debug:

```bash
gin.SetMode(gin.DebugMode)
```

## 📚 Referências

- [Gin Framework](https://github.com/gin-gonic/gin)
- [Go HTTP Client](https://golang.org/pkg/net/http/)
- [RFC 7231 - HTTP Status Codes](https://tools.ietf.org/html/rfc7231#section-6)

---

**Versão**: 1.0.0  
**Linguagem**: Go 1.18+  
**Status**: Produção
