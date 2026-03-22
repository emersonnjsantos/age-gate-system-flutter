# Age Gate System - Design de Interface Móvel

## Visão Geral

O aplicativo Age Gate é um sistema de verificação de idade real conforme Lei nº 15.211/2025 (ECA Digital). O design segue padrões iOS com foco em experiência de usuário clara, segura e intuitiva para validação de identidade.

## Orientação e Contexto

- **Orientação**: Portrait (9:16)
- **Uso**: Uma mão
- **Padrão**: Apple Human Interface Guidelines (HIG)
- **Foco**: Segurança, clareza e confiança do usuário

## Lista de Telas

1. **Welcome Screen** - Tela inicial com explicação do processo
2. **CPF Input Screen** - Formulário com entrada de CPF e máscara
3. **Document Capture Screen** - Captura de foto do documento
4. **Loading Screen** - Aguardando validação do backend
5. **Success Screen** - Validação aprovada (maior de 18 anos)
6. **Failure Screen** - Validação rejeitada (menor de 18 anos ou dados inválidos)
7. **Retry Screen** - Opção de tentar novamente

## Conteúdo Primário e Funcionalidade por Tela

### 1. Welcome Screen
- **Conteúdo**: 
  - Logo/ícone do aplicativo
  - Título: "Verificação de Idade"
  - Descrição: "Confirme sua identidade para continuar"
  - Explicação do processo em 3 passos
- **Funcionalidade**: 
  - Botão "Começar" que navega para CPF Input Screen
  - Botão "Saiba Mais" com informações sobre a Lei ECA Digital

### 2. CPF Input Screen
- **Conteúdo**:
  - Título: "Qual é o seu CPF?"
  - Campo de entrada com máscara (000.000.000-00)
  - Indicador visual de preenchimento
  - Botão "Próximo"
- **Funcionalidade**:
  - Máscara de formatação automática
  - Validação de CPF (matemática básica)
  - Botão desabilitado até CPF válido
  - Feedback visual em tempo real

### 3. Document Capture Screen
- **Conteúdo**:
  - Título: "Capture o verso do seu documento"
  - Visualização da câmera em tempo real
  - Retângulo tracejado como guia de posicionamento
  - Instruções: "Posicione o documento dentro do retângulo"
  - Botão "Tirar Foto"
- **Funcionalidade**:
  - Acesso à câmera do dispositivo
  - Guia visual para posicionamento correto
  - Captura de foto com conversão para Base64
  - Preview da foto capturada com opção de refazer

### 4. Loading Screen
- **Conteúdo**:
  - Spinner/indicador de carregamento
  - Mensagem: "Validando seus dados..."
  - Submensagem: "Isso pode levar alguns segundos"
- **Funcionalidade**:
  - Bloqueio de interação durante validação
  - Envio de CPF + foto para backend
  - Timeout de segurança (30 segundos)

### 5. Success Screen
- **Conteúdo**:
  - Ícone de sucesso (checkmark)
  - Título: "Validação Aprovada"
  - Mensagem: "Você atende aos requisitos de idade"
  - Data de nascimento confirmada (sem revelar completa)
- **Funcionalidade**:
  - Botão "Continuar" para próxima etapa do app
  - Opção "Voltar" para início

### 6. Failure Screen
- **Conteúdo**:
  - Ícone de erro (X)
  - Título: "Validação Não Aprovada"
  - Mensagem específica:
    - Se menor: "Você é menor de 18 anos. Consentimento parental necessário."
    - Se dados inválidos: "Os dados fornecidos não conferem. Tente novamente."
- **Funcionalidade**:
  - Botão "Tentar Novamente"
  - Botão "Contato de Suporte"

### 7. Retry Screen
- **Conteúdo**: Mesmo layout que CPF Input Screen com mensagem adicional
- **Funcionalidade**: Reinicia o fluxo de captura

## Fluxos de Usuário Principais

### Fluxo Bem-Sucedido
1. Usuário abre app → Welcome Screen
2. Clica "Começar" → CPF Input Screen
3. Digita CPF válido → Próximo habilitado
4. Clica "Próximo" → Document Capture Screen
5. Posiciona documento e clica "Tirar Foto" → Preview
6. Confirma foto → Loading Screen
7. Backend valida → Success Screen
8. Clica "Continuar" → Acesso concedido

### Fluxo com Falha (Menor de Idade)
1. Usuário segue até Loading Screen
2. Backend retorna HTTP 403 (menor de 18 anos)
3. Failure Screen exibe mensagem sobre consentimento parental
4. Usuário pode "Tentar Novamente" ou "Contato de Suporte"

### Fluxo com Falha (Dados Inválidos)
1. Usuário segue até Loading Screen
2. Backend retorna erro de validação
3. Failure Screen exibe mensagem de dados inválidos
4. Usuário pode "Tentar Novamente"

## Escolhas de Cor

| Elemento | Cor | Uso |
|----------|-----|-----|
| **Primary** | #0a7ea4 (Azul) | Botões principais, destaque |
| **Background** | #ffffff (Branco) | Fundo padrão |
| **Surface** | #f5f5f5 (Cinza claro) | Cards, superfícies elevadas |
| **Foreground** | #11181c (Preto) | Texto principal |
| **Muted** | #687076 (Cinza) | Texto secundário, instruções |
| **Success** | #22c55e (Verde) | Validação aprovada |
| **Error** | #ef4444 (Vermelho) | Validação rejeitada, erros |
| **Border** | #e5e7eb (Cinza claro) | Bordas, divisores |

## Paleta de Cores por Modo

### Modo Claro
- Fundo: Branco
- Texto: Preto escuro
- Acentos: Azul

### Modo Escuro
- Fundo: #151718 (Preto)
- Texto: #ecedee (Branco)
- Acentos: Azul (mantém)

## Considerações de Segurança

- Não armazenar CPF localmente
- Usar HTTPS para todas as comunicações
- Validar dados no frontend e backend
- Limpar dados sensíveis após validação
- Implementar timeout de sessão

## Acessibilidade

- Alto contraste entre texto e fundo
- Tamanho de fonte mínimo 16pt
- Botões com tamanho mínimo de 44x44pt (toque)
- Descrições de imagem para elementos visuais
- Suporte a leitura de tela (VoiceOver/TalkBack)
