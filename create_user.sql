-- Create user: Imaad Dean
INSERT INTO users (email, password, first_name, last_name, phone, is_active, created_at, updated_at)
VALUES (
    'imaad.dean@gmail.com',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- bcrypt hash of 'Ertdfgx@0'
    'Imaad',
    'Dean',
    '0700752105',
    true,
    NOW(),
    NOW()
);

-- Assign class_teacher role
INSERT INTO user_roles (user_id, role_id, created_at)
SELECT u.id, r.id, NOW()
FROM users u, roles r
WHERE u.email = 'imaad.dean@gmail.com' AND r.name = 'class_teacher';
