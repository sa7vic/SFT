-- Sample Data for Social Media Database
-- Author: DBMS Project - Nirvana
-- Description: Test data for development and demonstration

USE social_media_db;

-- Delete existing data (if any)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE comments;
TRUNCATE TABLE likes;
TRUNCATE TABLE follows;
TRUNCATE TABLE posts;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. INSERT SAMPLE USERS
-- ============================================
-- Password for all users: 'password123'
-- Hash generated with: bcrypt.hash('password123', 10)
INSERT INTO users (username, email, password, bio) VALUES
('alice_wonder', 'alice@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Love photography and travel ✈️📷'),
('bob_builder', 'bob@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Tech enthusiast and developer 💻'),
('charlie_chap', 'charlie@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Movie buff and cinephile 🎬🍿'),
('diana_dev', 'diana@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Full-stack developer | Coffee lover ☕'),
('eve_explorer', 'eve@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Adventure seeker and nature lover 🌲⛰️'),
('frank_foodie', 'frank@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Food blogger | Chef wannabe 🍕🍜'),
('grace_gamer', 'grace@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Gaming enthusiast and streamer 🎮'),
('henry_hiker', 'henry@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Hiking trails and outdoor adventures 🥾'),
('iris_artist', 'iris@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Digital artist and illustrator 🎨'),
('jack_journalist', 'jack@example.com', '$2a$10$YQ7Y5qW5f5H5H5H5H5H5H.5H5H5H5H5H5H5H5H5H5H5H5H5H5H5H5', 'Journalist | News junkie 📰');

-- ============================================
-- 2. INSERT SAMPLE POSTS
-- ============================================
INSERT INTO posts (user_id, content, image_url) VALUES
(1, 'Hello Nirvana! This is my first post. Excited to be here! 🎉', NULL),
(2, 'Just finished building an amazing DBMS project with MySQL and Node.js! Check it out! 💪', NULL),
(3, 'Movie night! Anyone watching the new Marvel release? No spoilers please! 🍿', NULL),
(1, 'Sunset photography from my recent trip to the mountains. Nature is beautiful! 🌅', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'),
(4, 'Debugging at 3 AM... why do I do this to myself? 😅 #DevLife', NULL),
(5, 'Just completed a 10-mile hike! Feeling accomplished and exhausted 🏔️', 'https://images.unsplash.com/photo-1551632811-561732d1e306'),
(6, 'Tried making homemade pasta today. Turned out better than expected! 🍝', NULL),
(2, 'New blog post: "Understanding SQL Joins with Real Examples" - Link in bio!', NULL),
(7, 'Stream going live in 30 minutes! Come hang out 🎮', NULL),
(3, 'Watched 5 movies this weekend. Here are my rankings...', NULL),
(8, 'Trail running this morning. Best way to start the day! 🏃', 'https://images.unsplash.com/photo-1502904550040-7534597429ae'),
(9, 'New artwork finished! What do you think? 🎨', 'https://images.unsplash.com/photo-1547891654-e66ed7ebb968'),
(10, 'Breaking: Important tech news everyone should know about!', NULL),
(1, 'Coffee and coding. Perfect combination ☕💻', NULL),
(4, 'Finally deployed my project! It is live now! 🚀', NULL),
(5, 'Planning next adventure. Suggestions welcome!', NULL),
(6, 'Food tip: Add a pinch of sugar to tomato sauce. Game changer!', NULL),
(7, 'New gaming setup! Rate my battlestation 1-10', 'https://images.unsplash.com/photo-1593305841991-05c297ba4575'),
(9, 'Commission work in progress. Loving how this is turning out!', NULL),
(10, 'Interview with tech CEO tomorrow. Questions anyone?', NULL);

-- ============================================
-- 3. INSERT SAMPLE FOLLOWS
-- ============================================
INSERT INTO follows (follower_id, following_id) VALUES
-- Alice follows everyone
(1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
-- Bob's network
(2, 1), (2, 4), (2, 10),
-- Charlie's network
(3, 1), (3, 6), (3, 9),
-- Diana's network
(4, 1), (4, 2), (4, 10),
-- Eve's network
(5, 1), (5, 8), (5, 6),
-- Frank's network
(6, 1), (6, 5), (6, 9),
-- Grace's network
(7, 2), (7, 4), (7, 10),
-- Henry's network
(8, 1), (8, 5),
-- Iris's network
(9, 1), (9, 3), (9, 6),
-- Jack's network
(10, 1), (10, 2), (10, 4), (10, 7);

-- ============================================
-- 4. INSERT SAMPLE LIKES
-- ============================================
INSERT INTO likes (post_id, user_id) VALUES
-- Post 1 likes
(1, 2), (1, 3), (1, 4), (1, 5),
-- Post 2 likes
(2, 1), (2, 4), (2, 10),
-- Post 3 likes
(3, 1), (3, 9),
-- Post 4 likes
(4, 2), (4, 5), (4, 6), (4, 8), (4, 9),
-- Post 5 likes
(5, 1), (5, 2), (5, 3),
-- Post 6 likes
(6, 1), (6, 5),
-- Post 7 likes
(7, 1), (7, 5), (7, 9),
-- Post 8 likes
(8, 1), (8, 4), (8, 7), (8, 10),
-- Post 9 likes
(9, 2), (9, 4), (9, 7),
-- Post 10 likes
(10, 1), (10, 6), (10, 9),
-- More likes on recent posts
(11, 1), (11, 2), (11, 5),
(12, 1), (12, 3), (12, 6),
(13, 2), (13, 4), (13, 10),
(14, 1), (14, 2), (14, 4),
(15, 1), (15, 2), (15, 3), (15, 4),
(16, 1), (16, 5), (16, 8),
(17, 1), (17, 3), (17, 5), (17, 6),
(18, 2), (18, 4), (18, 7),
(19, 1), (19, 3), (19, 9),
(20, 1), (20, 2), (20, 4), (20, 7);

-- ============================================
-- 5. INSERT SAMPLE COMMENTS
-- ============================================
INSERT INTO comments (post_id, user_id, content) VALUES
-- Comments on Post 1
(1, 2, 'Welcome to Nirvana! 🎉'),
(1, 3, 'Great to have you here!'),
(1, 5, 'Welcome Alice!'),
-- Comments on Post 2
(2, 1, 'This looks amazing! Would love to see the code'),
(2, 4, 'Impressive work! What database did you use?'),
(2, 10, 'Perfect for my article. Can I interview you?'),
-- Comments on Post 3
(3, 1, 'I watched it! DM me, we can discuss'),
(3, 9, 'Avoiding all social media until I watch it 😅'),
-- Comments on Post 4
(4, 2, 'Stunning capture! What camera?'),
(4, 5, 'This is beautiful! Where is this?'),
(4, 9, 'The colors are perfect! 🌅'),
-- Comments on Post 5
(5, 1, 'Story of every developer 😂'),
(5, 2, 'Feel you! Coffee helps'),
-- Comments on Post 6
(6, 1, 'Wow! That sounds challenging'),
-- Comments on Post 7
(7, 1, 'Looks delicious! Recipe please?'),
(7, 5, 'I need to try this!'),
-- Comments on Post 8
(8, 1, 'Will definitely check it out!'),
(8, 4, 'Shared! Great content'),
-- Comments on Post 9
(9, 4, 'I will be there! 🎮'),
(9, 7, 'See you there!'),
-- Comments on Post 11
(11, 2, 'Nice shot!'),
-- Comments on Post 12
(12, 1, 'This is incredible! Love your style'),
(12, 3, 'Amazing work as always!'),
-- Comments on Post 14
(14, 2, 'The perfect morning routine!'),
-- Comments on Post 15
(15, 1, 'Congratulations! 🎉'),
(15, 2, 'Well done!'),
(15, 4, 'Awesome! Checking it out now');

-- ============================================
-- 6. VERIFY DATA INSERTION
-- ============================================
SELECT 'Data insertion completed!' as status;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_posts FROM posts;
SELECT COUNT(*) as total_follows FROM follows;
SELECT COUNT(*) as total_likes FROM likes;
SELECT COUNT(*) as total_comments FROM comments;