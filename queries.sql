-- Complex JOIN queries for Social Media Database
-- Author: DBMS Project - Nirvana
-- Description: Advanced SQL queries demonstrating complex JOINs, aggregations, and subqueries

-- ============================================
-- 1. GET USER FEED WITH ALL POST DETAILS
-- ============================================
-- Shows posts with user info, likes count, and comments count
SELECT 
    p.id, 
    p.content, 
    p.image_url, 
    p.created_at,
    u.username, 
    u.profile_pic,
    COUNT(DISTINCT l.id) as likes_count,
    COUNT(DISTINCT c.id) as comments_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN likes l ON p.id = l.post_id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.content, p.image_url, p.created_at, u.username, u.profile_pic
ORDER BY p.created_at DESC;

-- ============================================
-- 2. GET USER'S FOLLOWERS WITH DETAILS
-- ============================================
-- Retrieve all followers of a specific user with their stats
SELECT 
    u.id, 
    u.username, 
    u.email, 
    u.profile_pic,
    u.bio,
    COUNT(DISTINCT p.id) as posts_count,
    f.created_at as followed_since
FROM users u
JOIN follows f ON u.id = f.follower_id
LEFT JOIN posts p ON u.id = p.user_id
WHERE f.following_id = 1  -- Replace with actual user_id
GROUP BY u.id, u.username, u.email, u.profile_pic, u.bio, f.created_at
ORDER BY f.created_at DESC;

-- ============================================
-- 3. GET TRENDING POSTS (LAST 7 DAYS)
-- ============================================
-- Find most liked posts in the last week
SELECT 
    p.id,
    p.content,
    p.image_url,
    p.created_at,
    u.username,
    u.profile_pic,
    COUNT(l.id) as recent_likes,
    (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN likes l ON p.id = l.post_id
WHERE p.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY p.id, p.content, p.image_url, p.created_at, u.username, u.profile_pic
ORDER BY recent_likes DESC
LIMIT 10;

-- ============================================
-- 4. GET USER'S TIMELINE (POSTS FROM FOLLOWED USERS)
-- ============================================
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
WHERE p.user_id IN (
    SELECT following_id 
    FROM follows 
    WHERE follower_id = 1  -- Replace with actual user_id
)
ORDER BY p.created_at DESC
LIMIT 50;

-- ============================================
-- 5. GET MOST ACTIVE USERS
-- ============================================
SELECT 
    u.id,
    u.username,
    u.profile_pic,
    COUNT(DISTINCT p.id) as posts_count,
    COUNT(DISTINCT c.id) as comments_count,
    COUNT(DISTINCT l.id) as likes_given,
    (COUNT(DISTINCT p.id) + COUNT(DISTINCT c.id) + COUNT(DISTINCT l.id)) as activity_score
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username, u.profile_pic
ORDER BY activity_score DESC
LIMIT 10;

-- ============================================
-- 6. GET POST WITH ALL COMMENTS
-- ============================================
SELECT 
    p.id as post_id,
    p.content as post_content,
    p.created_at as post_date,
    pu.username as post_author,
    c.id as comment_id,
    c.content as comment_content,
    c.created_at as comment_date,
    cu.username as comment_author,
    cu.profile_pic as comment_author_pic
FROM posts p
JOIN users pu ON p.user_id = pu.id
LEFT JOIN comments c ON p.id = c.post_id
LEFT JOIN users cu ON c.user_id = cu.id
WHERE p.id = 1  -- Replace with actual post_id
ORDER BY c.created_at ASC;

-- ============================================
-- 7. FIND MUTUAL FOLLOWERS
-- ============================================
-- Find users who follow each other
SELECT 
    u1.username as user1,
    u2.username as user2,
    f1.created_at as user1_followed_at,
    f2.created_at as user2_followed_at
FROM follows f1
JOIN follows f2 ON f1.follower_id = f2.following_id 
    AND f1.following_id = f2.follower_id
JOIN users u1 ON f1.follower_id = u1.id
JOIN users u2 ON f1.following_id = u2.id
WHERE f1.follower_id < f1.following_id  -- Avoid duplicates
ORDER BY u1.username;

-- ============================================
-- 8. GET USER ENGAGEMENT STATISTICS
-- ============================================
SELECT 
    u.id,
    u.username,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT l.id) as total_likes_received,
    COUNT(DISTINCT c.id) as total_comments_received,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers,
    (SELECT COUNT(*) FROM follows WHERE follower_id = u.id) as following,
    ROUND(COUNT(DISTINCT l.id) / NULLIF(COUNT(DISTINCT p.id), 0), 2) as avg_likes_per_post
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN likes l ON p.id = l.post_id
LEFT JOIN comments c ON p.id = c.post_id
WHERE u.id = 1  -- Replace with actual user_id
GROUP BY u.id, u.username;

-- ============================================
-- 9. SEARCH USERS BY USERNAME OR EMAIL
-- ============================================
SELECT 
    u.id,
    u.username,
    u.email,
    u.profile_pic,
    u.bio,
    COUNT(DISTINCT p.id) as posts_count,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE u.username LIKE '%search_term%' 
   OR u.email LIKE '%search_term%'
GROUP BY u.id, u.username, u.email, u.profile_pic, u.bio
LIMIT 20;

-- ============================================
-- 10. GET POSTS USER HAS LIKED
-- ============================================
SELECT 
    p.id,
    p.content,
    p.image_url,
    p.created_at,
    u.username as post_author,
    u.profile_pic,
    l.created_at as liked_at,
    p.likes_count
FROM likes l
JOIN posts p ON l.post_id = p.id
JOIN users u ON p.user_id = u.id
WHERE l.user_id = 1  -- Replace with actual user_id
ORDER BY l.created_at DESC;