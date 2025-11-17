package auth

import (
	"database/sql"
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"time"

	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

func LoginAPI(c *fiber.Ctx) error {
	type LoginRequest struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	var req LoginRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	user, err := database.GetUserByEmail(config.GetDB(), req.Email)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(401).JSON(fiber.Map{"error": "Invalid credentials"})
		}
		return c.Status(500).JSON(fiber.Map{"error": "Database error"})
	}

	if !CheckPasswordHash(req.Password, user.Password) {
		return c.Status(401).JSON(fiber.Map{"error": "Invalid credentials"})
	}

	// Check hash cost and re-hash if necessary to migrate to a new cost
	cost, err := bcrypt.Cost([]byte(user.Password))
	if err == nil && cost != bcrypt.DefaultCost {
		newHash, err := HashPassword(req.Password)
		if err == nil {
			// This update can happen in the background.
			// For now, we'll do it synchronously.
			// We will ignore the error for now, as the user is already logged in.
			// In a production system, this should be logged.
			_ = database.UpdateUserPassword(config.GetDB(), user.ID, newHash)
		}
	}

	roles, err := database.GetUserRoles(config.GetDB(), user.ID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to get user roles"})
	}
	user.Roles = roles

	// Convert roles to string slice
	roleNames := make([]string, len(roles))
	for i, role := range roles {
		roleNames[i] = role.Name
	}

	// Generate JWT token
	token, err := GenerateJWT(user.ID, user.Email, user.FirstName, user.LastName, roleNames)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to generate token"})
	}

	// Set JWT as HTTP-only cookie
	c.Cookie(&fiber.Cookie{
		Name:     "jwt_token",
		Value:    token,
		Expires:  time.Now().Add(24 * time.Hour),
		HTTPOnly: true,
		Secure:   false, // Set to true in production with HTTPS
		SameSite: "Lax",
	})

	return c.JSON(fiber.Map{
		"message": "Login successful",
		"user":    user,
	})
}

func LogoutAPI(c *fiber.Ctx) error {
	// Clear JWT cookie
	c.Cookie(&fiber.Cookie{
		Name:     "jwt_token",
		Value:    "",
		Expires:  time.Now().Add(-time.Hour),
		HTTPOnly: true,
	})

	return c.Redirect("/auth/login")
}

func ChangePasswordAPI(c *fiber.Ctx) error {
	type ChangePasswordRequest struct {
		CurrentPassword string `json:"current_password"`
		NewPassword     string `json:"new_password"`
	}

	var req ChangePasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	userID := c.Locals("user_id").(string)

	// Get current user to verify current password
	user, err := database.GetUserByEmail(config.GetDB(), c.Locals("user_email").(string))
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Database error"})
	}

	if !CheckPasswordHash(req.CurrentPassword, user.Password) {
		return c.Status(400).JSON(fiber.Map{"error": "Current password is incorrect"})
	}

	hashedPassword, err := HashPassword(req.NewPassword)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to hash password"})
	}

	if err := database.UpdateUserPassword(config.GetDB(), userID, hashedPassword); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update password"})
	}

	return c.JSON(fiber.Map{"message": "Password changed successfully"})
}

func ForgotPasswordAPI(c *fiber.Ctx) error {
	type ForgotPasswordRequest struct {
		Email string `json:"email"`
	}

	var req ForgotPasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	// Check if user exists
	_, err := database.GetUserByEmail(config.GetDB(), req.Email)
	if err != nil {
		if err == sql.ErrNoRows {
			return c.Status(404).JSON(fiber.Map{"error": "Email not found"})
		}
		return c.Status(500).JSON(fiber.Map{"error": "Database error"})
	}

	// Generate reset token
	resetToken, err := GenerateResetToken()
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to generate reset token"})
	}

	// Store token in database
	if err := database.CreatePasswordResetToken(config.GetDB(), req.Email, resetToken); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to create reset token"})
	}

	// Send reset email
	if err := SendPasswordResetEmail(req.Email, resetToken, c.Get("Host")); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to send reset email"})
	}

	return c.JSON(fiber.Map{"message": "Password reset link sent to your email"})
}

func ResetPasswordAPI(c *fiber.Ctx) error {
	type ResetPasswordRequest struct {
		Token       string `json:"token"`
		NewPassword string `json:"new_password"`
	}

	var req ResetPasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	// Validate token and get email
	email, err := database.ValidatePasswordResetToken(config.GetDB(), req.Token)
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid or expired reset token"})
	}

	// Get user by email
	user, err := database.GetUserByEmail(config.GetDB(), email)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "User not found"})
	}

	// Hash new password
	hashedPassword, err := HashPassword(req.NewPassword)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to hash password"})
	}

	// Update password
	if err := database.UpdateUserPassword(config.GetDB(), user.ID, hashedPassword); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update password"})
	}

	// Mark token as used
	if err := database.MarkPasswordResetTokenAsUsed(config.GetDB(), req.Token); err != nil {
		// Log error but don't fail the request
	}

	return c.JSON(fiber.Map{"message": "Password reset successfully"})
}
