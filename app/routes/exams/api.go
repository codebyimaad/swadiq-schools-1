package exams

import (
	"database/sql"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"

	"github.com/gofiber/fiber/v2"
)

// GetAllExams returns all exams or exams for a specific class
func GetAllExams(c *fiber.Ctx, db *sql.DB) error {
	classID := c.Query("class_id")
	exams, err := database.GetAllExams(db, classID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to retrieve exams"})
	}
	return c.JSON(exams)
}

// GetExam returns a specific exam by ID
func GetExam(c *fiber.Ctx, db *sql.DB) error {
	examID := c.Params("id")
	exam, err := database.GetExamByID(db, examID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "Exam not found"})
	}
	return c.JSON(exam)
}

// CreateExam creates a new exam
func CreateExam(c *fiber.Ctx, db *sql.DB) error {
	var exam models.Exam
	if err := c.BodyParser(&exam); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if err := database.CreateExam(db, &exam); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to create exam"})
	}

	return c.Status(fiber.StatusCreated).JSON(exam)
}

// UpdateExam updates an existing exam
func UpdateExam(c *fiber.Ctx, db *sql.DB) error {
	examID := c.Params("id")
	var exam models.Exam
	if err := c.BodyParser(&exam); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	exam.ID = examID
	if err := database.UpdateExam(db, &exam); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to update exam"})
	}

	return c.JSON(exam)
}

// DeleteExam deletes an exam
func DeleteExam(c *fiber.Ctx, db *sql.DB) error {
	examID := c.Params("id")
	if err := database.DeleteExam(db, examID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Failed to delete exam"})
	}
	return c.SendStatus(fiber.StatusNoContent)
}