package departments

import (
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"

	"github.com/gofiber/fiber/v2"
)

func GetDepartmentsAPI(c *fiber.Ctx) error {
	departments, err := database.GetAllDepartments(config.GetDB())
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch departments"})
	}

	return c.JSON(fiber.Map{
		"departments": departments,
		"count":       len(departments),
	})
}

func CreateDepartmentAPI(c *fiber.Ctx) error {
	type CreateDepartmentRequest struct {
		Name                string  `json:"name"`
		Code                string  `json:"code"`
		Description         *string `json:"description"`
		HeadOfDepartmentID  *string `json:"head_of_department_id"`
		AssistantHeadID     *string `json:"assistant_head_id"`
	}

	var req CreateDepartmentRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	if req.Name == "" || req.Code == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Name and code are required"})
	}

	department := &models.Department{
		Name:               req.Name,
		Code:               req.Code,
		Description:        req.Description,
		HeadOfDepartmentID: req.HeadOfDepartmentID,
		AssistantHeadID:    req.AssistantHeadID,
	}

	if err := database.CreateDepartment(config.GetDB(), department); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to create department"})
	}

	return c.Status(201).JSON(department)
}

func UpdateDepartmentAPI(c *fiber.Ctx) error {
	departmentID := c.Params("id")
	if departmentID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Department ID is required"})
	}

	type UpdateDepartmentRequest struct {
		Name                string  `json:"name"`
		Code                string  `json:"code"`
		Description         *string `json:"description"`
		HeadOfDepartmentID  *string `json:"head_of_department_id"`
		AssistantHeadID     *string `json:"assistant_head_id"`
	}

	var req UpdateDepartmentRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
	}

	if req.Name == "" || req.Code == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Name and code are required"})
	}

	department := &models.Department{
		ID:                 departmentID,
		Name:               req.Name,
		Code:               req.Code,
		Description:        req.Description,
		HeadOfDepartmentID: req.HeadOfDepartmentID,
		AssistantHeadID:    req.AssistantHeadID,
	}

	if err := database.UpdateDepartment(config.GetDB(), department); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update department"})
	}

	return c.Status(200).JSON(department)
}

func DeleteDepartmentAPI(c *fiber.Ctx) error {
	departmentID := c.Params("id")
	if departmentID == "" {
		return c.Status(400).JSON(fiber.Map{"error": "Department ID is required"})
	}

	if err := database.DeleteDepartment(config.GetDB(), departmentID); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to delete department"})
	}

	return c.SendStatus(204)
}

func GetDepartmentOverviewAPI(c *fiber.Ctx) error {
	db := config.GetDB()
	
	query := `SELECT d.id, d.name, d.code,
		h.first_name as head_first_name, h.last_name as head_last_name,
		a.first_name as assistant_first_name, a.last_name as assistant_last_name,
		(CASE WHEN h.id IS NOT NULL THEN 1 ELSE 0 END + CASE WHEN a.id IS NOT NULL THEN 1 ELSE 0 END) as teacher_count
		FROM departments d
		LEFT JOIN users h ON d.head_of_department_id = h.id AND h.is_active = true
		LEFT JOIN users a ON d.assistant_head_id = a.id AND a.is_active = true
		WHERE d.is_active = true
		ORDER BY d.name`
	
	rows, err := db.Query(query)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to fetch department overview"})
	}
	defer rows.Close()

	departments := make([]map[string]interface{}, 0)
	for rows.Next() {
		var deptID, deptName, deptCode string
		var headFirstName, headLastName, assistantFirstName, assistantLastName *string
		var teacherCount int
		
		if err := rows.Scan(&deptID, &deptName, &deptCode, &headFirstName, &headLastName, &assistantFirstName, &assistantLastName, &teacherCount); err == nil {
			headName := "Not assigned"
			if headFirstName != nil && headLastName != nil {
				headName = *headFirstName + " " + *headLastName
			}
			
			assistantName := "Not assigned"
			if assistantFirstName != nil && assistantLastName != nil {
				assistantName = *assistantFirstName + " " + *assistantLastName
			}
			
			departments = append(departments, map[string]interface{}{
				"id": deptID,
				"name": deptName,
				"code": deptCode,
				"teacher_count": teacherCount,
				"head_name": headName,
				"assistant_name": assistantName,
			})
		}
	}

	return c.JSON(fiber.Map{
		"departments": departments,
		"count": len(departments),
	})
}

