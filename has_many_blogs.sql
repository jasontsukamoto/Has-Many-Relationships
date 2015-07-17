CREATE TABLE IF NOT EXISTS users
(
  id serial,
  username varchar(90) NOT NULL,
  first_name varchar(90) NULL DEFAULT NULL,
  last_name varchar(90) NULL DEFAULT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS posts
(
  id serial,
  title varchar(180) NULL DEFAULT NULL,
  url varchar(510) NULL DEFAULT NULL,
  content text NULL DEFAULT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  users_id integer NOT NULL,
  CONSTRAINT user_id_fk FOREIGN KEY (users_id)
  REFERENCES users (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS comments
(
  id serial,
  body varchar(510) NULL DEFAULT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  users_id integer NOT NULL,
  posts_id integer NOT NULL,
  CONSTRAINT user_id_fk FOREIGN KEY (users_id)
  REFERENCES users (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT posts_id_fk FOREIGN KEY (posts_id)
  REFERENCES posts (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY(id)
);

----
--Queries across multiple tables

-- #1
SELECT *
FROM users;

-- #2
SELECT *
FROM posts WHERE users_id = 100;


-- #3 version 1 postgres shortcut
SELECT posts.id, posts.title, posts.url, posts.content, posts.created_at, posts.updated_at, posts.users_id, users.first_name, users.last_name
FROM posts, users
WHERE posts.users_id = 200 AND users.id = 200;

--version 2 using join
SELECT posts.id, posts.title, posts.url, posts.content, posts.created_at, posts.updated_at, posts.users_id, users.first_name, users.last_name
FROM posts INNER JOIN users ON (posts.users_id = users.id)
WHERE posts.users_id = 200;

-- #4
SELECT posts.id, posts.title, posts.url, posts.content, posts.created_at, posts.updated_at, posts.users_id, users.username
FROM posts INNER JOIN users on (posts.users_id = users.id)
WHERE users.first_name = 'Norene' AND users.last_name = 'Schmitt';

-- #5
SELECT username
FROM posts INNER JOIN users on (posts.users_id = users.id)
WHERE posts.created_at > 'January 1, 2015';

-- #6
SELECT posts.title, posts.content, username
FROM posts INNER JOIN users on (posts.users_id = users.id)
WHERE users.created_at < 'January 1, 2015';

-- #7
SELECT comments.*, posts.title AS "POST TITLE"
FROM comments INNER JOIN posts ON (comments.posts_id = posts.id);

-- #8
SELECT comments.id, comments.body AS "comment_body", comments.created_at, comments.updated_at, comments.users_id, comments.posts_id, posts.title AS "post_title", posts.url AS "post_url", comments.body AS "comment_body"
FROM posts INNER JOIN comments ON (comments.posts_id = posts.id)
WHERE posts.created_at < 'January 1, 2015';

-- #9
SELECT comments.id, comments.body AS "comment_body", comments.created_at, comments.updated_at, comments.users_id, comments.posts_id, posts.title AS "post_title", posts.url AS "post_url", comments.body AS "comment_body"
FROM posts INNER JOIN comments ON (comments.posts_id = posts.id)
WHERE posts.created_at > 'January 1, 2015';

-- #10
SELECT comments.id, comments.body AS "comment_body", comments.created_at, comments.updated_at, comments.users_id, comments.posts_id, posts.title AS "post_title", posts.url AS "post_url", comments.body AS "comment_body"
FROM posts INNER JOIN comments ON (comments.posts_id = posts.id)
WHERE comments.body LIKE '%USB%';

-- #11
SELECT posts.title AS "post_title", posts.url AS "post_url", comments.body AS "comment_body"
FROM posts INNER JOIN comments ON (comments.posts_id = posts.id)
WHERE comments.body LIKE '%matrix%';

-- #12
SELECT users.first_name, users.last_name, comments.body AS "comment_body"
FROM comments INNER JOIN posts ON (comments.posts_id = posts.id) INNER JOIN users ON (posts.users_id = users.id)
WHERE comments.body LIKE '%SSL%' AND posts.content LIKE '%dolorum%';

-- #13
SELECT users.first_name AS "post_author_first_name", users.last_name AS "post_author_last_name", posts.title AS "post_title", users.username AS "comment_author_username", comments.body AS "comment_body"
FROM users INNER JOIN posts ON (posts.users_id = users.id) INNER JOIN comments ON (posts.id = comments.posts_id)
WHERE (comments.body LIKE '%SSL%' OR comments.body LIKE '%firewall%') AND posts.content LIKE '%nemo%';

