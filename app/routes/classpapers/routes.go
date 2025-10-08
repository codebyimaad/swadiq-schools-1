package classpapers

import (
	"swadiq-schools/app/config"
	"swadiq-schools/app/database"
	"swadiq-schools/app/models"
	"swadiq-schools/app/routes/auth"

	"github.com/gofiber/fiber/v2"
)

func SetupClassPapersRoutes(app *fiber.App) {
	classPapers := app.Group("/class-papers")
	classPapers.Use(auth.AuthMiddleware)

	// Web routes
	classPapers.Get("/", ClassPapersPage)

	// API routes
	api := app.Group("/api/class-papers")
	api.Use(auth.AuthMiddleware)
	api.Get("/class/:classId", GetClassPapersByClassAPI)
	api.Post("/", CreateClassPaperAPI)
	api.Put("/:id", UpdateClassPaperAPI)
	api.Delete("/:id", DeleteClassPaperAPI)
}

func ClassPapersPage(c *fiber.Ctx) error {
	// Get all classes
	classes, err := database.GetAllClasses(config.GetDB())
	if err != nil {
		classes = []*models.Class{}
	}

	// Get all papers
	papers, err := database.GetAllPapers(config.GetDB())
	if err != nil {
		papers = []*models.Paper{}
	}

	// Get all teachers
	teachers, err := database.GetAllTeachers(config.GetDB())
	if err != nil {
		teachers = []*models.User{}
	}

	user := c.Locals("user").(*models.User)
	return c.Render("classpapers/index", fiber.Map{
		"Title":       "Class Papers - Swadiq Schools",
		"CurrentPage": "class-papers",
		"classes":     classes,
		"papers":      papers,
		"teachers":    teachers,
		"user":        user,
		"FirstName":   user.FirstName,
		"LastName":    user.LastName,
		"Email":       user.Email,
	})
}
