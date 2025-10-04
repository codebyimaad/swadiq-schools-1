package fees

import (
	"swadiq-schools/app/config"
	"swadiq-schools/app/routes/auth"

	"github.com/gofiber/fiber/v2"
)

// SetupFeesRoutes sets up the fees routes
func SetupFeesRoutes(app *fiber.App) {
	// Group for fees routes with authentication middleware
	fees := app.Group("/fees")
	fees.Use(auth.AuthMiddleware)

	// API routes for fees
	feesAPI := app.Group("/api/fees")
	feesAPI.Use(auth.AuthMiddleware)

	// Web routes
	fees.Get("/", func(c *fiber.Ctx) error {
		return c.Render("fees/index", fiber.Map{
			"Title":       "Fees Management - Swadiq Schools",
			"CurrentPage": "fees",
		})
	})

	// API routes
	feesAPI.Get("/", func(c *fiber.Ctx) error {
		return GetFeesAPI(c, config.GetDB())
	})

	feesAPI.Get("/:id", func(c *fiber.Ctx) error {
		return GetFeeByIDAPI(c, config.GetDB())
	})

	feesAPI.Post("/", func(c *fiber.Ctx) error {
		return CreateFeeAPI(c, config.GetDB())
	})

	feesAPI.Put("/:id", func(c *fiber.Ctx) error {
		return UpdateFeeAPI(c, config.GetDB())
	})

	feesAPI.Delete("/:id", func(c *fiber.Ctx) error {
		return DeleteFeeAPI(c, config.GetDB())
	})

	feesAPI.Post("/:id/pay", func(c *fiber.Ctx) error {
		return MarkFeeAsPaidAPI(c, config.GetDB())
	})

	feesAPI.Get("/stats", func(c *fiber.Ctx) error {
		return GetFeeStatsAPI(c, config.GetDB())
	})
}
