-- Script to drop all tables in the Swadiq Schools Management System database
-- Tables are dropped in reverse order of creation to avoid foreign key constraint issues

-- Drop all triggers first
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP TRIGGER IF EXISTS update_roles_updated_at ON roles;
DROP TRIGGER IF EXISTS update_parents_updated_at ON parents;
DROP TRIGGER IF EXISTS update_classes_updated_at ON classes;
DROP TRIGGER IF EXISTS update_students_updated_at ON students;
DROP TRIGGER IF EXISTS update_student_parents_updated_at ON student_parents;
DROP TRIGGER IF EXISTS update_departments_updated_at ON departments;
DROP TRIGGER IF EXISTS update_subjects_updated_at ON subjects;
DROP TRIGGER IF EXISTS update_class_subjects_updated_at ON class_subjects;
DROP TRIGGER IF EXISTS update_academic_years_updated_at ON academic_years;
DROP TRIGGER IF EXISTS update_terms_updated_at ON terms;
DROP TRIGGER IF EXISTS update_class_promotions_updated_at ON class_promotions;
DROP TRIGGER IF EXISTS update_attendance_updated_at ON attendance;
DROP TRIGGER IF EXISTS update_fee_types_updated_at ON fee_types;
DROP TRIGGER IF EXISTS update_fees_updated_at ON fees;
DROP TRIGGER IF EXISTS update_payments_updated_at ON payments;
DROP TRIGGER IF EXISTS update_payment_allocations_updated_at ON payment_allocations;
DROP TRIGGER IF EXISTS update_papers_updated_at ON papers;
DROP TRIGGER IF EXISTS update_grades_updated_at ON grades;
DROP TRIGGER IF EXISTS update_exams_updated_at ON exams;
DROP TRIGGER IF EXISTS update_results_updated_at ON results;
DROP TRIGGER IF EXISTS update_schedules_updated_at ON schedules;
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
DROP TRIGGER IF EXISTS update_expenses_updated_at ON expenses;
DROP TRIGGER IF EXISTS update_notifications_updated_at ON notifications;

-- Drop function (use CASCADE to handle any remaining dependencies)
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Drop join tables first (they have foreign key dependencies)
DROP TABLE IF EXISTS role_permissions CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS student_parents CASCADE;
DROP TABLE IF EXISTS class_subjects CASCADE;
DROP TABLE IF EXISTS payment_allocations CASCADE;

-- Drop tables with foreign key dependencies
DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS permissions CASCADE;
DROP TABLE IF EXISTS results CASCADE;
DROP TABLE IF EXISTS exams CASCADE;
DROP TABLE IF EXISTS papers CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS schedules CASCADE;
DROP TABLE IF EXISTS expenses CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS fees CASCADE;
DROP TABLE IF EXISTS fee_types CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS class_promotions CASCADE;
DROP TABLE IF EXISTS terms CASCADE;
DROP TABLE IF EXISTS academic_years CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS parents CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;

-- Drop extensions
DROP EXTENSION IF EXISTS "uuid-ossp";