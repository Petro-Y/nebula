ALTER DATABASE nebula SET default_text_search_config = 'pg_catalog.simple';
-- Спрощений стемер, що не робить ніяких додаткових дій після парсера.
-- Слід подумати про можливість створення пошукових конфігурацій для мов
-- не зі стандартного списку (в який українська не входить).
-- Схоже, доведеться писати власний стемер для української :(
-- (і не тільки для неї).

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
	aboutMe text,
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
create index messages_index on messages using gin(to_tsvector('simple', content));
-- select * from messages where to_tsvector(content) @@ to_tsquery('слова слова слова');

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
	userId integer NOT NULL references users(userId), -- користувач, який лайкає чиєсь повідомлення
	primary key(messageId, userId)
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
	tagId integer not null references tags(tagId),
	primary key(messageId, tagId)
	);
create table attachments
	(
	messageId integer not null references messages(messageId),
	fileId integer not null references files(fileId),
	primary key(messageId, fileId)
	);
create index attachments_index on attachments(messageId);
create table adminRights
	(
	userId integer NOT NULL references users(userId),
	isAdmin boolean default(false),
	primary key(userId)
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
	primary key(groupId, userId)
	);
create table emailNotifications
	(
	userId integer NOT NULL references users(userId) primary key,
	onComment boolean default(false),
	onRepost boolean default(false),
	onRemove boolean default(false),
	onBan boolean default(true)
	);
create table watchUsers
	(
	userId integer NOT NULL references users(userId), --користувач(1), що отримує сповіщення.
	watchedUserId integer NOT NULL references users(userId) primary key --користувач(2), при публікації повідомлень якого користувачеві(1) надходять сповіщення на пошту
	)
-- :mode=pg-sql: