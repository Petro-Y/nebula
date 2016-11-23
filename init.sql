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
	userId int(10) NOT NULL references users(userId),
	avatarFileId int(10) references files(fileId),
	primary key(userId)
	);
create table files
	(
	fileId int(10) NOT NULL AUTO_INCREMENT,
	path varchar(256), --шлях до завантаженого файла на веб-сервері
	primary key fileId
	);
create table userActivity
	(
	userId int(10) NOT NULL references users(userId),
	lastIP varchar(15), -- якщо IPv6, треба буде збільшити
	lastLoIn datetime,
	lastActivity datetime,
	primary key(userId)	
	)
create table userBan
	(
	userId int(10) not null references users(userId),
	expires datetime, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId int(10) references users(userId)	
	)
create table ipBan
	(
	ip varchar(15), -- Також слід передбачити бан діапазонів IP....
	expires datetime, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId int(10) references users(userId)	
	)
	
create table groups
	(
	groupId int(10) NOT NULL AUTO_INCREMENT,
	groupName varchar(100),
	primary key(groupId)
	); -- Що собою являють групи?......
	
create table messages
	(
	messageId int(10) NOT NULL AUTO_INCREMENT,
	userId int(10) NOT NULL references users(userId),
	groupId int(10) NOT NULL references groups(groupId),
	commentTo int(10) references messages(messageId),
	       -- messageId повідомлення, до якого дане повідомлення є коментарем.
	       -- null — повідомлення не є коментарем
	created datetime,
	title varchar(100),
	content text,
	primary key(messageId)
	);
create table reposts
	(
	repostId int(10) NOT NULL AUTO_INCREMENT,
	userId int(10) NOT NULL references users(userId), -- користувач, що робить репост
	groupId int(10) NOT NULL references groups(groupId), --група, в яку репоститься повідомлення
	reposted datetime,
	messageId int(10) not null references messages(messageId), -- ід. повідомлення, яке репоститься	
	primary key(repostId)
	); --зв'язок з групами?.....
create table likes
	(
	messageId int(10) NOT NULL references messages(messageId), -- повідомлення, яке лайкають
	userId int(10) NOT NULL references users(userId) -- користувач, який лайкає чиєсь повідомлення
	);
create table tags
	(
	tagId int(10) NOT NULL AUTO_INCREMENT,
	tagName varchar(50),
	primary key(tagId)
	);
create table messageTags
	(
	messageId int(10) not null references messages(messageId),
	tagId int(10) not null references tags(tagId)
	);
create table attachments
	(
	messageId int(10) not null references messages(messageId),
	fileId int(10) not null references files(fileId)
	);