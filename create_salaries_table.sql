CREATE TABLE salaries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    teacher_id UUID NOT NULL REFERENCES users(id),
    amount INTEGER NOT NULL,
    payment_frequency VARCHAR(20) NOT NULL CHECK (payment_frequency IN ('daily', 'weekly', 'monthly')),
    payment_date DATE NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE,
    paid_amount INTEGER DEFAULT 0,
    balance INTEGER GENERATED ALWAYS AS (amount - paid_amount) STORED,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);
