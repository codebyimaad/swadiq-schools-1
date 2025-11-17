package auth

import (
	"bytes"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"html/template"
	"net/smtp"
	"swadiq-schools/app/config"
)

func GenerateResetToken() (string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func SendPasswordResetEmail(email, resetToken, host string) error {
	smtpConfig := config.AppConfig.SMTP
	
	auth := smtp.PlainAuth("", smtpConfig.Username, smtpConfig.Password, smtpConfig.Host)
	
	resetLink := fmt.Sprintf("http://%s/auth/reset-password?token=%s", host, resetToken)
	
	// Parse email template
	tmpl, err := template.ParseFiles("app/templates/emails/password-reset.html")
	if err != nil {
		return err
	}
	
	// Execute template with data
	var body bytes.Buffer
	err = tmpl.Execute(&body, map[string]string{
		"ResetLink": resetLink,
	})
	if err != nil {
		return err
	}
	
	subject := "Password Reset - Swadiq Schools"
	msg := fmt.Sprintf("To: %s\r\nSubject: %s\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n%s", email, subject, body.String())
	
	return smtp.SendMail(fmt.Sprintf("%s:%d", smtpConfig.Host, smtpConfig.Port), auth, smtpConfig.From, []string{email}, []byte(msg))
}