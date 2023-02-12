DROP TABLE IF EXISTS accounts, posts;

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  username text,
  email text
);

-- Then the table with the foreign key first.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  time_stamp text,
-- The foreign key name is always {other_table_singular}_id
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade
);

TRUNCATE TABLE accounts, posts RESTART IDENTITY;

INSERT INTO accounts (username, email) VALUES ('am02034', 'annamag@email.com');
INSERT INTO accounts (username, email) VALUES ('go4554', 'gerry@email.co.uk');
INSERT INTO accounts (username, email) VALUES ('ad7733', 'anadiaz@email.co.uk');
INSERT INTO accounts (username, email) VALUES ('te1221', 'tedwards@email.com');

INSERT INTO posts (title, content, time_stamp, account_id) VALUES ('Tuesday', 'I feel happy', '14/09/2011 17:02', (SELECT id FROM accounts WHERE username='am02034'));
INSERT INTO posts (title, content, time_stamp, account_id) VALUES ('Wednesday', 'I finished my exam!', '14/12/2015 18:42', (SELECT id FROM accounts WHERE username='go4554'));
INSERT INTO posts (title, content, time_stamp, account_id) VALUES ('Friday', 'Happy birthday to me', '22/04/2020 12:00', (SELECT id FROM accounts WHERE username='te1221'));