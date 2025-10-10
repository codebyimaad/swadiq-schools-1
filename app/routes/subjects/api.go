package subjects

import (
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"

	"github.com/gofiber/fiber/v2"
)

func SearchSubjectsAPI(c *fiber.Ctx) error {
	query := c.Query("q", "")
	
	var subjects []*models.Subject
	var err error
	
	if query == "" {
		subjects, err = database.GetAllSubjects(config.GetDB())
	} else {
		subjects, err = database.SearchSubjects(config.GetDB(), query)
	}
	
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to search subjects"})
	}

	return c.JSON(fiber.Map{
		"subjects": subjects,
		"count":    len(subjects),
	})
}

func GetSubjectsAPI(c *fiber.Ctx) error {
	departmentID := c.Query("department_id")
	
	var subjects []*models.Subject
	var err error
	
	if departmentID != "" {
		subjects, err = database.GetSubjectsByDepartment(config.GetDB(), departmentID)
	} else {
		subjects, err = database.GetAllSubjects(config.GetDB())
	}
	
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch subjects"})
	}

	return c.JSON(fiber.Map{
		"subjects": subjects,
		"count":    len(subjects),
	})
}

func GetSubjectAPI(c *fiber.Ctx) error {
	subjectID := c.Params("id")
	
	subject, err := database.GetSubjectByID(config.GetDB(), subjectID)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Subject not found"})
	}

	return c.JSON(subject)
}

func CreateSubjectAPI(c *fiber.Ctx) error {
	var subject models.Subject
	if err := c.BodyParser(&subject); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if subject.Name == "" || subject.Code == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Name and code are required"})
	}

	if err := database.CreateSubject(config.GetDB(), &subject); err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error":   "Failed to create subject",
			"details": err.Error(),
		})
	}

	return c.Status(201).JSON(fiber.Map{
		"message": "Subject created successfully",
		"subject": subject,
	})
}

func UpdateSubjectAPI(c *fiber.Ctx) error {
	subjectID := c.Params("id")
	
	var subject models.Subject
	if err := c.BodyParser(&subject); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	subject.ID = subjectID

	if err := database.UpdateSubject(config.GetDB(), &subject); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update subject"})
	}

	return c.JSON(fiber.Map{
		"message": "Subject updated successfully",
		"subject": subject,
	})
}

func DeleteSubjectAPI(c *fiber.Ctx) error {
	subjectID := c.Params("id")

	if err := database.DeleteSubject(config.GetDB(), subjectID); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to delete subject"})
	}

	return c.JSON(fiber.Map{"message": "Subject deleted successfully"})
}
