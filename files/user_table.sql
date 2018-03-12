USE webdb;

DROP TABLE IF EXISTS `user`;

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(5) NOT NULL auto_increment,
  `firstName` varchar(32) NOT NULL,
  `lastName` varchar(32) NULL,
  `username` varchar(32) NOT NULL,
  `email` varchar(64) NULL,
  `mobilePhone` varchar(16) NULL,
  `createdTime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updatedTime` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci auto_increment=1;

INSERT INTO user (firstName, lastName, username, email, mobilePhone, createdTime) values ("Rob", "Callahan", "rtc", "robtcallahan@aol.com", "703-851-5412", now());

\! sleep 5;

UPDATE user SET username="rcallahan", updatedTime=now()  WHERE id=1;

