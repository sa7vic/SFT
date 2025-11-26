-- Performance Analysis and Query Optimization
-- Author: DBMS Project - Nirvana
-- Description: Queries to analyze and optimize database performance

-- ============================================
-- 1. ANALYZE TABLE STATISTICS
-- ============================================
ANALYZE TABLE users;
ANALYZE TABLE posts;
ANALYZE TABLE likes;
ANALYZE TABLE comments;
ANALYZE TABLE follows;

-- ============================================
-- 2. SHOW INDEX USAGE
-- ============================================
SHOW INDEX FROM users;
SHOW INDEX FROM posts;
SHOW INDEX FROM likes;
SHOW INDEX FROM comments;
SHOW INDEX FROM follows;

-- ============================================
-- 3. EXPLAIN QUERY EXECUTION PLAN - User Feed
-- ============================================
EXPLAIN SELECT 
    p.id, p.content, p.created_at,
    u.username, u.profile_pic,
    COUNT(l.id) as likes_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN likes l ON p.id = l.post_id
GROUP BY p.id
ORDER BY p.created_at DESC
LIMIT 20;

-- ============================================
-- 4. EXPLAIN QUERY EXECUTION PLAN - User Stats
-- ============================================
EXPLAIN SELECT 
    u.id,
    (SELECT COUNT(*) FROM posts WHERE user_id = u.id) as posts_count,
    (SELECT COUNT(*) FROM follows WHERE following_id = u.id) as followers_count
FROM users u
WHERE u.id = 1;

-- ============================================
-- 5. SHOW TABLE SIZES
-- ============================================
SELECT 
    table_name AS 'Table',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = 'social_media_db'
ORDER BY (data_length + index_length) DESC;

-- ============================================
-- 6. SHOW ROW COUNTS
-- ============================================
SELECT 
    'users' as table_name, COUNT(*) as row_count FROM users
UNION ALL
SELECT 'posts', COUNT(*) FROM posts
UNION ALL
SELECT 'likes', COUNT(*) FROM likes
UNION ALL
SELECT 'comments', COUNT(*) FROM comments
UNION ALL
SELECT 'follows', COUNT(*) FROM follows;

-- ============================================
-- 7. CHECK FOR MISSING INDEXES
-- ============================================
-- This query helps identify tables that might need indexes
SELECT 
    table_name,
    index_name,
    column_name,
    seq_in_index,
    cardinality
FROM information_schema.statistics
WHERE table_schema = 'social_media_db'
ORDER BY table_name, index_name, seq_in_index;

-- ============================================
-- 8. ANALYZE JOIN PERFORMANCE
-- ============================================
EXPLAIN ANALYZE
SELECT 
    p.*,
    u.username,
    COUNT(DISTINCT l.id) as likes,
    COUNT(DISTINCT c.id) as comments
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN likes l ON p.id = l.post_id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id
LIMIT 10;

-- ============================================
-- 9. QUERY OPTIMIZATION SUGGESTIONS
-- ============================================
-- Check for queries that do full table scans
EXPLAIN FORMAT=JSON
SELECT * FROM posts 
WHERE content LIKE '%programming%';

-- Better approach with full-text index (if needed):
-- ALTER TABLE posts ADD FULLTEXT(content);
-- SELECT * FROM posts WHERE MATCH(content) AGAINST('programming');

-- ============================================
-- 10. CHECK SLOW QUERIES (if enabled)
-- ============================================
-- Enable slow query log:
-- SET GLOBAL slow_query_log = 'ON';
-- SET GLOBAL long_query_time = 2;

-- Then check:
-- SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;

-- ============================================
-- 11. OPTIMIZE TABLES
-- ============================================
OPTIMIZE TABLE users;
OPTIMIZE TABLE posts;
OPTIMIZE TABLE likes;
OPTIMIZE TABLE comments;
OPTIMIZE TABLE follows;

-- ============================================
-- 12. CHECK TABLE STATUS
-- ============================================
SHOW TABLE STATUS FROM social_media_db;

-- ============================================
-- 13. ANALYZE QUERY CACHE (if available)
-- ============================================
SHOW VARIABLES LIKE 'query_cache%';
SHOW STATUS LIKE 'Qcache%';