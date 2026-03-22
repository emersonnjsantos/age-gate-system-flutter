package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

// ValidateAgeRequest representa a requisição de validação de idade
type ValidateAgeRequest struct {
	CPF             string `json:"cpf" binding:"required"`
	DocumentPhoto   string `json:"document_photo" binding:"required"`
	DocumentType    string `json:"document_type" binding:"required"`
}

// ValidateAgeResponse representa a resposta de validação de idade
type ValidateAgeResponse struct {
	Valid           bool   `json:"valid"`
	Age             int    `json:"age,omitempty"`
	DateOfBirth     string `json:"date_of_birth,omitempty"`
	IsMinor         bool   `json:"is_minor"`
	Reason          string `json:"reason,omitempty"`
	ValidationID    string `json:"validation_id"`
	Message         string `json:"message"`
}

var ageVerificationService AgeVerificationService

func main() {
	// Configurar serviço de verificação de idade com Groq (Llama 3.2 Vision)
	groqAPIKey := os.Getenv("GROQ_API_KEY")
	if groqAPIKey == "" {
		log.Printf("AVISO: GROQ_API_KEY não encontrada. Buscando GEMINI_API_KEY para compatibilidade...")
		groqAPIKey = os.Getenv("GEMINI_API_KEY") // Fallback caso o usuário não tenha mudado a variável ainda
	}
	
	if groqAPIKey == "" {
		log.Fatal("GROQ_API_KEY é obrigatória. Obtenha em https://console.groq.com/keys")
	}

	ageVerificationService = NewGroqService(groqAPIKey)

	// Criar router Gin
	router := gin.Default()

	// Middleware CORS
	router.Use(corsMiddleware())

	// Rotas
	router.POST("/validate-age", validateAgeHandler)
	router.GET("/health", healthHandler)
	router.POST("/health", healthHandler)

	// Iniciar servidor
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Iniciando servidor Age Gate API v1.2 (GROQ/LLAMA) na porta %s [SISTEMA ATUALIZADO]\n", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Erro ao iniciar servidor: %v\n", err)
	}
}

// validateAgeHandler processa requisições de validação de idade
func validateAgeHandler(c *gin.Context) {
	var req ValidateAgeRequest

	// Parsear requisição JSON
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"valid":   false,
			"message": fmt.Sprintf("Erro ao processar requisição: %v", err),
		})
		return
	}

	// Validar campos obrigatórios
	if req.CPF == "" || req.DocumentPhoto == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"valid":   false,
			"message": "CPF e documento são obrigatórios",
		})
		return
	}

	log.Printf("[DEBUG] Validando CPF: %s\n", req.CPF)
	result, err := ageVerificationService.ValidateAge(req.CPF, req.DocumentPhoto)
	if err != nil {
		log.Printf("[ERRO CRÍTICO] Falha na validação: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"valid":   false,
			"message": fmt.Sprintf("ERRO_TECNICO_GROQ_v1.2: %v", err),
		})
		return
	}

	// Preparar resposta
	response := ValidateAgeResponse{
		Valid:        result.Valid,
		Age:          result.Age,
		DateOfBirth:  result.DateOfBirth,
		IsMinor:      result.IsMinor,
		Reason:       result.Reason,
		ValidationID: result.ValidationID,
	}

	// Determinar status HTTP e mensagem
	statusCode := http.StatusOK
	if !result.Valid && result.IsMinor {
		statusCode = http.StatusForbidden
		response.Message = "Menor de idade. Consentimento parental necessário."
		response.Reason = "Minor without parental consent"
	} else if !result.Valid {
		statusCode = http.StatusUnauthorized
		response.Message = "Validação falhou. Os dados fornecidos não conferem."
	} else {
		response.Message = "Validação aprovada. Acesso concedido."
	}

	// Retornar resposta
	c.JSON(statusCode, response)
}

// healthHandler verifica o status da API
func healthHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "ok",
		"service": "age-gate-api",
		"version": "1.0.0",
	})
}

// corsMiddleware adiciona headers CORS
func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
