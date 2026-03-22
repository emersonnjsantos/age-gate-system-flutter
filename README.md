<div align="center">
  <img src="https://img.icons8.com/fluency/96/shield.png" alt="Age Gate Logo" width="80" />
  
  # 🛡️ Age Gate System
  ### Verificação de Idade com IA Multimodal (Llama 3.2 Vision)
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://go.dev)
  [![Llama 3.2](https://img.shields.io/badge/Llama_3.2_Vision-Groq-orange?style=for-the-badge)](https://groq.com)
  [![License MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

  <p align="center">
    <b>Conformidade Legal • Segurança de Dados • IA de Ponta</b>
    <br />
    Uma solução robusta para validação de idade em conformidade com a <b>Lei nº 15.211/2025 (ECA Digital)</b>.
  </p>
</div>

---

## 📸 Demonstração em Tempo Real

<div align="center">
  <table style="width: 100%; text-align: center;">
    <tr>
      <td width="50%">
        <b>📱 Fluxo do App Mobile</b><br />
        <br />
        <!-- COLOQUE SEU GIF DO APP AQUI -->
        <img src="https://via.placeholder.com/300x600?text=GIF+APLICATIVO+MOBILE" width="280" alt="Demonstração App" />
      </td>
      <td width="50%">
        <b>⚙️ Processamento de IA</b><br />
        <br />
        <!-- COLOQUE SEU GIF DO BACKEND/LOGICA AQUI -->
        <img src="https://via.placeholder.com/300x600?text=GIF+PROCESSAMENTO+IA" width="280" alt="Demonstração IA" />
      </td>
    </tr>
  </table>
  <p><i>Capture documentos (CNH/RG), valide via IA e garanta segurança instantânea.</i></p>
</div>

---

## ✨ Funcionalidades em Destaque

- **📸 Captura Inteligente:** Interface intuitiva para captura de documentos brasileiros com feedback em tempo real.
- **🧠 Verificação por IA:** Integração com **Llama 3.2 Vision via Groq LPUs**, extraindo data de nascimento e validando a autenticidade do documento em milissegundos.
- **🛡️ Conformidade ECA Digital:** Fluxos específicos para bloqueio de menores e solicitação de consentimento parental.
- **🔒 Privacidade Directa:** O sistema valida os dados sem armazenar informações sensíveis como o CPF em banco de dados persistente.
- **🎨 Design Moderno:** UI inspirada no estilo *Glassmorphism*, com animações fluidas e suporte a modo escuro.

---

## 🛠️ Stack Tecnológica

### Frontend (Mobile)
- **Framework:** [Flutter](https://flutter.dev) (Dart)
- **Gestão de Estado:** Provider
- **Serviços:** Dio (HTTP), Camera & Image Picker
- **UI:** Custom Animations & Glassmorphism design

### Backend (API)
- **Linguagem:** [Go](https://go.dev) (Golang)
- **Framework:** Gin Gonic
- **Criptografia/Segurança:** UUID para Tracking de Validação
- **Conformidade:** Padrão KYC (Know Your Customer) simulado

### IA & Infra
- **Model:** meta-llama/Llama-3.2-11b-Vision-Preview
- **Provider:** [Groq Cloud](https://groq.com)
- **Deployment:** Docker support pronto para Cloud

---

## 📂 Arquitetura do Sistema

```mermaid
graph TD
    A[📱 Flutter App] -- "1. Envio de Imagem (Base64)" --> B[🚀 Go Backend]
    B -- "2. Análise Multimodal" --> C[🧠 Groq Llama 3.2 Vision]
    C -- "3. Extração de Data/Doc" --> B
    B -- "4. Validação de Regras/Idade" --> A
    A -- "5. Resultado Dinâmico" --> User[👤 Usuário]
    
    style C fill:#f96,stroke:#333,stroke-width:2px
    style B fill:#add8e6,stroke:#333,stroke-width:2px
    style A fill:#00bfff,stroke:#333,stroke-width:2px
```

---

## 🚀 Como Executar o Projeto

### 1. Requisitos Prévios
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- [Go](https://go.dev/doc/install) instalado.
- Uma API Key do [Groq](https://console.groq.com/keys).

### 2. Configuração do Backend
```bash
cd backend
# No Windows (PowerShell)
$env:GROQ_API_KEY = "sua_chave_groq"
go mod tidy
go run .
```

### 3. Configuração do App
```bash
cd flutter_app
# Atualize o IP da API em lib/config/api_config.dart
flutter pub get
flutter run
```

---

## 📄 Licença e Contribuidores

Este projeto está sob a licença **MIT**. Sinta-se à vontade para utilizar, modificar e contribuir!

> **Dica:** Para uma melhor apresentação, substitua os placeholders de imagem no README pelos seus próprios arquivos de mídia localizados na pasta `/assets`.

---
<div align="center">
  Feito com 💙 para um futuro digital mais seguro.
</div>
