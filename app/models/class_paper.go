package models

import "time"

// ClassPaper represents the relationship between a class and a paper with a specific teacher
type ClassPaper struct {
	ID        string     `json:"id" gorm:"primaryKey;type:uuid;default:gen_random_uuid()" validate:"required,uuid"`
	ClassID   string     `json:"class_id" gorm:"not null;index;type:uuid" validate:"required,uuid"`
	PaperID   string     `json:"paper_id" gorm:"not null;index;type:uuid" validate:"required,uuid"`
	TeacherID *string    `json:"teacher_id,omitempty" gorm:"index;type:uuid" validate:"omitempty,uuid"`
	IsActive  bool       `json:"is_active" gorm:"default:true"`
	CreatedAt time.Time  `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt time.Time  `json:"updated_at" gorm:"autoUpdateTime"`
	DeletedAt *time.Time `json:"deleted_at,omitempty" gorm:"index"`

	// Relationships
	Class   *Class `json:"class,omitempty" gorm:"foreignKey:ClassID;references:ID"`
	Paper   *Paper `json:"paper,omitempty" gorm:"foreignKey:PaperID;references:ID"`
	Teacher *User  `json:"teacher,omitempty" gorm:"foreignKey:TeacherID;references:ID"`
}