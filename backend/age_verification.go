package main

import (
	"encoding/base64"
	"fmt"
	"time"
)

// AgeVerificationService define a interface para validação de idade
type AgeVerificationService interface {
	ValidateAge(cpf string, documentPhoto string) (*AgeVerificationResult, error)
}

// AgeVerificationResult representa o resultado da validação de idade
type AgeVerificationResult struct {
	Valid        bool      `json:"valid"`
	DateOfBirth  string    `json:"date_of_birth,omitempty"`
	Age          int       `json:"age,omitempty"`
	IsMinor      bool      `json:"is_minor"`
	Reason       string    `json:"reason,omitempty"`
	ValidationID string    `json:"validation_id"`
	ValidatedAt  time.Time `json:"validated_at"`
}

// isValidCPF valida o formato e dígitos verificadores do CPF
func isValidCPF(cpf string) bool {
	// Remover formatação
	cleanCPF := ""
	for _, char := range cpf {
		if char >= '0' && char <= '9' {
			cleanCPF += string(char)
		}
	}

	// Verificar comprimento
	if len(cleanCPF) != 11 {
		return false
	}

	// Verificar se todos os dígitos são iguais (CPF inválido)
	allEqual := true
	for i := 1; i < 11; i++ {
		if cleanCPF[i] != cleanCPF[0] {
			allEqual = false
			break
		}
	}
	if allEqual {
		return false
	}

	// Validar primeiro dígito verificador
	sum := 0
	for i := 0; i < 9; i++ {
		digit := int(cleanCPF[i] - '0')
		sum += digit * (10 - i)
	}
	remainder := sum % 11
	firstDigit := 0
	if remainder < 2 {
		firstDigit = 0
	} else {
		firstDigit = 11 - remainder
	}

	if int(cleanCPF[9]-'0') != firstDigit {
		return false
	}

	// Validar segundo dígito verificador
	sum = 0
	for i := 0; i < 10; i++ {
		digit := int(cleanCPF[i] - '0')
		sum += digit * (11 - i)
	}
	remainder = sum % 11
	secondDigit := 0
	if remainder < 2 {
		secondDigit = 0
	} else {
		secondDigit = 11 - remainder
	}

	if int(cleanCPF[10]-'0') != secondDigit {
		return false
	}

	return true
}

// calculateAge calcula a idade a partir de uma data de nascimento (formato YYYY-MM-DD)
func calculateAge(dateOfBirth string) (int, error) {
	dob, err := time.Parse("2006-01-02", dateOfBirth)
	if err != nil {
		return 0, err
	}

	now := time.Now()
	age := now.Year() - dob.Year()

	// Ajustar se o aniversário ainda não ocorreu este ano
	if now.Month() < dob.Month() || (now.Month() == dob.Month() && now.Day() < dob.Day()) {
		age--
	}

	return age, nil
}

// generateValidationID gera um ID único para a validação
func generateValidationID() string {
	return fmt.Sprintf("VAL-%d-%d", time.Now().Unix(), time.Now().Nanosecond())
}

// generateValidationToken gera um token para a requisição (mantido para compatibilidade)
func generateValidationToken() string {
	return base64.StdEncoding.EncodeToString([]byte(fmt.Sprintf("%d", time.Now().UnixNano())))
}
