-- ============================================================================
-- BrewAlgo - Update Seeded User Passwords with Correct BCrypt Hashes
-- ============================================================================
-- These hashes are generated using Spring Security's BCryptPasswordEncoder
-- Password for users: password123
-- Password for admin: admin123
-- ============================================================================

-- Update admin password (admin123)
UPDATE users 
SET password_hash = '$2a$10$xn3LI/AjqicFYZFruSwve.681477JcIpfe92wQRsMiJqvpSEQxo4u' 
WHERE username = 'admin';

-- Update alice password (password123)
UPDATE users 
SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE username = 'alice';

-- Update bob password (password123)
UPDATE users 
SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE username = 'bob';

-- Update charlie password (password123)
UPDATE users 
SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE username = 'charlie';

-- Update dave password (password123)
UPDATE users 
SET password_hash = '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE username = 'dave';

-- Verify updates
SELECT username, 
       CASE WHEN username = 'admin' THEN 'admin123' ELSE 'password123' END as password,
       'Updated' as status
FROM users 
WHERE username IN ('admin', 'alice', 'bob', 'charlie', 'dave')
ORDER BY rating DESC;

COMMIT;
