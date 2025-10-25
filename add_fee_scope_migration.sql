-- Add scope fields to fee_types table
ALTER TABLE fee_types ADD COLUMN IF NOT EXISTS scope VARCHAR(20) DEFAULT 'manual' CHECK (scope IN ('manual', 'class', 'all_classes', 'student', 'all_students'));
ALTER TABLE fee_types ADD COLUMN IF NOT EXISTS target_class_id UUID REFERENCES classes(id) ON DELETE CASCADE;
ALTER TABLE fee_types ADD COLUMN IF NOT EXISTS target_student_id UUID REFERENCES students(id) ON DELETE CASCADE;

-- Add index for better performance
CREATE INDEX IF NOT EXISTS idx_fee_types_scope ON fee_types(scope);
CREATE INDEX IF NOT EXISTS idx_fee_types_target_class ON fee_types(target_class_id);
CREATE INDEX IF NOT EXISTS idx_fee_types_target_student ON fee_types(target_student_id);
