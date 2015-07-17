-- Additional queries
-- #1
SELECT posts.id, posts.title, users.id
FROM comments INNER JOIN posts ON (comments.posts_id = posts.id) INNER JOIN users ON (posts.users_id = users.id)
WHERE comments.users_id = users.id;

-- #2
SELECT posts.created_at AS "POSTS", comments.created_at AS "COMMENTS"
FROM posts INNER JOIN comments ON (comments.posts_id = posts.id)
WHERE posts.created_at > 'July 14, 2015';

-- #3
SELECT username
FROM users INNER JOIN comments ON (users.id = comments.users_id)
WHERE comments.body LIKE '%programming%';