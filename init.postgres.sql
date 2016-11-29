create table users --основні дані користувача
	(	
	userId serial primary key,
	userName varchar (50),
	email varchar (100),
	passhash varchar (32)
	);
create table files
	(
	fileId serial primary key,
	path varchar(256) --шлях до завантаженого файла на веб-сервері
	);
create table userFeatures --додаткові дані користувача
	(
	userId integer NOT NULL references users(userId),
	avatarFileId integer references files(fileId),
	primary key(userId)
	);
create table userActivity
	(
	userId integer NOT NULL references users(userId),
	lastIP varchar(15), -- якщо IPv6, треба буде збільшити
	lastLogIn timestamp,
	lastActivity timestamp,
	primary key(userId)	
	);
create table userBan
	(
	banId serial primary key,
	userId integer not null references users(userId),
	expires timestamp, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId integer references users(userId)	
	);
create table ipBan
	(
	banId serial primary key,
	ip varchar(15), -- Також слід передбачити бан діапазонів IP....
	expires timestamp, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId integer references users(userId)	
	);	
create table groups
	(
	groupId serial,
	groupName varchar(100),
	primary key(groupId)
	); -- Що собою являють групи?......
	
create table messages
	(
	messageId serial,
	userId integer NOT NULL references users(userId),
	groupId integer NOT NULL references groups(groupId),
	commentTo integer references messages(messageId),
	       -- messageId повідомлення, до якого дане повідомлення є коментарем.
	       -- null — повідомлення не є коментарем
	created timestamp,
	title varchar(100),
	content text,
	primary key(messageId)
	);
create table reposts
	(
	repostId serial,
	userId integer NOT NULL references users(userId), -- користувач, що робить репост
	groupId integer NOT NULL references groups(groupId), --група, в яку репоститься повідомлення
	reposted timestamp,
	messageId integer not null references messages(messageId), -- ід. повідомлення, яке репоститься	
	primary key(repostId)
	); --зв'язок з групами?.....
create table likes
	(
	messageId integer NOT NULL references messages(messageId), -- повідомлення, яке лайкають
	userId integer NOT NULL references users(userId) -- користувач, який лайкає чиєсь повідомлення
	);
create table tags
	(
	tagId serial,
	tagName varchar(50),
	primary key(tagId)
	);
create index tags_tagName_index on tags(tagName);
create table messageTags
	(
	messageId integer not null references messages(messageId),
	tagId integer not null references tags(tagId)
	);
create table attachments
	(
	messageId integer not null references messages(messageId),
	fileId integer not null references files(fileId)
	);