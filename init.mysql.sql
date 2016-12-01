create table users --основні дані користувача
	(	
	userId integer not null auto_increment primary key,
	userName varchar (50),
	email varchar (100),
	passhash varchar (32)
	);
create table files
	(
	fileId integer not null auto_increment primary key,
	path varchar(256) --шлях до завантаженого файла на веб-сервері
	);
create table userFeatures --додаткові дані користувача
	(
	userId integer NOT NULL references users(userId),
	avatarFileId integer references files(fileId),
	aboutMe text,
	primary key(userId),
	foreign key (avatarFileId) references files(fileId)
	);
create table userActivity
	(
	userId integer NOT NULL references users(userId),
	lastIP varchar(15), -- якщо IPv6, треба буде збільшити
	lastLogIn timestamp,
	lastActivity timestamp,
	primary key(userId),
	foreign key (userId) references users(userId)	
	);
create table userBan
	(
	banId integer not null auto_increment primary key,
	userId integer not null references users(userId),
	expires timestamp, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId integer references users(userId),
	foreign key (userId) references users(userId),
	foreign key (adminUserId) references users(userId)	
	);
create table ipBan
	(
	banId integer not null auto_increment primary key,
	ip varchar(15), -- Також слід передбачити бан діапазонів IP....
	expires timestamp, -- час автоматичного припинення бану. Якщо null — пермабан
	reason varchar(256),
	adminUserId integer references users(userId),
	foreign key (adminUserId) references users(userId)	
	);	
create table groups
	(
	groupId integer not null auto_increment,
	groupName varchar(100),
	primary key(groupId)
	); -- Що собою являють групи?......
	
create table messages
	(
	messageId integer not null auto_increment,
	userId integer NOT NULL references users(userId),
	groupId integer NOT NULL references groups(groupId),
	commentTo integer references messages(messageId),
	       -- messageId повідомлення, до якого дане повідомлення є коментарем.
	       -- null — повідомлення не є коментарем
	created timestamp,
	title varchar(100),
	content text,
	primary key(messageId),
	foreign key (userId) references users(userId),
	foreign key (groupId) references groups(groupId),
	foreign key (commentTo) references users(userId)
	);
create table reposts
	(
	repostId integer not null auto_increment,
	userId integer NOT NULL references users(userId), -- користувач, що робить репост
	groupId integer NOT NULL references groups(groupId), --група, в яку репоститься повідомлення
	reposted timestamp,
	messageId integer not null references messages(messageId), -- ід. повідомлення, яке репоститься	
	primary key(repostId),
	foreign key (userId) references users(userId),
	foreign key (groupId) references groups(groupId),
	foreign key (messageId) references messages(messageId)
	); --зв’язок з групами?.....
create table likes
	(
	messageId integer NOT NULL references messages(messageId), -- повідомлення, яке лайкають
	userId integer NOT NULL references users(userId), -- користувач, який лайкає чиєсь повідомлення
	foreign key (userId) references users(userId),
	foreign key (messageId) references messages(messageId),
	primary key(messageId, userId)	
	);
create table tags
	(
	tagId integer not null auto_increment,
	tagName varchar(50),
	primary key(tagId)
	);
create index tags_tagName_index on tags(tagName);
create table messageTags
	(
	messageId integer not null references messages(messageId),
	tagId integer not null references tags(tagId),
	foreign key (messageId) references messages(messageId),
	foreign key (tagId) references tags(tagId),
	primary key(messageId, tagId)
	);
create table attachments
	(
	messageId integer not null references messages(messageId),
	fileId integer not null references files(fileId),
	foreign key (messageId) references messages(messageId),
	foreign key (fileId) references files(fileId),
	primary key(messageId, fileId)
	);
create index attachments_index on attachments(messageId);
create table adminRights
	(
	userId integer NOT NULL references users(userId),
	isAdmin boolean default(false);
	);
create table groupRights
	(
	groupId integer NOT NULL references groups(groupId),
	userId integer NOT NULL references users(userId),
	-- замість справжнього користувача можуть також бути фіктивні:
	-- ~added (користувач, щойно доданий до групи)
	-- ~registered (будь-який зареєстрований користувач, не доданий до групи)
	-- ~guest (незареєстрований користувач)
	
	-- основні права:
	canRead boolean default(true), -- якщо false, решта прав стають недоступними.
	canWriteMessage boolean default(true),
	canComment boolean default(true),	
	
	canInvite boolean default(false), -- можливість приєднати до групи нових 
	-- користувачів, яким після цього присвоюється рівень прав користувача ~added.
	-- не можна запрошувати тих, хто вже був запрошений раніше.
	
	-- права модераторів:
	canEditOthers boolean default(false), -- редагувати чужі повідомлення
	canRemove boolean default(false),
	canEditRights boolean default(false), -- змінити іншому користувачеві права
	-- (можна змінювати лише ті ж права, якими й сам модератор володіє)
	isOwner boolean default(false),
	-- Дається авторові групи; власник групи може додавати/видаляти інших власників.
	-- Права доступу власника може змінювати лише інший власник.
	foreign key (userId) references users(userId),
	foreign key (groupId) references groups(groupId),
	primary key(groupId, userId)
	);
-- :mode=mysql: