USE social_media_db;

-- Update all user passwords with a known hash
-- This hash is for 'password123' generated with bcrypt rounds=10
UPDATE users SET password = '$2a$10$eImiTXuWVxfM37uY4JANjQ.wbvhdpvPkp7lzuIbvKvjgxJdzWyomu';

-- Verify update
SELECT username, email, 'password123' as password_hint FROM users;