use test_schema;
-- CREATE table users(
-- 	id int primary Key auto_increment,
-- 		password VARCHAR(4),
-- 		name varchar(3),
-- 		gender enum('male','female'),
-- 		email varchar(15),
-- 		birthday char(6),
-- 		age tinyint,
-- 		company enum('samsung','LG','hyndae')
--   );

create table boards(
  id int primary Key auto_increment,
  title VARCHAR(5),
  content varchar(10),
  likes int check(likes between 1 and 100),
  img char(1) default 'c',
  created date, 
  user_id int,
  foreign key(user_id) references users(id)
);
  