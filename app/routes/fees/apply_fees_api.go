package fees

import (
	"database/sql"
	"time"

	"github.com/gofiber/fiber/v2"
)

type ApplyFeeRequest struct {
	FeeTypeID      string    `json:"fee_type_id"`
	Amount         float64   `json:"amount"`
	DueDate        time.Time `json:"due_date"`
	AcademicYearID string    `json:"academic_year_id"`
	TermID         string    `json:"term_id"`
}

// ApplyFeesAPI applies fees based on fee type scope
func ApplyFeesAPI(c *fiber.Ctx, db *sql.DB) error {
	var req ApplyFeeRequest
	if err := c.BodyParser(&req); err != nil {
		return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
	}

	// Get fee type details
	var feeType struct {
		Name            string
		Scope           string
		TargetClassID   *string
		TargetStudentID *string
	}

	err := db.QueryRow(`
		SELECT name, COALESCE(scope, 'manual'), target_class_id, target_student_id 
		FROM fee_types WHERE id = $1 AND is_active = true
	`, req.FeeTypeID).Scan(&feeType.Name, &feeType.Scope, &feeType.TargetClassID, &feeType.TargetStudentID)

	if err != nil {
		return fiber.NewError(fiber.StatusNotFound, "Fee type not found")
	}

	var studentIDs []string

	// Get student IDs based on scope
	switch feeType.Scope {
	case "all_students":
		rows, err := db.Query("SELECT id FROM students WHERE deleted_at IS NULL")
		if err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "Failed to fetch students")
		}
		defer rows.Close()

		for rows.Next() {
			var studentID string
			rows.Scan(&studentID)
			studentIDs = append(studentIDs, studentID)
		}

	case "class":
		if feeType.TargetClassID == nil {
			return fiber.NewError(fiber.StatusBadRequest, "Class ID required for class scope")
		}
		rows, err := db.Query("SELECT student_id FROM class_students WHERE class_id = $1", *feeType.TargetClassID)
		if err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "Failed to fetch class students")
		}
		defer rows.Close()

		for rows.Next() {
			var studentID string
			rows.Scan(&studentID)
			studentIDs = append(studentIDs, studentID)
		}

	case "all_classes":
		rows, err := db.Query("SELECT DISTINCT student_id FROM class_students")
		if err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "Failed to fetch all class students")
		}
		defer rows.Close()

		for rows.Next() {
			var studentID string
			rows.Scan(&studentID)
			studentIDs = append(studentIDs, studentID)
		}

	case "student":
		if feeType.TargetStudentID == nil {
			return fiber.NewError(fiber.StatusBadRequest, "Student ID required for student scope")
		}
		studentIDs = append(studentIDs, *feeType.TargetStudentID)

	default:
		return fiber.NewError(fiber.StatusBadRequest, "Invalid fee scope")
	}

	// Apply fees to all selected students
	for _, studentID := range studentIDs {
		_, err := db.Exec(`
			INSERT INTO fees (student_id, fee_type_id, academic_year_id, term_id, title, amount, balance, due_date, created_at, updated_at)
			VALUES ($1, $2, NULLIF($3, ''), NULLIF($4, ''), $5, $6, $6, $7, NOW(), NOW())
		`, studentID, req.FeeTypeID, req.AcademicYearID, req.TermID, feeType.Name, req.Amount, req.DueDate)

		if err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "Failed to apply fee to student: "+studentID)
		}
	}

	return c.JSON(fiber.Map{
		"success":        true,
		"message":        "Fees applied successfully",
		"students_count": len(studentIDs),
	})
}
