-- Remove department_id column from users table
ALTER TABLE users DROP COLUMN department_id;

-- Create junction table for many-to-many relationship
CREATE TABLE user_departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    department_id UUID NOT NULL REFERENCES departments(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, department_id)
);

-- Insert user-department relationships
INSERT INTO user_departments (user_id, department_id) VALUES
('ed408400-a5d1-477e-925f-4f525ae810db', '2b93eb17-fba0-46d7-ae2b-80ba652faacc'), -- Renee Salazar -> English
('77d5ac90-58e3-4257-bc55-f04e417a4601', '1d0663c9-f914-4ba5-baa8-453a768886f0'), -- imaad ssebintu -> Mathematics
('77d5ac90-58e3-4257-bc55-f04e417a4601', '225609db-adf9-4c55-83fb-5e880dd9481e'), -- imaad ssebintu -> Science
('77d5ac90-58e3-4257-bc55-f04e417a4601', 'dc13b32b-cb13-4fef-9d38-79b24f6c6b60'), -- imaad ssebintu -> Social Studies
('2f5932e3-af2e-413e-8bc4-59113d16a366', '1d0663c9-f914-4ba5-baa8-453a768886f0'), -- imaad dean -> Mathematics
('2f5932e3-af2e-413e-8bc4-59113d16a366', '225609db-adf9-4c55-83fb-5e880dd9481e'), -- imaad dean -> Science
('2f5932e3-af2e-413e-8bc4-59113d16a366', 'dc13b32b-cb13-4fef-9d38-79b24f6c6b60'), -- imaad dean -> Social Studies
('4dd408fa-7666-4d4c-b8e2-251e999f3175', '225609db-adf9-4c55-83fb-5e880dd9481e'), -- James Gonzalez -> Science
('5fa24ba5-d4c3-4480-97de-a42f7706c79a', '2b93eb17-fba0-46d7-ae2b-80ba652faacc'), -- Nicole Huff -> English
('798b1752-83d0-416c-a097-056328c7d56c', '1d0663c9-f914-4ba5-baa8-453a768886f0'), -- Adam Gomez -> Mathematics
('8dfb246c-c3ff-411e-aecd-2fa9ef426afe', 'dc13b32b-cb13-4fef-9d38-79b24f6c6b60'); -- ssebintu muniir -> Social Studies