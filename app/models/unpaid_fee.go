package models

import "time"

// UnpaidFee represents a fee that has not been fully paid
type UnpaidFee struct {
	ID          string    `json:"id"`
	StudentID   string    `json:"student_id"`
	FeeTypeID   string    `json:"fee_type_id"`
	FeeTypeName string    `json:"fee_type_name"`
	Title       string    `json:"title"`
	TotalAmount float64   `json:"total_amount"`
	PaidAmount  float64   `json:"paid_amount"`
	Balance     float64   `json:"balance"`
	DueDate     time.Time `json:"due_date"`
	IsOverdue   bool      `json:"is_overdue"`
}
