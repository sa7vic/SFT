-- Stored Procedures for Social Media Database
-- Author: DBMS Project - Nirvana
-- Description: Stored procedures for common database operations

-- ============================================
-- 1. CREATE POST PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE CreatePost(
    IN p_user_id INT,
    IN p_content TEXT,
    IN p_image_url VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error creating post' as message;
    END;
    
    START TRANSACTION;
    
    INSERT INTO posts (user_id, content, image_url, created_at)
    VALUES (p_user_id, p_content, p_image_url, NOW());
    
    COMMIT;
    
    SELECT LAST_INSERT_ID() as post_id, 'Post created successfully' as message;
END //
DELIMITER ;

-- ============================================
-- 2. GET USER STATS PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE GetUserStats(IN p_user_id INT)
BEGIN
    SELECT 
        u.id,
        u.username,
        u.email,
        u.created_at as joined_date,
        (SELECT COUNT(*) FROM posts WHERE user_id = p_user_id) as posts_count,
        (SELECT COUNT(*) FROM follows WHERE following_id = p_user_id) as followers_count,
        (SELECT COUNT(*) FROM follows WHERE follower_id = p_user_id) as following_count,
        (SELECT COUNT(*) FROM likes l JOIN posts p ON l.post_id = p.id WHERE p.user_id = p_user_id) as total_likes_received,
        (SELECT COUNT(*) FROM comments WHERE user_id = p_user_id) as comments_made
    FROM users u
    WHERE u.id = p_user_id;
END //
DELIMITER ;

-- ============================================
-- 3. FOLLOW USER PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE FollowUser(
    IN p_follower_id INT,
    IN p_following_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error following user' as message;
    END;
    
    START TRANSACTION;
    
    -- Check if already following
    IF EXISTS (SELECT 1 FROM follows WHERE follower_id = p_follower_id AND following_id = p_following_id) THEN
        SELECT 'Already following this user' as message;
    ELSE
        INSERT INTO follows (follower_id, following_id, created_at)
        VALUES (p_follower_id, p_following_id, NOW());
        
        COMMIT;
        SELECT 'Successfully followed user' as message;
    END IF;
END //
DELIMITER ;

-- ============================================
-- 4. UNFOLLOW USER PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE UnfollowUser(
    IN p_follower_id INT,
    IN p_following_id INT
)
BEGIN
    DELETE FROM follows 
    WHERE follower_id = p_follower_id 
    AND following_id = p_following_id;
    
    IF ROW_COUNT() > 0 THEN
        SELECT 'Successfully unfollowed user' as message;
    ELSE
        SELECT 'Not following this user' as message;
    END IF;
END //
DELIMITER ;

-- ============================================
-- 5. DELETE POST PROCEDURE (CASCADE)
-- ============================================
DELIMITER //
CREATE PROCEDURE DeletePost(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error deleting post' as message;
    END;
    
    START TRANSACTION;
    
    -- Check if user owns the post
    IF EXISTS (SELECT 1 FROM posts WHERE id = p_post_id AND user_id = p_user_id) THEN
        DELETE FROM posts WHERE id = p_post_id;
        COMMIT;
        SELECT 'Post deleted successfully' as message;
    ELSE
        SELECT 'Unauthorized or post not found' as message;
    END IF;
END //
DELIMITER ;

-- ============================================
-- 6. GET USER FEED PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE GetUserFeed(
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        p.id,
        p.content,
        p.image_url,
        p.created_at,
        u.username,
        u.profile_pic,
        p.likes_count,
        (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count,
        (SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = p_user_id) as user_liked
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE p.user_id IN (
        SELECT following_id FROM follows WHERE follower_id = p_user_id
        UNION
        SELECT p_user_id
    )
    ORDER BY p.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END //
DELIMITER ;

-- ============================================
-- 7. SEARCH POSTS PROCEDURE
-- ============================================
DELIMITER //
CREATE PROCEDURE SearchPosts(
    IN p_search_term VARCHAR(255),
    IN p_limit INT
)
BEGIN
    SELECT 
        p.id,
        p.content,
        p.image_url,
        p.created_at,
        u.username,
        u.profile_pic,
        p.likes_count,
        (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE p.content LIKE CONCAT('%', p_search_term, '%')
    ORDER BY p.created_at DESC
    LIMIT p_limit;
END //
DELIMITER ;

-- ============================================
-- USAGE EXAMPLES:
-- ============================================
-- CALL CreatePost(1, 'This is my new post!', NULL);
-- CALL GetUserStats(1);
-- CALL FollowUser(1, 2);
-- CALL UnfollowUser(1, 2);
-- CALL DeletePost(5, 1);
-- CALL GetUserFeed(1, 20, 0);
-- CALL SearchPosts('programming', 10);