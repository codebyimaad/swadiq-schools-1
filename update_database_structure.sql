-- Update database structure to remove teacher_id from papers table and properly use class_papers for teacher assignments

-- Step 1: Drop the existing papers table (we'll recreate it without teacher_id)
DROP TABLE IF EXISTS papers CASCADE;

-- Step 2: Recreate the papers table without teacher_id
CREATE TABLE IF NOT EXISTS papers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    code VARCHAR(20) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Step 3: Ensure class_papers table exists with proper structure
CREATE TABLE IF NOT EXISTS class_papers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    paper_id UUID NOT NULL REFERENCES papers(id) ON DELETE CASCADE,
    teacher_id UUID REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    UNIQUE (class_id, paper_id)
);

-- Step 4: Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_papers_subject_id ON papers(subject_id);
CREATE INDEX IF NOT EXISTS idx_class_papers_class_id ON class_papers(class_id);
CREATE INDEX IF NOT EXISTS idx_class_papers_paper_id ON class_papers(paper_id);
CREATE INDEX IF NOT EXISTS idx_class_papers_teacher_id ON class_papers(teacher_id);

-- Step 5: Create a function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Step 6: Create triggers for automatic updated_at updates
DROP TRIGGER IF EXISTS update_papers_updated_at ON papers;
CREATE TRIGGER update_papers_updated_at BEFORE UPDATE ON papers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_class_papers_updated_at ON class_papers;
CREATE TRIGGER update_class_papers_updated_at BEFORE UPDATE ON class_papers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();