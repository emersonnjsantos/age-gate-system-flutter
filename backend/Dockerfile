# Use a imagem oficial do Go para compilar
FROM golang:1.22-alpine AS builder

# Instalar git para dependências
RUN apk add --no-cache git

# Configurar diretório de trabalho
WORKDIR /app

# Copiar arquivos de módulos
COPY go.mod go.sum ./
RUN go mod download

# Copiar o restante do código
COPY . .

# Compilar o binário em modo estático
RUN CGO_ENABLED=0 GOOS=linux go build -o age-gate-api .

# Usar uma imagem extremamente leve para rodar
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copiar apenas o binário compilado
COPY --from=builder /app/age-gate-api .

# Expor a porta que o Cloud Run exige (ele injeta via variável $PORT)
ENV PORT 8080

# Comando para rodar
CMD ["./age-gate-api"]
