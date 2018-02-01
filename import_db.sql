DROP TABLE if EXISTS users;
DROP TABLE if EXISTS question_follows;
DROP TABLE if EXISTS replies;
DROP TABLE if EXISTS questions;
DROP TABLE if EXISTS question_likes;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users (id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('David', 'V'),
  ("Tom", "Sawyer"),
  ("Huck", "Finn"),
  ('Mickey', 'Mouse');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Best Fountain Pen', 'What is the best fountain pen?', 1),
  ('Best coding language', 'In your opinion, what''s the best language to learn?', 2),
  ('Best food', 'If you could only eat only one type of food for the rest of your life, what would you eat?', 1),
  ('how to code', 'How do I go about learning how to code?', 2);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 2),
  (2, 2),
  (2, 1);

INSERT INTO
  replies(question_id, user_id, body)
VALUES
  (1, 2, 'I like the twsbi diamond'),
  (2, 1, 'I love JavaScript and think that it is the best language to learn'),
  (3, 1, 'I would eat sushi each and every day of my life'),
  (4, 2, 'Just google it, you can find different paths everywhere');

INSERT INTO
  replies(question_id, user_id, parent_reply_id, body)
VALUES
  (1, 1, 1, 'I was looking at that pen, it looks nice'),
  (2, 2, 2, 'Is that an easly language to learn?'),
  (3, 1, 3, 'Does that include different types of sushi?'),
  (3, 2, 4, 'I would hope so dude!!!!!');

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1),
  (2, 1),
  (2, 4),
  (1, 3);
