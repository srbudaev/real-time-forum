-- -- SQLite
-- DROP TABLE IF EXISTS "comment_likes";
-- DROP TABLE IF EXISTS "post_likes";
-- DROP TABLE IF EXISTS "comments";
-- DROP TABLE IF EXISTS "post_categories";
-- DROP TABLE IF EXISTS "posts";
-- DROP TABLE IF EXISTS "categories";
-- DROP TABLE IF EXISTS "sessions";
-- DROP TABLE IF EXISTS "messages";
-- DROP TABLE IF EXISTS "chats";
-- DROP TABLE IF EXISTS "users";

CREATE TABLE "categories" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_by" INTEGER NOT NULL,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (created_by) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id")
);

CREATE TABLE "users" (
  "id" INTEGER PRIMARY KEY,
  "uuid" TEXT NOT NULL UNIQUE,
  "type" TEXT NOT NULL CHECK ("type" IN ('admin', 'normal_user', 'test_user')) DEFAULT 'normal_user',
	"username" TEXT UNIQUE NOT NULL,
	"age" INTEGER NOT NULL,
	"gender" TEXT NOT NULL,
	"firstname" TEXT NOT NULL,
	"lastname" TEXT NOT NULL,
	"email" TEXT UNIQUE NOT NULL,
	"password" TEXT NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "last_time_online" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (updated_by) REFERENCES "users" ("id")
);


CREATE TABLE "chats" (
  "id" INTEGER PRIMARY KEY,
  "uuid" TEXT NOT NULL UNIQUE,
  "user_id_1" INTEGER NOT NULL,
  "user_id_2" INTEGER NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (user_id_1) REFERENCES "users" ("id"),
  FOREIGN KEY (user_id_2) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id"),
  CONSTRAINT unique_chat UNIQUE (user_id_1, user_id_2) 
);

CREATE TABLE "messages" (
  "id" INTEGER PRIMARY KEY,
  "chat_id" INTEGER NOT NULL,
  "user_id_from" INTEGER NOT NULL,
  "content" TEXT NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  FOREIGN KEY (chat_id) REFERENCES "chats" ("id"),
  FOREIGN KEY (user_id_from) REFERENCES "users" ("id")
);


CREATE TABLE "posts" (
  "id" INTEGER PRIMARY KEY,
  "uuid" TEXT NOT NULL UNIQUE,
  "title" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "user_id" INTEGER NOT NULL,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (user_id) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id")
);

CREATE TABLE "post_likes" (
  "id" INTEGER PRIMARY KEY,
  "type" TEXT NOT NULL CHECK ("type" IN ('like', 'dislike')),
  "post_id" INTEGER NOT NULL,
  "user_id" INTEGER NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (user_id) REFERENCES "users" ("id"),
  FOREIGN KEY (post_id) REFERENCES "posts" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id")
);

CREATE TABLE "post_categories" (
  "id" INTEGER PRIMARY KEY,
  "post_id" INTEGER NOT NULL,
  "category_id" INTEGER NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_by" INTEGER NOT NULL,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (created_by) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id"),
  FOREIGN KEY (post_id) REFERENCES "posts" ("id"),
  FOREIGN KEY (category_id) REFERENCES "categories" ("id")
);

CREATE TABLE "comments" (
  "id" INTEGER PRIMARY KEY,
  "post_id" INTEGER DEFAULT NULL,
  "comment_id" INTEGER DEFAULT NULL,
  "description" TEXT NOT NULL,
  "user_id" INTEGER NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'disable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (user_id) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id"),
  FOREIGN KEY (post_id) REFERENCES "posts" ("id") ON DELETE CASCADE,
  FOREIGN KEY (comment_id) REFERENCES "comments" ("id") ON DELETE CASCADE,
  CHECK (
    (post_id IS NOT NULL AND comment_id IS NULL) OR
    (post_id IS NULL AND comment_id IS NOT NULL)
  )
);

CREATE TABLE "comment_likes" (
  "id" INTEGER PRIMARY KEY,
  "type" TEXT NOT NULL,
  "comment_id" INTEGER NOT NULL,
  "user_id" INTEGER NOT NULL,
  "status" TEXT NOT NULL CHECK ("status" IN ('enable', 'delete')) DEFAULT 'enable',
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" DATETIME,
  "updated_by" INTEGER,
  FOREIGN KEY (user_id) REFERENCES "users" ("id"),
  FOREIGN KEY (updated_by) REFERENCES "users" ("id"),
  FOREIGN KEY (comment_id) REFERENCES "comments" ("id")
);



CREATE TABLE "sessions" (
  "id" INTEGER PRIMARY KEY,
  "session_token" TEXT NOT NULL UNIQUE,
  "user_id" INTEGER NOT NULL,
  "expires_at" DATETIME NOT NULL,
  "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "users" ("id")
);

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('67921bdd-8458-800e-b9d4-065a43242cd3', 'admin', 'admin', '$2a$10$DN.v/NkfQjmPaTTz15x0E.u8l2R9.HnB12DpDVMdRPeQZDfMwovSa', 'admin@admin', 30, 'male', 'Admin', 'User');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('084d5c52-a72c-411c-a52f-6193f0614abe', 'normal_user', 'markus', '$2a$10$M7dekbtPuRH/hJ0qJr0mUeIL0KANj7IZ.cRPLz8e1PJtQ5A2aKjpO', 'ma@am.com', 42, 'male', 'Ma', 'Am');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('6952f31d-a07a-420b-a4dc-794271adec4f', 'normal_user', 'mahdi', '$2a$10$dmvXCLmw4QwthpYnKYzV9ue9zbgefnkoPdGxHlIc8YOhg3/LTUqw2', 'mh@kh.com', 24, 'male', 'Mh', 'Kh');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('1edec77f-5130-4ad6-ba02-6961d3192cf7', 'normal_user', 'usra', '$2a$10$mpvPbe/Mbs2coYgprgu.d.TsQRiDjLpYQ9rfETENK7sP2BvR5j7Na', 'u@a.com', 34, 'female', 'u', 'a');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('68836e96-f5eb-4cfa-a3e8-8415db6ff7e0', 'normal_user', 'usrb', '$2a$10$tl3DF0W2EXkvYpPplp6R1OQvWuseoBCIEMzQjEE0FfhXyFZ3Giv7C', 'u@b.com', 36, 'male', 'u', 'b');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('2febc9fb-9d5f-4e68-af1d-783c154a8fdf', 'normal_user', 'usrc', '$2a$10$LOp5xn/r7iFNU4eFfAFx3elQtWTo.op6Bdo.3AdgFyYM.elK5VOe.', 'u@c.com', 23, 'other', 'u', 'c');

INSERT INTO users(uuid, type, username, password, email, age, gender, firstname, lastname)
VALUES ('f597645e-69df-4c3f-9393-d5a9b90c2339', 'normal_user', 'usrd', '$2a$10$HAXDrE/tsvFORVgr/vELsu1r1OUkczhaJQXH5ehxRg5du0HF6l85i', 'u@d.com', 87, 'unspecified', 'u', 'd');


INSERT INTO categories (name, created_by) VALUES
('art', 1), ('science', 1), ('news', 1), ('sport', 1), ('society', 1), ('tech', 1);

INSERT INTO posts(uuid, title, description, user_id) VALUES 
('f9edb8d6-c739-4d6f-aaa4-9b298f2e1552', 'first post', 'this is first post of forum that is made by admin', 1),
('b5898659-fc4c-413d-b5d2-1bcee1a8f9d4', 'Heiress Lesley Whittle kidnapped', 'A 17-year-old heiress has been kidnapped from her home in Shropshire. Lesley Whittle, left £82,000 in her father''s will, was snatched from her bed at the family home in Highley. Her mother was asleep in the house at the time. Police were called in after Lesley''s brother, Ronald, received a ransom demand for £50,000.', 2),
('c1c8b5d4-a906-4bdc-9118-25ed01fad085', 'Muhammad Ali wins ''Thrilla in Manila''', 'US boxer Muhammad Ali has retained the world heavyweight boxing championship after defeating his arch-rival, Joe Frazier, in their third and arguably greatest fight. Both men are said to be contemplating retirement. Ali was guaranteed $4.5m for his fourth defence since regaining the title against George Foreman in Zaire last year. Frazier, two years his junior, got $2m.', 3),
('9e067da2-c9ab-4ea2-96cf-4e48e9d88fc3', 'First live broadcast of Parliament', 'The first live transmission from the House of Commons has been broadcast by BBC Radio and commercial stations.', 4),
('8019f2e3-a915-4da9-b853-53369fe1360c', 'Wrinkled Mercury''s shrinking history', 'The planet Mercury is about 7km smaller today than when its crust first solidified over four billion years ago. The innermost world has shrunk as it has cooled over time, its surface cracking and wrinkling in the process. Scientists first recognised the phenomenon when the Mariner 10 probe whizzed by the planet in the mid-1970s.', 5);

INSERT INTO post_categories(post_id, category_id, created_by) VALUES 
(1, 1, 1), (1, 2, 1),
(2, 3, 2), (2, 5, 2),
(3, 3, 3), (3, 4, 3),
(4, 6, 4),
(5, 2, 5), (5, 6, 5), (5, 3, 5);

INSERT INTO comments(post_id, description, user_id)
VALUES (1, 'this is first post comment that is made by admin', 1);

INSERT INTO post_likes(post_id, type, user_id)
VALUES (1, 'like', 1); 

INSERT INTO comment_likes(comment_id, type, user_id)
VALUES (1, 'like', 2);

-- Comments on the post
INSERT INTO comments (post_id, description, user_id)
VALUES 
(4, 'At last! Parliament in our homes. This is a historic moment for democracy. Now the people can hear their representatives unfiltered.', 2),
(4, 'I agree, Markus. Though I wonder how many will actually listen! The newspapers summarize the important bits anyway.', 3),
(4, 'This could change everything. If MPs know the public is listening, perhaps they’ll behave more responsibly instead of shouting each other down.', 4),
(4, 'Or perhaps they’ll just grandstand even more for attention! Some MPs love the sound of their own voice.', 5),
(4, 'Mark my words, this is only the beginning. First radio, then television, and who knows what next? Maybe one day we’ll have cameras in the chamber!', 6),
(4, 'Heaven forbid, Usrc! Imagine how long debates would drag on if MPs start performing for the cameras.', 7),
(4, 'I tuned in for a bit and must admit, it was mostly droning on about procedural matters. But at least now we know exactly what they’re discussing, rather than relying on second-hand reports.', 3),
(4, 'That’s the spirit, Mahdi! An informed public makes for a stronger democracy. I only hope people take the time to listen.', 5);

-- Replies to comments
INSERT INTO comments (comment_id, description, user_id)
VALUES 
(1, 'Absolutely, Markus! This is a step forward, but do you think it will actually change how MPs act?', 6),
(3, 'Mahdi, that is optimistic! I fear some will just find new ways to waste time.', 7),
(5, 'Usrb, television in Parliament? Now that would be something to see!', 2),
(6, 'Usrc, I think they already perform, just without an audience!', 4),
(7, 'Usrd, at least now we can hold them accountable for their words.', 2);
