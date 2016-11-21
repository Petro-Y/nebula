create table users 
	(
	userId int(10) NOT NULL AUTO_INCREMENT,,
	userName varchar (50),
	email varchar (100),
	passhash varchar (32),
	primary key(userId)
	);
create table groups
	(
	groupId int(10) NOT NULL AUTO_INCREMENT,
	groupName varchar(100),
	primary key(groupId)
	); --......
create table messages
	(
	messageId int(10) NOT NULL AUTO_INCREMENT,
	userId int(10) NOT NULL,
	groupId int(10) NOT NULL,
	title varchar(100),
	content text,
	primary key(messageId)
	); --.....