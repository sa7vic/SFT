-- Database Triggers for Social Media Application
-- Author: DBMS Project - Nirvana
-- Description: Triggers for data validation and automatic updates

-- ============================================
-- 1. PREVENT SELF-FOLLOWING
-- ============================================
DELIMITER //
CREATE TRIGGER prevent_self_follow
BEFORE INSERT ON follows
FOR EACH ROW
BEGIN
    IF NEW.follower_id = NEW.following_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Users cannot follow themselves';
    END IF;
END //
DELIMITER ;

-- ============================================
-- 2. UPDATE LIKES COUNT ON INSERT
-- ============================================
DELIMITER //
CREATE TRIGGER update_likes_count_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts 
    SET likes_count = likes_count + 1 
    WHERE id = NEW.post_id;
END //
DELIMITER ;

-- ============================================
-- 3. UPDATE LIKES COUNT ON DELETE
-- ============================================
DELIMITER //
CREATE TRIGGER update_likes_count_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts 
    SET likes_count = GREATEST(likes_count - 1, 0)
    WHERE id = OLD.post_id;
END //
DELIMITER ;

-- ============================================
-- 4. PREVENT DUPLICATE LIKES
-- ============================================
-- This is handled by UNIQUE constraint in schema
-- but we can add a trigger for custom error message
DELIMITER //
CREATE TRIGGER prevent_duplicate_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM likes WHERE post_id = NEW.post_id AND user_id = NEW.user_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has already liked this post';
    END IF;
END //
DELIMITER ;

-- ============================================
-- 5. VALIDATE POST CONTENT
-- ============================================
DELIMITER //
CREATE TRIGGER validate_post_content
BEFORE INSERT ON posts
FOR EACH ROW
BEGIN
    IF LENGTH(TRIM(NEW.content)) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post content cannot be empty';
    END IF;
    
    IF LENGTH(NEW.content) > 5000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post content exceeds maximum length of 5000 characters';
    END IF;
END //
DELIMITER ;

-- ============================================
-- 6. VALIDATE COMMENT CONTENT
-- ============================================
DELIMITER //
CREATE TRIGGER validate_comment_content
BEFORE INSERT ON comments
FOR EACH ROW
BEGIN
    IF LENGTH(TRIM(NEW.content)) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comment content cannot be empty';
    END IF;
    
    IF LENGTH(NEW.content) > 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comment content exceeds maximum length of 1000 characters';
    END IF;
END //
DELIMITER ;

-- ============================================
-- 7. LOG USER REGISTRATION
-- ============================================
-- First create an audit table
CREATE TABLE IF NOT EXISTS user_audit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (timestamp)
);

DELIMITER //
CREATE TRIGGER log_user_registration
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_audit (user_id, action, timestamp)
    VALUES (NEW.id, 'USER_REGISTERED', NOW());
END //
DELIMITER ;

-- ============================================
-- 8. VALIDATE USERNAME FORMAT
-- ============================================
DELIMITER //
CREATE TRIGGER validate_username
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.username) < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username must be at least 3 characters long';
    END IF;
    
    IF NEW.username REGEXP '[^a-zA-Z0-9_]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username can only contain letters, numbers, and underscores';
    END IF;
END //
DELIMITER ;

-- ============================================
-- 9. VALIDATE EMAIL FORMAT
-- ============================================
DELIMITER //
CREATE TRIGGER validate_email
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END //
DELIMITER ;

-- ============================================
-- VERIFY TRIGGERS CREATED
-- ============================================
-- Run this to check all triggers:
-- SHOW TRIGGERS FROM social_media_db;