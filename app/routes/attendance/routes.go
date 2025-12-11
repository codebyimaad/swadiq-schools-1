package attendance

import (
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"
	"swadiq-schools/app/routes/auth"
	"time"

	"github.com/gofiber/fiber/v2"
)

func SetupAttendanceRoutes(app *fiber.App) {
	attendance := app.Group("/attendance")
	attendance.Use(auth.AuthMiddleware)

	// Routes
	attendance.Get("/", AttendancePage)
	attendance.Get("/class/:classId", AttendanceByClassPage)
	attendance.Get("/class/:classId/date/:date", AttendanceByClassAndDatePage)
	attendance.Get("/lesson", LessonAttendancePage)

	// API routes
	api := app.Group("/api/attendance")
	api.Use(auth.AuthMiddleware)
	api.Get("/class/:classId", GetAttendanceByClassAPI)
	api.Get("/class/:classId/date/:date", GetAttendanceByClassAndDateAPI)
	api.Post("/", BatchUpdateAttendanceAPI)
	api.Post("/single", CreateOrUpdateAttendanceAPI)
	api.Get("/stats/:classId", GetAttendanceStatsAPI)
	
	// Timetable-based attendance routes
	api.Get("/timetable/:timetableEntryId/students", GetStudentsByTimetableEntryAPI)
	api.Get("/timetable/:timetableEntryId/date/:date", GetAttendanceByTimetableEntryAPI)
	api.Get("/teacher/:teacherId/date/:date/timetable", GetTimetableEntriesByTeacherAndDateAPI)
	api.Get("/teacher-lessons/:dayOfWeek", GetCurrentUserLessonsAPI)
	api.Get("/all-lessons/:dayOfWeek", GetAllLessonsAPI)
}

func AttendancePage(c *fiber.Ctx) error {
	classes, err := database.GetAllClasses(config.GetDB())
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load classes. Please try again later.",
			"ShowRetry":    true,
			"user":         c.Locals("user"),
		})
	}

	// Get today's date
	today := time.Now().Format("2006-01-02")
	todayFormatted := time.Now().Format("Monday, January 2, 2006")

	return c.Render("attendance/index", fiber.Map{
		"Title":       "Attendance Management - Swadiq Schools",
		"CurrentPage": "attendance",
		"classes":     classes,
		"Today":       today,
		"TodayFormatted": todayFormatted,
		"user":        c.Locals("user"),
	})
}

func AttendanceByClassPage(c *fiber.Ctx) error {
	classID := c.Params("classId")
	if classID == "" {
		return c.Redirect("/attendance")
	}

	// Get class details
	classes, err := database.GetAllClasses(config.GetDB())
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load class information.",
			"user":         c.Locals("user"),
		})
	}

	var selectedClass *models.Class
	for _, class := range classes {
		if class.ID == classID {
			selectedClass = class
			break
		}
	}

	if selectedClass == nil {
		return c.Status(404).Render("error", fiber.Map{
			"Title":        "Class Not Found - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "404",
			"ErrorTitle":   "Class Not Found",
			"ErrorMessage": "The requested class could not be found.",
			"user":         c.Locals("user"),
		})
	}

	// Get students in this class
	students, err := database.GetStudentsByClass(config.GetDB(), classID)
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load students for this class.",
			"user":         c.Locals("user"),
		})
	}

	// Get today's date
	today := time.Now().Format("2006-01-02")

	return c.Render("attendance/class", fiber.Map{
		"Title":       "Attendance for " + selectedClass.Name + " - Swadiq Schools",
		"CurrentPage": "attendance",
		"class":       selectedClass,
		"students":    students,
		"today":       today,
		"user":        c.Locals("user"),
	})
}

func AttendanceByClassAndDatePage(c *fiber.Ctx) error {
	classID := c.Params("classId")
	dateStr := c.Params("date")

	if classID == "" || dateStr == "" {
		return c.Redirect("/attendance")
	}

	// Parse date
	date, err := time.Parse("2006-01-02", dateStr)
	if err != nil {
		return c.Status(400).Render("error", fiber.Map{
			"Title":        "Invalid Date - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "400",
			"ErrorTitle":   "Invalid Date",
			"ErrorMessage": "The provided date format is invalid.",
			"user":         c.Locals("user"),
		})
	}

	// Get class details
	classes, err := database.GetAllClasses(config.GetDB())
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load class information.",
			"user":         c.Locals("user"),
		})
	}

	var selectedClass *models.Class
	for _, class := range classes {
		if class.ID == classID {
			selectedClass = class
			break
		}
	}

	if selectedClass == nil {
		return c.Status(404).Render("error", fiber.Map{
			"Title":        "Class Not Found - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "404",
			"ErrorTitle":   "Class Not Found",
			"ErrorMessage": "The requested class could not be found.",
			"user":         c.Locals("user"),
		})
	}

	// Get students in this class
	students, err := database.GetStudentsByClass(config.GetDB(), classID)
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load students for this class.",
			"user":         c.Locals("user"),
		})
	}

	// Get existing attendance records for this date
	attendanceRecords, err := database.GetAttendanceByClassAndDate(config.GetDB(), classID, date)
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load attendance records.",
			"user":         c.Locals("user"),
		})
	}

	// Create a map for quick lookup of attendance status
	attendanceMap := make(map[string]models.AttendanceStatus)
	for _, record := range attendanceRecords {
		attendanceMap[record.StudentID] = record.Status
	}

	return c.Render("attendance/take", fiber.Map{
		"Title":         "Take Attendance - " + selectedClass.Name + " - Swadiq Schools",
		"CurrentPage":   "attendance",
		"class":         selectedClass,
		"students":      students,
		"date":          dateStr,
		"attendanceMap": attendanceMap,
		"user":          c.Locals("user"),
	})
}

func LessonAttendancePage(c *fiber.Ctx) error {
	timetableEntryID := c.Query("timetable_entry_id")
	dateStr := c.Query("date")
	lessonInfo := c.Query("lesson_info")

	if timetableEntryID == "" || dateStr == "" {
		return c.Redirect("/attendance")
	}

	// Parse date
	date, err := time.Parse("2006-01-02", dateStr)
	if err != nil {
		return c.Status(400).Render("error", fiber.Map{
			"Title":        "Invalid Date - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "400",
			"ErrorTitle":   "Invalid Date",
			"ErrorMessage": "The provided date format is invalid.",
			"user":         c.Locals("user"),
		})
	}

	// Get students for this timetable entry
	students, err := database.GetStudentsByTimetableEntry(config.GetDB(), timetableEntryID)
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load students for this lesson.",
			"user":         c.Locals("user"),
		})
	}

	// Get existing attendance records for this lesson and date
	attendanceRecords, err := database.GetAttendanceByTimetableEntryAndDate(config.GetDB(), timetableEntryID, date)
	if err != nil {
		return c.Status(500).Render("error", fiber.Map{
			"Title":        "Error - Swadiq Schools",
			"CurrentPage":  "attendance",
			"ErrorCode":    "500",
			"ErrorTitle":   "Database Error",
			"ErrorMessage": "Failed to load attendance records.",
			"user":         c.Locals("user"),
		})
	}

	// Create a map for quick lookup of attendance status
	attendanceMap := make(map[string]models.AttendanceStatus)
	for _, record := range attendanceRecords {
		attendanceMap[record.StudentID] = record.Status
	}

	return c.Render("attendance/lesson", fiber.Map{
		"Title":            "Take Lesson Attendance - Swadiq Schools",
		"CurrentPage":      "attendance",
		"students":         students,
		"date":             dateStr,
		"timetableEntryID": timetableEntryID,
		"lessonInfo":       lessonInfo,
		"attendanceMap":    attendanceMap,
		"user":             c.Locals("user"),
	})
}
