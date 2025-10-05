package fees

import (
	"database/sql"
	"time"

	"github.com/gofiber/fiber/v2"
)

type FeeTypeResponse struct {
	ID          string    `json:"id"`
	Name        string    `json:"name"`
	Code        string    `json:"code"`
	Description *string   `json:"description"`
	IsActive    bool      `json:"is_active"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type CreateFeeTypeRequest struct {
	Name        string `json:"name"`
	Code        string `json:"code"`
	Description string `json:"description"`
}

// GetFeeTypesAPI returns all fee types
func GetFeeTypesAPI(c *fiber.Ctx, db *sql.DB) error {
	query := `SELECT id, name, code, description, is_active, created_at, updated_at 
			  FROM fee_types 
			  WHERE deleted_at IS NULL 
			  ORDER BY name`

	rows, err := db.Query(query)
	if err != nil {
		return fiber.NewError(fiber.StatusInternalServerError, "Failed to fetch fee types")
	}
	defer rows.Close()

	var feeTypes []FeeTypeResponse
	for rows.Next() {
		var feeType FeeTypeResponse
		err := rows.Scan(
			&feeType.ID, &feeType.Name, &feeType.Code, &feeType.Description,
			&feeType.IsActive, &feeType.CreatedAt, &feeType.UpdatedAt,
		)
		if err != nil {
			continue
		}
		feeTypes = append(feeTypes, feeType)
	}

	return c.JSON(fiber.Map{
		"success": true,
		"data":    feeTypes,
	})
}

// CreateFeeTypeAPI creates a new fee type
func CreateFeeTypeAPI(c *fiber.Ctx, db *sql.DB) error {
	var req CreateFeeTypeRequest
	if err := c.BodyParser(&req); err != nil {
		return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
	}

	if req.Name == "" || req.Code == "" {
		return fiber.NewError(fiber.StatusBadRequest, "Name and code are required")
	}

	query := `INSERT INTO fee_types (name, code, description, created_at, updated_at)
			  VALUES ($1, $2, $3, NOW(), NOW()) 
			  RETURNING id, created_at, updated_at`

	var feeType FeeTypeResponse
	err := db.QueryRow(query, req.Name, req.Code, req.Description).Scan(
		&feeType.ID, &feeType.CreatedAt, &feeType.UpdatedAt,
	)
	if err != nil {
		return fiber.NewError(fiber.StatusInternalServerError, "Failed to create fee type")
	}

	feeType.Name = req.Name
	feeType.Code = req.Code
	if req.Description != "" {
		feeType.Description = &req.Description
	}
	feeType.IsActive = true

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"success": true,
		"data":    feeType,
		"message": "Fee type created successfully",
	})
}
