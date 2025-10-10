package papers

import (
	"fmt"
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"

	"github.com/gofiber/fiber/v2"
)

func GetPapersBySubjectAPI(c *fiber.Ctx) error {
	subjectID := c.Params("subjectId")
	
	papers, err := database.GetPapersBySubject(config.GetDB(), subjectID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch papers"})
	}

	return c.JSON(fiber.Map{
		"papers": papers,
		"count":  len(papers),
	})
}

func GetPapersAPI(c *fiber.Ctx) error {
	papers, err := database.GetAllPapers(config.GetDB())
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch papers"})
	}

	return c.JSON(fiber.Map{
		"papers": papers,
		"count":  len(papers),
	})
}

func GetPaperAPI(c *fiber.Ctx) error {
	paperID := c.Params("id")

	paper, err := database.GetPaperByID(config.GetDB(), paperID)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Paper not found"})
	}

	return c.JSON(paper)
}

func CreatePaperAPI(c *fiber.Ctx) error {
	var paper models.Paper
	if err := c.BodyParser(&paper); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if paper.SubjectID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Subject ID is required"})
	}

	// Always generate paper code based on subject code, ignoring any provided code
	// Get the subject to get its code
	subject, err := database.GetSubjectByID(config.GetDB(), paper.SubjectID)
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid subject ID"})
	}

	// Get existing papers for this subject to determine the next paper number
	existingPapers, err := database.GetPapersBySubject(config.GetDB(), paper.SubjectID)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch existing papers for subject"})
	}

	// Determine the next paper number by finding the highest existing number and incrementing
	nextPaperNumber := 1
	for _, existingPaper := range existingPapers {
		// Extract the number from the paper code (e.g., "MATH-2" -> 2)
		if len(existingPaper.Code) > len(subject.Code)+1 {
			// Check if the code starts with the subject code followed by a dash
			if existingPaper.Code[:len(subject.Code)] == subject.Code && existingPaper.Code[len(subject.Code)] == '-' {
				// Try to parse the number after the dash
				var num int
				_, err := fmt.Sscanf(existingPaper.Code[len(subject.Code)+1:], "%d", &num)
				if err == nil && num >= nextPaperNumber {
					nextPaperNumber = num + 1
				}
			}
		}
	}

	paper.Code = fmt.Sprintf("%s-%d", subject.Code, nextPaperNumber)

	if err := database.CreatePaper(config.GetDB(), &paper); err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error":   "Failed to create paper",
			"details": err.Error(),
		})
	}

	return c.Status(201).JSON(fiber.Map{
		"message": "Paper created successfully",
		"paper":   paper,
	})
}

func UpdatePaperAPI(c *fiber.Ctx) error {
	paperID := c.Params("id")

	var updatedPaper models.Paper
	if err := c.BodyParser(&updatedPaper); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	// Get the existing paper to preserve the auto-generated code
	existingPaper, err := database.GetPaperByID(config.GetDB(), paperID)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Paper not found"})
	}

	// Update only the fields that can be changed, preserving the auto-generated code
	paperToUpdate := &models.Paper{
		ID:        paperID,
		SubjectID: updatedPaper.SubjectID,
		Code:      existingPaper.Code, // Preserve the auto-generated code
		// TeacherID is now handled at the class level
		IsActive:  updatedPaper.IsActive,
	}

	if err := database.UpdatePaper(config.GetDB(), paperToUpdate); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update paper"})
	}

	return c.JSON(fiber.Map{
		"message": "Paper updated successfully",
		"paper":   paperToUpdate,
	})
}

func DeletePaperAPI(c *fiber.Ctx) error {
	paperID := c.Params("id")

	if err := database.DeletePaper(config.GetDB(), paperID); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to delete paper"})
	}

	return c.JSON(fiber.Map{"message": "Paper deleted successfully"})
}
