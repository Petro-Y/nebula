create table users --основні дані користувача
	(
	userId int(10) NOT NULL AUTO_INCREMENT,
	userName varchar (50),
	email varchar (100),
	passhash varchar (32),
	primary key(userId)
	);
create table userFeatures --додаткові дані користувача
	(
	userId int(10) NOT NULL,
	avatarFileId int(10),
	primary key(userId)
	);
create table files
	(
	fileId int(10) NOT NULL AUTO_INCREMENT,
	path varchar(256), --шлях до завантаженого файла на веб-сервері
	primary key fileId
	);
	
create table groups
	(
	groupId int(10) NOT NULL AUTO_INCREMENT,
	groupName varchar(100),
	primary key(groupId)
	); -- Що собою являють групи?......
	
create table messages
	(
	messageId int(10) NOT NULL AUTO_INCREMENT,
	userId int(10) NOT NULL,
	groupId int(10) NOT NULL,
	title varchar(100),
	content text,
	created datetime,
	primary key(messageId)
	); --зв'язок з групами?.....
create table reposts
	(
	repostId int(10) NOT NULL AUTO_INCREMENT,
	userId int(10) NOT NULL, -- користувач, що робить репост
	groupId int(10) NOT NULL, --група, в яку репоститься повідомлення
	reposted datetime,
	messageId int(10) not null, -- ід. повідомлення, яке репоститься	
	primary key(repostId)
	); --зв'язок з групами?.....
create table likes
	(
	messageId int(10) NOT NULL,
	userId int(10) NOT NULL
	);
create table tags
	(
	tagId int(10) NOT NULL AUTO_INCREMENT,
	tagName varchar(50),
	primary key(tagId)
	);
create table messageTags
	(
	messageId int(10) not null,
	tagId int(10) not null
	);
create table attachments
	(
	messageId int(10) not null,
	fileId int(10) not null
	);