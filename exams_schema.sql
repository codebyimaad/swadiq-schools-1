-- Create exams table
CREATE TABLE IF NOT EXISTS exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    class_id UUID NOT NULL REFERENCES classes(id),
    academic_year_id UUID REFERENCES academic_years(id),
    term_id UUID REFERENCES terms(id),
    paper_id UUID NOT NULL REFERENCES papers(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_exams_class_id ON exams(class_id);
CREATE INDEX IF NOT EXISTS idx_exams_academic_year_id ON exams(academic_year_id);
CREATE INDEX IF NOT EXISTS idx_exams_term_id ON exams(term_id);
CREATE INDEX IF NOT EXISTS idx_exams_paper_id ON exams(paper_id);
CREATE INDEX IF NOT EXISTS idx_exams_start_time ON exams(start_time);
CREATE INDEX IF NOT EXISTS idx_exams_deleted_at ON exams(deleted_at);