-- Database Views for Social Media Application
-- Author: DBMS Project - Nirvana
-- Description: Views for simplified and optimized data access

-- ============================================
-- 1. USER FEED VIEW
-- ============================================
CREATE OR REPLACE VIEW user_feed AS
SELECT 
    p.id,
    p.user_id,
    p.content,
    p.image_url,
    p.created_at,
    u.username,
    u.profile_pic,
    p.likes_count,
    (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count
FROM posts p
JOIN users u ON p.user_id = u.id
ORDER BY p.created_at DESC;

-- ============================================
-- 2. USER ACTIVITY SUMMARY VIEW
-- ============================================
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.id,
    u.username,
    u.email,
    u.profile_pic,
    u.created_at as joined_date,
    COUNT(DISTINCT p.id) as posts_count,
    COUNT(DISTINCT l.id) as likes_given,
    COUNT(DISTINCT c.id) as comments_made,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers_count,
    (SELECT COUNT(*) FROM follows WHERE follower_id = u.id) as following_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN likes l ON u.id = l.user_id
LEFT JOIN comments c ON u.id = c.user_id
GROUP BY u.id, u.username, u.email, u.profile_pic, u.created_at;

-- ============================================
-- 3. POST DETAILS VIEW
-- ============================================
CREATE OR REPLACE VIEW post_details AS
SELECT 
    p.id,
    p.content,
    p.image_url,
    p.created_at,
    p.user_id,
    u.username as author_username,
    u.profile_pic as author_profile_pic,
    p.likes_count,
    (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count,
    (SELECT GROUP_CONCAT(DISTINCT cu.username SEPARATOR ', ') 
     FROM comments c 
     JOIN users cu ON c.user_id = cu.id 
     WHERE c.post_id = p.id 
     LIMIT 3) as recent_commenters
FROM posts p
JOIN users u ON p.user_id = u.id;

-- ============================================
-- 4. TRENDING POSTS VIEW (LAST 7 DAYS)
-- ============================================
CREATE OR REPLACE VIEW trending_posts AS
SELECT 
    p.id,
    p.content,
    p.image_url,
    p.created_at,
    u.username,
    u.profile_pic,
    p.likes_count,
    (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count,
    (p.likes_count * 2 + (SELECT COUNT(*) FROM comments WHERE post_id = p.id)) as engagement_score
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY engagement_score DESC;

-- ============================================
-- 5. USER PROFILE VIEW
-- ============================================
CREATE OR REPLACE VIEW user_profiles AS
SELECT 
    u.id,
    u.username,
    u.email,
    u.profile_pic,
    u.bio,
    u.created_at,
    (SELECT COUNT(*) FROM posts WHERE user_id = u.id) as posts_count,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers_count,
    (SELECT COUNT(*) FROM follows WHERE follower_id = u.id) as following_count,
    (SELECT SUM(likes_count) FROM posts WHERE user_id = u.id) as total_likes_received
FROM users u;

-- ============================================
-- 6. RECENT COMMENTS VIEW
-- ============================================
CREATE OR REPLACE VIEW recent_comments AS
SELECT 
    c.id,
    c.post_id,
    c.content,
    c.created_at,
    c.user_id,
    u.username as commenter_username,
    u.profile_pic as commenter_profile_pic,
    p.content as post_content,
    pu.username as post_author_username
FROM comments c
JOIN users u ON c.user_id = u.id
JOIN posts p ON c.post_id = p.id
JOIN users pu ON p.user_id = pu.id
ORDER BY c.created_at DESC;

-- ============================================
-- 7. FOLLOWERS OVERVIEW VIEW
-- ============================================
CREATE OR REPLACE VIEW followers_overview AS
SELECT 
    f.following_id as user_id,
    u1.username as user_username,
    f.follower_id,
    u2.username as follower_username,
    u2.profile_pic as follower_profile_pic,
    f.created_at as followed_since,
    (SELECT COUNT(*) FROM posts WHERE user_id = f.follower_id) as follower_posts_count
FROM follows f
JOIN users u1 ON f.following_id = u1.id
JOIN users u2 ON f.follower_id = u2.id;

-- ============================================
-- 8. POPULAR USERS VIEW
-- ============================================
CREATE OR REPLACE VIEW popular_users AS
SELECT 
    u.id,
    u.username,
    u.profile_pic,
    u.bio,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers_count,
    (SELECT COUNT(*) FROM posts WHERE user_id = u.id) as posts_count,
    (SELECT SUM(likes_count) FROM posts WHERE user_id = u.id) as total_likes
FROM users u
HAVING followers_count > 0
ORDER BY followers_count DESC, total_likes DESC;

-- ============================================
-- USAGE EXAMPLES:
-- ============================================
-- SELECT * FROM user_feed LIMIT 20;
-- SELECT * FROM user_activity_summary WHERE id = 1;
-- SELECT * FROM trending_posts LIMIT 10;
-- SELECT * FROM user_profiles WHERE username = 'alice_wonder';
-- SELECT * FROM popular_users LIMIT 10;