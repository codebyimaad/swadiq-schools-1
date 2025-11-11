package models

import (
	"database/sql"
	"time"
)

type TeacherAvailability struct {
	ID          string         `json:"id"`
	TeacherID   string         `json:"teacher_id"`
	DayOfWeek   int            `json:"day_of_week"`
	IsAvailable bool           `json:"is_available"`
	StartTime   sql.NullString `json:"start_time"`
	EndTime     sql.NullString `json:"end_time"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
}
