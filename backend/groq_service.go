package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// GroqService implementa AgeVerificationService usando Groq Cloud API (Llama 3.2 Vision)
type GroqService struct {
	apiKey     string
	httpClient *http.Client
	apiURL     string
	model      string
}

// NewGroqService cria uma nova instância do serviço Groq
func NewGroqService(apiKey string) *GroqService {
	return &GroqService{
		apiKey: apiKey,
		httpClient: &http.Client{
			Timeout: 60 * time.Second,
		},
		apiURL: "https://api.groq.com/openai/v1/chat/completions",
		model:  "meta-llama/llama-4-scout-17b-16e-instruct",
	}
}

// GroqRequest representa a requisição para a API do Groq (Chat Completions)
type GroqRequest struct {
	Model          string           `json:"model"`
	Messages       []GroqMessage    `json:"messages"`
	ResponseFormat *ResponseFormat  `json:"response_format,omitempty"`
	Temperature    float64          `json:"temperature"`
}

type ResponseFormat struct {
	Type string `json:"type"`
}

type GroqMessage struct {
	Role    string        `json:"role"`
	Content []ChatContent `json:"content"`
}

type ChatContent struct {
	Type     string    `json:"type"`
	Text     string    `json:"text,omitempty"`
	ImageURL *ImageURL `json:"image_url,omitempty"`
}

type ImageURL struct {
	URL string `json:"url"`
}

// GroqResponse representa a resposta da API do Groq
type GroqResponse struct {
	Choices []struct {
		Message struct {
			Content string `json:"content"`
		} `json:"message"`
	} `json:"choices"`
	Error *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
	} `json:"error,omitempty"`
}

// GroqDocumentAnalysis representa o resultado da análise do documento pelo Llama
type GroqDocumentAnalysis struct {
	DateOfBirth string `json:"date_of_birth"`
	FullName    string `json:"full_name"`
	IsValid     bool   `json:"is_valid"`
	Reason      string `json:"reason,omitempty"`
}

// ValidateAge implementa a validação de idade usando Groq Llama 3.2 Vision
func (g *GroqService) ValidateAge(cpf string, documentPhotoBase64 string) (*AgeVerificationResult, error) {
	// Validação básica de CPF
	if !isValidCPF(cpf) {
		return &AgeVerificationResult{
			Valid:        false,
			IsMinor:      false,
			Reason:       "Formato de CPF inválido",
			ValidationID: generateValidationID(),
			ValidatedAt:  time.Now(),
		}, nil
	}

	analysis, err := g.analyzeDocument(documentPhotoBase64)
	if err != nil {
		return nil, fmt.Errorf("erro ao analisar documento com Groq: %w", err)
	}

	result := &AgeVerificationResult{
		ValidationID: generateValidationID(),
		ValidatedAt:  time.Now(),
	}

	if !analysis.IsValid {
		result.Valid = false
		result.Reason = analysis.Reason
		if result.Reason == "" {
			result.Reason = "Documento ilegível ou inválido"
		}
		return result, nil
	}

	age, err := calculateAge(analysis.DateOfBirth)
	if err != nil {
		result.Valid = false
		result.Reason = fmt.Sprintf("Data de nascimento inválida extraída: %s", analysis.DateOfBirth)
		return result, nil
	}

	result.Age = age
	result.DateOfBirth = analysis.DateOfBirth

	if age < 18 {
		result.Valid = false
		result.IsMinor = true
		result.Reason = "Usuário menor de 18 anos"
		return result, nil
	}

	result.Valid = true
	return result, nil
}

func (g *GroqService) analyzeDocument(documentPhotoBase64 string) (*GroqDocumentAnalysis, error) {
	prompt := `Analise este documento brasileiro. Extraia a data de nascimento e o nome completo.
Retorne APENAS um JSON no formato:
{
  "date_of_birth": "YYYY-MM-DD",
  "full_name": "NOME COMPLETO",
  "is_valid": true,
  "reason": ""
}
Se não for um documento ou a data de nascimento estiver ilegível, retorne is_valid: false com o motivo em reason.`

	dataURL := fmt.Sprintf("data:image/jpeg;base64,%s", documentPhotoBase64)

	reqBody := GroqRequest{
		Model: g.model,
		Messages: []GroqMessage{
			{
				Role: "user",
				Content: []ChatContent{
					{Type: "text", Text: prompt},
					{
						Type: "image_url",
						ImageURL: &ImageURL{URL: dataURL},
					},
				},
			},
		},
		ResponseFormat: &ResponseFormat{Type: "json_object"},
		Temperature:    0.1,
	}

	jsonBody, err := json.Marshal(reqBody)
	if err != nil {
		return nil, err
	}

	httpReq, err := http.NewRequest("POST", g.apiURL, bytes.NewBuffer(jsonBody))
	if err != nil {
		return nil, err
	}

	httpReq.Header.Set("Authorization", "Bearer "+g.apiKey)
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := g.httpClient.Do(httpReq)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("Groq API error (%d): %s", resp.StatusCode, string(body))
	}

	var groqResp GroqResponse
	if err := json.Unmarshal(body, &groqResp); err != nil {
		return nil, err
	}

	if groqResp.Error != nil {
		return nil, fmt.Errorf("Groq API returned error: %s", groqResp.Error.Message)
	}

	if len(groqResp.Choices) == 0 {
		return nil, fmt.Errorf("no choices returned from Groq")
	}

	content := groqResp.Choices[0].Message.Content
	var analysis GroqDocumentAnalysis
	if err := json.Unmarshal([]byte(content), &analysis); err != nil {
		return nil, fmt.Errorf("failed to parse analysis JSON: %w (content: %s)", err, content)
	}

	return &analysis, nil
}
