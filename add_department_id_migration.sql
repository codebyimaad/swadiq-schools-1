-- Migration to add department_id column to users table
-- This allows teachers to be assigned to departments

-- Add department_id column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES departments(id);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_users_department_id ON users(department_id);

-- Update the trigger to handle the new column
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();