/*
MySQL Data Transfer
Source Host: localhost
Target Host: localhost
Date: 3/28/2014 9:05:27 PM
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for accounts
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(13) NOT NULL DEFAULT '',
  `password` varchar(128) NOT NULL DEFAULT '',
  `salt` varchar(32) DEFAULT NULL,
  `2ndpassword` varchar(134) DEFAULT NULL,
  `salt2` varchar(32) DEFAULT NULL,
  `loggedin` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lastlogin` timestamp NULL DEFAULT NULL,
  `createdat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `birthday` date NOT NULL DEFAULT '0000-00-00',
  `banned` tinyint(1) NOT NULL DEFAULT '0',
  `banreason` text,
  `gm` tinyint(1) NOT NULL DEFAULT '0',
  `email` tinytext,
  `macs` tinytext,
  `tempban` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `greason` tinyint(4) unsigned DEFAULT NULL,
  `ACash` int(11) NOT NULL DEFAULT '0',
  `mPoints` int(11) NOT NULL DEFAULT '0',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `SessionIP` varchar(64) DEFAULT NULL,
  `dpoints` int(11) NOT NULL DEFAULT '0',
  `vpoints` int(11) NOT NULL DEFAULT '0',
  `lastlogon` timestamp NULL DEFAULT NULL,
  `lastvoteip` varchar(64) DEFAULT NULL,
  `webadmin` int(1) DEFAULT '0',
  `ip` text,
  `mainchar` int(6) NOT NULL DEFAULT '0',
  `nxCredit` varchar(45) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ranking1` (`id`,`banned`,`gm`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=831 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for achievements
-- ----------------------------
DROP TABLE IF EXISTS `achievements`;
CREATE TABLE `achievements` (
  `achievementid` int(9) NOT NULL DEFAULT '0',
  `charid` int(9) NOT NULL DEFAULT '0',
  `accountid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`achievementid`,`charid`),
  KEY `achievementid` (`achievementid`),
  KEY `accountid` (`accountid`),
  KEY `charid` (`charid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for alliances
-- ----------------------------
DROP TABLE IF EXISTS `alliances`;
CREATE TABLE `alliances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(13) NOT NULL,
  `leaderid` int(11) NOT NULL,
  `guild1` int(11) NOT NULL,
  `guild2` int(11) NOT NULL,
  `guild3` int(11) NOT NULL DEFAULT '0',
  `guild4` int(11) NOT NULL DEFAULT '0',
  `guild5` int(11) NOT NULL DEFAULT '0',
  `rank1` varchar(13) NOT NULL DEFAULT 'Master',
  `rank2` varchar(13) NOT NULL DEFAULT 'Jr.Master',
  `rank3` varchar(13) NOT NULL DEFAULT 'Member',
  `rank4` varchar(13) NOT NULL DEFAULT 'Member',
  `rank5` varchar(13) NOT NULL DEFAULT 'Member',
  `capacity` int(11) NOT NULL DEFAULT '2',
  `notice` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `id` (`id`),
  KEY `leaderid` (`leaderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for androids
-- ----------------------------
DROP TABLE IF EXISTS `androids`;
CREATE TABLE `androids` (
  `uniqueid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(13) NOT NULL DEFAULT 'Android',
  `hair` int(11) NOT NULL DEFAULT '0',
  `face` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uniqueid`),
  KEY `uniqueid` (`uniqueid`)
) ENGINE=InnoDB AUTO_INCREMENT=21663 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for ardentmill
-- ----------------------------
DROP TABLE IF EXISTS `ardentmill`;
CREATE TABLE `ardentmill` (
  `characterID` int(10) NOT NULL,
  `mineNovice` int(1) NOT NULL DEFAULT '0',
  `mineIntermediate` int(1) NOT NULL DEFAULT '0',
  `mineAdvanced` int(1) NOT NULL DEFAULT '0',
  `mineExpert` int(1) NOT NULL DEFAULT '0',
  `herbNovice` int(1) NOT NULL DEFAULT '0',
  `herbIntermediate` int(1) NOT NULL DEFAULT '0',
  `herbAdvanced` int(1) NOT NULL DEFAULT '0',
  `herbExpert` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`characterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for auth_server_channel_ip
-- ----------------------------
DROP TABLE IF EXISTS `auth_server_channel_ip`;
CREATE TABLE `auth_server_channel_ip` (
  `channelconfigid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channelid` int(10) unsigned NOT NULL DEFAULT '0',
  `name` tinytext NOT NULL,
  `value` tinytext NOT NULL,
  PRIMARY KEY (`channelconfigid`),
  KEY `channelid` (`channelid`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for battlelog
-- ----------------------------
DROP TABLE IF EXISTS `battlelog`;
CREATE TABLE `battlelog` (
  `battlelogid` int(11) NOT NULL AUTO_INCREMENT,
  `accid` int(11) NOT NULL DEFAULT '0',
  `accid_to` int(11) NOT NULL DEFAULT '0',
  `when` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`battlelogid`),
  KEY `accid` (`accid`),
  CONSTRAINT `battlelog_ibfk_1` FOREIGN KEY (`accid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bbs_replies
-- ----------------------------
DROP TABLE IF EXISTS `bbs_replies`;
CREATE TABLE `bbs_replies` (
  `replyid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `threadid` int(10) unsigned NOT NULL,
  `postercid` int(10) unsigned NOT NULL,
  `timestamp` bigint(20) unsigned NOT NULL,
  `content` varchar(26) NOT NULL DEFAULT '',
  `guildid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`replyid`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bbs_threads
-- ----------------------------
DROP TABLE IF EXISTS `bbs_threads`;
CREATE TABLE `bbs_threads` (
  `threadid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `postercid` int(10) unsigned NOT NULL,
  `name` varchar(26) NOT NULL DEFAULT '',
  `timestamp` bigint(20) unsigned NOT NULL,
  `icon` smallint(5) unsigned NOT NULL,
  `startpost` text NOT NULL,
  `guildid` int(10) unsigned NOT NULL,
  `localthreadid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`threadid`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for buddies
-- ----------------------------
DROP TABLE IF EXISTS `buddies`;
CREATE TABLE `buddies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL,
  `buddyid` int(11) NOT NULL,
  `pending` tinyint(4) NOT NULL DEFAULT '0',
  `groupname` varchar(16) NOT NULL DEFAULT 'ETC',
  PRIMARY KEY (`id`),
  KEY `buddies_ibfk_1` (`characterid`),
  KEY `buddyid` (`buddyid`),
  KEY `id` (`id`),
  CONSTRAINT `buddies_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20686 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for cashshop_limit_sell
-- ----------------------------
DROP TABLE IF EXISTS `cashshop_limit_sell`;
CREATE TABLE `cashshop_limit_sell` (
  `serial` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`serial`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cashshop_modified_items
-- ----------------------------
DROP TABLE IF EXISTS `cashshop_modified_items`;
CREATE TABLE `cashshop_modified_items` (
  `serial` int(11) NOT NULL,
  `discount_price` int(11) NOT NULL DEFAULT '-1',
  `mark` tinyint(1) NOT NULL DEFAULT '-1',
  `showup` tinyint(1) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `priority` tinyint(3) NOT NULL DEFAULT '0',
  `package` tinyint(1) NOT NULL DEFAULT '0',
  `period` tinyint(3) NOT NULL DEFAULT '0',
  `gender` tinyint(1) NOT NULL DEFAULT '0',
  `count` tinyint(3) NOT NULL DEFAULT '0',
  `meso` int(11) NOT NULL DEFAULT '0',
  `unk_1` tinyint(1) NOT NULL DEFAULT '0',
  `unk_2` tinyint(1) NOT NULL DEFAULT '0',
  `unk_3` tinyint(1) NOT NULL DEFAULT '0',
  `extra_flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`serial`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for character_cards
-- ----------------------------
DROP TABLE IF EXISTS `character_cards`;
CREATE TABLE `character_cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accid` int(10) NOT NULL,
  `worldid` int(11) NOT NULL,
  `characterid` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for character_slots
-- ----------------------------
DROP TABLE IF EXISTS `character_slots`;
CREATE TABLE `character_slots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accid` int(11) NOT NULL DEFAULT '0',
  `worldid` int(11) NOT NULL DEFAULT '0',
  `charslots` int(11) NOT NULL DEFAULT '6',
  PRIMARY KEY (`id`),
  KEY `accid` (`accid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2838 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for characters
-- ----------------------------
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(11) NOT NULL DEFAULT '0',
  `world` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(13) NOT NULL DEFAULT '',
  `level` int(3) unsigned NOT NULL DEFAULT '0',
  `exp` bigint(20) NOT NULL DEFAULT '0',
  `str` int(5) NOT NULL DEFAULT '0',
  `dex` int(5) NOT NULL DEFAULT '0',
  `luk` int(5) NOT NULL DEFAULT '0',
  `int` int(5) NOT NULL DEFAULT '0',
  `hp` int(5) NOT NULL DEFAULT '0',
  `mp` int(5) NOT NULL DEFAULT '0',
  `maxhp` int(5) NOT NULL DEFAULT '0',
  `maxmp` int(5) NOT NULL DEFAULT '0',
  `meso` int(11) NOT NULL DEFAULT '0',
  `hpApUsed` int(5) NOT NULL DEFAULT '0',
  `job` int(5) NOT NULL DEFAULT '0',
  `skincolor` tinyint(1) NOT NULL DEFAULT '0',
  `gender` tinyint(1) NOT NULL DEFAULT '0',
  `fame` int(5) NOT NULL DEFAULT '0',
  `hair` int(11) NOT NULL DEFAULT '0',
  `face` int(11) unsigned NOT NULL DEFAULT '0',
  `demonMarking` int(11) NOT NULL DEFAULT '0',
  `ap` int(11) NOT NULL DEFAULT '0',
  `map` int(11) NOT NULL DEFAULT '0',
  `spawnpoint` int(3) NOT NULL DEFAULT '0',
  `gm` int(3) NOT NULL DEFAULT '0',
  `party` int(11) NOT NULL DEFAULT '0',
  `buddyCapacity` int(11) NOT NULL DEFAULT '25',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `guildrank` tinyint(1) unsigned NOT NULL DEFAULT '5',
  `allianceRank` tinyint(1) unsigned NOT NULL DEFAULT '5',
  `guildContribution` int(11) NOT NULL DEFAULT '0',
  `pets` varchar(13) NOT NULL DEFAULT '-1,-1,-1',
  `sp` varchar(255) NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0',
  `subcategory` int(11) NOT NULL DEFAULT '0',
  `rank` int(11) NOT NULL DEFAULT '1',
  `rankMove` int(11) NOT NULL DEFAULT '0',
  `jobRank` int(11) NOT NULL DEFAULT '1',
  `jobRankMove` int(11) NOT NULL DEFAULT '0',
  `marriageId` int(11) NOT NULL DEFAULT '0',
  `familyid` int(11) NOT NULL DEFAULT '0',
  `seniorid` int(11) NOT NULL DEFAULT '0',
  `junior1` int(11) NOT NULL DEFAULT '0',
  `junior2` int(11) NOT NULL DEFAULT '0',
  `currentrep` int(11) NOT NULL DEFAULT '0',
  `totalrep` int(11) NOT NULL DEFAULT '0',
  `gachexp` int(11) NOT NULL DEFAULT '0',
  `fatigue` tinyint(4) NOT NULL DEFAULT '0',
  `charm` mediumint(7) NOT NULL DEFAULT '0',
  `craft` mediumint(7) NOT NULL DEFAULT '0',
  `charisma` mediumint(7) NOT NULL DEFAULT '0',
  `will` mediumint(7) NOT NULL DEFAULT '0',
  `sense` mediumint(7) NOT NULL DEFAULT '0',
  `insight` mediumint(7) NOT NULL DEFAULT '0',
  `honourExp` bigint(20) NOT NULL DEFAULT '0',
  `honourLevel` int(10) unsigned NOT NULL DEFAULT '1',
  `damage` int(11) NOT NULL DEFAULT '0',
  `showdamage` int(11) DEFAULT '1',
  `totalWins` int(11) NOT NULL DEFAULT '0',
  `totalLosses` int(11) NOT NULL DEFAULT '0',
  `pvpExp` int(11) NOT NULL DEFAULT '0',
  `pvpPoints` int(11) NOT NULL DEFAULT '0',
  `prefix` varchar(45) DEFAULT NULL,
  `chatType` int(11) NOT NULL DEFAULT '-3',
  `hcMode` int(11) NOT NULL DEFAULT '0',
  `forgeEXP` int(11) NOT NULL DEFAULT '0',
  `mSkillPoints` int(11) NOT NULL DEFAULT '0',
  `friendshippoints` varchar(255) NOT NULL DEFAULT '0,0,0,0',
  `azwanCoinsAvail` int(11) NOT NULL DEFAULT '0',
  `azwanCoinsRedeemed` int(11) NOT NULL DEFAULT '0',
  `azwanCCoinsAvail` int(11) NOT NULL DEFAULT '0',
  `azwanECoinsAvail` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `accountid` (`accountid`),
  KEY `id` (`id`),
  KEY `guildid` (`guildid`),
  KEY `familyid` (`familyid`),
  KEY `marriageId` (`marriageId`),
  KEY `seniorid` (`seniorid`)
) ENGINE=InnoDB AUTO_INCREMENT=582 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for cheatlog
-- ----------------------------
DROP TABLE IF EXISTS `cheatlog`;
CREATE TABLE `cheatlog` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) unsigned NOT NULL DEFAULT '0',
  `offense` tinytext NOT NULL,
  `count` int(11) unsigned NOT NULL DEFAULT '0',
  `lastoffensetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `param` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`characterid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for chrimg
-- ----------------------------
DROP TABLE IF EXISTS `chrimg`;
CREATE TABLE `chrimg` (
  `id` int(11) NOT NULL,
  `hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for compensationlog_confirmed
-- ----------------------------
DROP TABLE IF EXISTS `compensationlog_confirmed`;
CREATE TABLE `compensationlog_confirmed` (
  `chrname` varchar(25) NOT NULL DEFAULT '',
  `donor` tinyint(1) NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  `taken` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`chrname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for crystaldonors
-- ----------------------------
DROP TABLE IF EXISTS `crystaldonors`;
CREATE TABLE `crystaldonors` (
  `txn_id` varchar(50) NOT NULL DEFAULT '',
  `accountid` int(10) DEFAULT NULL,
  `payer_email` varchar(255) DEFAULT NULL,
  `mc_gross` varchar(10) DEFAULT NULL,
  `payment_date` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for csequipment
-- ----------------------------
DROP TABLE IF EXISTS `csequipment`;
CREATE TABLE `csequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `luk` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `watk` int(11) NOT NULL DEFAULT '0',
  `matk` int(11) NOT NULL DEFAULT '0',
  `wdef` int(11) NOT NULL DEFAULT '0',
  `mdef` int(11) NOT NULL DEFAULT '0',
  `acc` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hands` int(11) NOT NULL DEFAULT '0',
  `speed` int(11) NOT NULL DEFAULT '0',
  `jump` int(11) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` int(6) NOT NULL DEFAULT '-1',
  `pvpDamage` int(6) NOT NULL DEFAULT '0',
  `cashCover` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `csequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `csitems` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63885 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for csitems
-- ----------------------------
DROP TABLE IF EXISTS `csitems`;
CREATE TABLE `csitems` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageid` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventoryitems_ibfk_1` (`characterid`),
  KEY `characterid` (`characterid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `packageid` (`packageid`),
  KEY `characterid_2` (`characterid`,`inventorytype`)
) ENGINE=InnoDB AUTO_INCREMENT=117445 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for donation
-- ----------------------------
DROP TABLE IF EXISTS `donation`;
CREATE TABLE `donation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `username` varchar(13) NOT NULL,
  `quantity` smallint(5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for donorlog
-- ----------------------------
DROP TABLE IF EXISTS `donorlog`;
CREATE TABLE `donorlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accname` varchar(25) NOT NULL DEFAULT '',
  `accId` int(11) NOT NULL DEFAULT '0',
  `chrname` varchar(25) NOT NULL DEFAULT '',
  `chrId` int(11) NOT NULL DEFAULT '0',
  `log` varchar(4096) NOT NULL DEFAULT '',
  `time` varchar(25) NOT NULL DEFAULT '',
  `previousPoints` int(11) NOT NULL DEFAULT '0',
  `currentPoints` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for download_manager
-- ----------------------------
DROP TABLE IF EXISTS `download_manager`;
CREATE TABLE `download_manager` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `filename` varchar(128) NOT NULL,
  `downloads` int(21) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`filename`),
  UNIQUE KEY `filename` (`filename`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for drop_data
-- ----------------------------
DROP TABLE IF EXISTS `drop_data`;
CREATE TABLE `drop_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dropperid` int(11) NOT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `minimum_quantity` int(11) NOT NULL DEFAULT '1',
  `maximum_quantity` int(11) NOT NULL DEFAULT '1',
  `questid` int(11) NOT NULL DEFAULT '0',
  `chance` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mobid` (`dropperid`)
) ENGINE=MyISAM AUTO_INCREMENT=45453 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for drop_data_global
-- ----------------------------
DROP TABLE IF EXISTS `drop_data_global`;
CREATE TABLE `drop_data_global` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `continent` int(11) NOT NULL,
  `dropType` tinyint(1) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `minimum_quantity` int(11) NOT NULL DEFAULT '1',
  `maximum_quantity` int(11) NOT NULL DEFAULT '1',
  `questid` int(11) NOT NULL DEFAULT '0',
  `chance` int(11) NOT NULL DEFAULT '0',
  `comments` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mobid` (`continent`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=163 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for dueyequipment
-- ----------------------------
DROP TABLE IF EXISTS `dueyequipment`;
CREATE TABLE `dueyequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `luk` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `watk` int(11) NOT NULL DEFAULT '0',
  `matk` int(11) NOT NULL DEFAULT '0',
  `wdef` int(11) NOT NULL DEFAULT '0',
  `mdef` int(11) NOT NULL DEFAULT '0',
  `acc` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hands` int(11) NOT NULL DEFAULT '0',
  `speed` int(11) NOT NULL DEFAULT '0',
  `jump` int(11) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` smallint(6) NOT NULL DEFAULT '-1',
  `pvpDamage` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `dueyequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `dueyitems` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for dueyitems
-- ----------------------------
DROP TABLE IF EXISTS `dueyitems`;
CREATE TABLE `dueyitems` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageid` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventoryitems_ibfk_1` (`characterid`),
  KEY `characterid` (`characterid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `packageid` (`packageid`),
  KEY `characterid_2` (`characterid`,`inventorytype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for dueypackages
-- ----------------------------
DROP TABLE IF EXISTS `dueypackages`;
CREATE TABLE `dueypackages` (
  `PackageId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `RecieverId` int(10) NOT NULL,
  `SenderName` varchar(13) NOT NULL,
  `Mesos` int(10) unsigned DEFAULT '0',
  `TimeStamp` bigint(20) unsigned DEFAULT NULL,
  `Checked` tinyint(1) unsigned DEFAULT '1',
  `Type` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`PackageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for extendedslots
-- ----------------------------
DROP TABLE IF EXISTS `extendedslots`;
CREATE TABLE `extendedslots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `itemId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for famelog
-- ----------------------------
DROP TABLE IF EXISTS `famelog`;
CREATE TABLE `famelog` (
  `famelogid` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `characterid_to` int(11) NOT NULL DEFAULT '0',
  `when` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`famelogid`),
  KEY `characterid` (`characterid`),
  CONSTRAINT `famelog_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for familiars
-- ----------------------------
DROP TABLE IF EXISTS `familiars`;
CREATE TABLE `familiars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `familiar` int(11) NOT NULL DEFAULT '0',
  `name` varchar(40) NOT NULL DEFAULT '',
  `fatigue` int(11) NOT NULL DEFAULT '0',
  `expiry` bigint(20) NOT NULL DEFAULT '0',
  `vitality` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104593 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for families
-- ----------------------------
DROP TABLE IF EXISTS `families`;
CREATE TABLE `families` (
  `familyid` int(11) NOT NULL AUTO_INCREMENT,
  `leaderid` int(11) NOT NULL DEFAULT '0',
  `notice` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`familyid`),
  KEY `familyid` (`familyid`),
  KEY `leaderid` (`leaderid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for gifts
-- ----------------------------
DROP TABLE IF EXISTS `gifts`;
CREATE TABLE `gifts` (
  `giftid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` int(11) NOT NULL DEFAULT '0',
  `from` varchar(13) NOT NULL DEFAULT '',
  `message` varchar(255) NOT NULL DEFAULT '',
  `sn` int(11) NOT NULL DEFAULT '0',
  `uniqueid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`giftid`),
  KEY `recipient` (`recipient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gmlog
-- ----------------------------
DROP TABLE IF EXISTS `gmlog`;
CREATE TABLE `gmlog` (
  `gmlogid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL DEFAULT '0',
  `command` text NOT NULL,
  `mapid` int(11) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`gmlogid`)
) ENGINE=InnoDB AUTO_INCREMENT=41856 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for guilds
-- ----------------------------
DROP TABLE IF EXISTS `guilds`;
CREATE TABLE `guilds` (
  `guildid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `leader` int(10) unsigned NOT NULL DEFAULT '0',
  `GP` int(11) NOT NULL DEFAULT '0',
  `logo` int(10) unsigned DEFAULT NULL,
  `logoColor` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(45) NOT NULL,
  `rank1title` varchar(45) NOT NULL DEFAULT 'Master',
  `rank2title` varchar(45) NOT NULL DEFAULT 'Jr. Master',
  `rank3title` varchar(45) NOT NULL DEFAULT 'Member',
  `rank4title` varchar(45) NOT NULL DEFAULT 'Member',
  `rank5title` varchar(45) NOT NULL DEFAULT 'Member',
  `capacity` int(10) unsigned NOT NULL DEFAULT '10',
  `logoBG` int(10) unsigned DEFAULT NULL,
  `logoBGColor` smallint(5) unsigned NOT NULL DEFAULT '0',
  `notice` varchar(101) DEFAULT NULL,
  `signature` int(11) NOT NULL DEFAULT '0',
  `alliance` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`),
  UNIQUE KEY `name` (`name`),
  KEY `guildid` (`guildid`),
  KEY `leader` (`leader`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for guildskills
-- ----------------------------
DROP TABLE IF EXISTS `guildskills`;
CREATE TABLE `guildskills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guildid` int(11) NOT NULL DEFAULT '0',
  `skillid` int(11) NOT NULL DEFAULT '0',
  `level` smallint(3) NOT NULL DEFAULT '1',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `purchaser` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for hiredmerch
-- ----------------------------
DROP TABLE IF EXISTS `hiredmerch`;
CREATE TABLE `hiredmerch` (
  `PackageId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(10) unsigned DEFAULT '0',
  `accountid` int(10) unsigned DEFAULT NULL,
  `Mesos` int(10) unsigned DEFAULT '0',
  `time` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`PackageId`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hiredmerchequipment
-- ----------------------------
DROP TABLE IF EXISTS `hiredmerchequipment`;
CREATE TABLE `hiredmerchequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `luk` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `watk` int(11) NOT NULL DEFAULT '0',
  `matk` int(11) NOT NULL DEFAULT '0',
  `wdef` int(11) NOT NULL DEFAULT '0',
  `mdef` int(11) NOT NULL DEFAULT '0',
  `acc` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hands` int(11) NOT NULL DEFAULT '0',
  `speed` int(11) NOT NULL DEFAULT '0',
  `jump` int(11) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` smallint(6) NOT NULL DEFAULT '-1',
  `pvpDamage` smallint(6) NOT NULL DEFAULT '0',
  `cashCover` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `hiredmerchequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `hiredmerchitems` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for hiredmerchitems
-- ----------------------------
DROP TABLE IF EXISTS `hiredmerchitems`;
CREATE TABLE `hiredmerchitems` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageid` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventoryitems_ibfk_1` (`characterid`),
  KEY `characterid` (`characterid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `packageid` (`packageid`),
  KEY `characterid_2` (`characterid`,`inventorytype`)
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for hyperrocklocations
-- ----------------------------
DROP TABLE IF EXISTS `hyperrocklocations`;
CREATE TABLE `hyperrocklocations` (
  `trockid` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `mapid` int(11) DEFAULT NULL,
  PRIMARY KEY (`trockid`)
) ENGINE=MyISAM AUTO_INCREMENT=357 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for imps
-- ----------------------------
DROP TABLE IF EXISTS `imps`;
CREATE TABLE `imps` (
  `impid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `closeness` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `fullness` mediumint(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`impid`),
  KEY `impid` (`impid`)
) ENGINE=InnoDB AUTO_INCREMENT=2364 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for inner_ability_skills
-- ----------------------------
DROP TABLE IF EXISTS `inner_ability_skills`;
CREATE TABLE `inner_ability_skills` (
  `player_id` int(11) unsigned NOT NULL,
  `skill_id` int(9) unsigned NOT NULL,
  `skill_level` tinyint(2) unsigned NOT NULL,
  `max_level` tinyint(2) unsigned NOT NULL,
  `rank` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for internlog
-- ----------------------------
DROP TABLE IF EXISTS `internlog`;
CREATE TABLE `internlog` (
  `gmlogid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL DEFAULT '0',
  `command` tinytext NOT NULL,
  `mapid` int(11) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`gmlogid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for inventoryequipment
-- ----------------------------
DROP TABLE IF EXISTS `inventoryequipment`;
CREATE TABLE `inventoryequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `str` int(6) NOT NULL DEFAULT '0',
  `dex` int(6) NOT NULL DEFAULT '0',
  `int` int(6) NOT NULL DEFAULT '0',
  `luk` int(6) NOT NULL DEFAULT '0',
  `hp` int(6) NOT NULL DEFAULT '0',
  `mp` int(6) NOT NULL DEFAULT '0',
  `watk` int(6) NOT NULL DEFAULT '0',
  `matk` int(6) NOT NULL DEFAULT '0',
  `wdef` int(6) NOT NULL DEFAULT '0',
  `mdef` int(6) NOT NULL DEFAULT '0',
  `acc` int(6) NOT NULL DEFAULT '0',
  `avoid` int(6) NOT NULL DEFAULT '0',
  `hands` int(6) NOT NULL DEFAULT '0',
  `speed` int(6) NOT NULL DEFAULT '0',
  `jump` int(6) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` int(6) NOT NULL DEFAULT '-1',
  `pvpDamage` int(6) NOT NULL DEFAULT '0',
  `cashCover` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `inventoryequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `inventoryitems` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3159513 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for inventoryitems
-- ----------------------------
DROP TABLE IF EXISTS `inventoryitems`;
CREATE TABLE `inventoryitems` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageid` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `packageid` (`packageid`),
  KEY `characterid_2` (`characterid`,`inventorytype`)
) ENGINE=InnoDB AUTO_INCREMENT=8319321 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for inventorylog
-- ----------------------------
DROP TABLE IF EXISTS `inventorylog`;
CREATE TABLE `inventorylog` (
  `inventorylogid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` int(10) unsigned NOT NULL DEFAULT '0',
  `msg` tinytext NOT NULL,
  PRIMARY KEY (`inventorylogid`),
  KEY `inventoryitemid` (`inventoryitemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for inventoryslot
-- ----------------------------
DROP TABLE IF EXISTS `inventoryslot`;
CREATE TABLE `inventoryslot` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(10) unsigned DEFAULT NULL,
  `equip` tinyint(3) unsigned DEFAULT NULL,
  `use` tinyint(3) unsigned DEFAULT NULL,
  `setup` tinyint(3) unsigned DEFAULT NULL,
  `etc` tinyint(3) unsigned DEFAULT NULL,
  `cash` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `characterid` (`characterid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125278 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for ipbans
-- ----------------------------
DROP TABLE IF EXISTS `ipbans`;
CREATE TABLE `ipbans` (
  `ipbanid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`ipbanid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for iplog
-- ----------------------------
DROP TABLE IF EXISTS `iplog`;
CREATE TABLE `iplog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `accid` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for ipvotelog
-- ----------------------------
DROP TABLE IF EXISTS `ipvotelog`;
CREATE TABLE `ipvotelog` (
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accid` int(11) NOT NULL DEFAULT '0',
  `ipaddress` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `votetime` bigint(20) NOT NULL DEFAULT '0',
  `votetype` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ipvotes
-- ----------------------------
DROP TABLE IF EXISTS `ipvotes`;
CREATE TABLE `ipvotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(30) NOT NULL,
  `accid` int(11) NOT NULL,
  `lastvote` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for keymap
-- ----------------------------
DROP TABLE IF EXISTS `keymap`;
CREATE TABLE `keymap` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `key` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `action` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `keymap_ibfk_1` (`characterid`),
  CONSTRAINT `keymap_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3902059 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for macbans
-- ----------------------------
DROP TABLE IF EXISTS `macbans`;
CREATE TABLE `macbans` (
  `macbanid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mac` varchar(30) NOT NULL,
  PRIMARY KEY (`macbanid`),
  UNIQUE KEY `mac_2` (`mac`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for macfilters
-- ----------------------------
DROP TABLE IF EXISTS `macfilters`;
CREATE TABLE `macfilters` (
  `macfilterid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filter` varchar(30) NOT NULL,
  PRIMARY KEY (`macfilterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for masterskills
-- ----------------------------
DROP TABLE IF EXISTS `masterskills`;
CREATE TABLE `masterskills` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `chrid` int(11) NOT NULL,
  `skillid` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `lastUseTime` bigint(25) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4773 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for monsterbook
-- ----------------------------
DROP TABLE IF EXISTS `monsterbook`;
CREATE TABLE `monsterbook` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `charid` int(10) unsigned NOT NULL DEFAULT '0',
  `cardid` int(10) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(2) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `charid` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=10470 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mountdata
-- ----------------------------
DROP TABLE IF EXISTS `mountdata`;
CREATE TABLE `mountdata` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(10) unsigned DEFAULT NULL,
  `Level` int(3) unsigned NOT NULL DEFAULT '0',
  `Exp` int(10) unsigned NOT NULL DEFAULT '0',
  `Fatigue` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `characterid` (`characterid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6853 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mts_cart
-- ----------------------------
DROP TABLE IF EXISTS `mts_cart`;
CREATE TABLE `mts_cart` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `characterid` (`characterid`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mts_items
-- ----------------------------
DROP TABLE IF EXISTS `mts_items`;
CREATE TABLE `mts_items` (
  `id` int(11) NOT NULL,
  `tab` tinyint(1) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '0',
  `characterid` int(11) NOT NULL DEFAULT '0',
  `seller` varchar(13) NOT NULL DEFAULT '',
  `expiration` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mtsequipment
-- ----------------------------
DROP TABLE IF EXISTS `mtsequipment`;
CREATE TABLE `mtsequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `luk` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `watk` int(11) NOT NULL DEFAULT '0',
  `matk` int(11) NOT NULL DEFAULT '0',
  `wdef` int(11) NOT NULL DEFAULT '0',
  `mdef` int(11) NOT NULL DEFAULT '0',
  `acc` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hands` int(11) NOT NULL DEFAULT '0',
  `speed` int(11) NOT NULL DEFAULT '0',
  `jump` int(11) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` smallint(6) NOT NULL DEFAULT '-1',
  `pvpDamage` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `mtsequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `mtsitems` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mtsitems
-- ----------------------------
DROP TABLE IF EXISTS `mtsitems`;
CREATE TABLE `mtsitems` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageId` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventoryitems_ibfk_1` (`characterid`),
  KEY `characterid` (`characterid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `characterid_2` (`characterid`,`inventorytype`),
  KEY `packageid` (`packageId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mtstransfer
-- ----------------------------
DROP TABLE IF EXISTS `mtstransfer`;
CREATE TABLE `mtstransfer` (
  `inventoryitemid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `accountid` int(10) DEFAULT NULL,
  `packageid` int(11) DEFAULT NULL,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `inventorytype` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `owner` tinytext,
  `GM_Log` tinytext,
  `uniqueid` int(11) NOT NULL DEFAULT '-1',
  `flag` int(2) NOT NULL DEFAULT '0',
  `expiredate` bigint(20) NOT NULL DEFAULT '-1',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `sender` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`inventoryitemid`),
  KEY `inventoryitems_ibfk_1` (`characterid`),
  KEY `characterid` (`characterid`),
  KEY `inventorytype` (`inventorytype`),
  KEY `accountid` (`accountid`),
  KEY `packageid` (`packageid`),
  KEY `characterid_2` (`characterid`,`inventorytype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for mtstransferequipment
-- ----------------------------
DROP TABLE IF EXISTS `mtstransferequipment`;
CREATE TABLE `mtstransferequipment` (
  `inventoryequipmentid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitemid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `upgradeslots` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `luk` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `watk` int(11) NOT NULL DEFAULT '0',
  `matk` int(11) NOT NULL DEFAULT '0',
  `wdef` int(11) NOT NULL DEFAULT '0',
  `mdef` int(11) NOT NULL DEFAULT '0',
  `acc` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hands` int(11) NOT NULL DEFAULT '0',
  `speed` int(11) NOT NULL DEFAULT '0',
  `jump` int(11) NOT NULL DEFAULT '0',
  `ViciousHammer` tinyint(2) NOT NULL DEFAULT '0',
  `itemEXP` int(11) NOT NULL DEFAULT '0',
  `durability` int(11) NOT NULL DEFAULT '-1',
  `enhance` tinyint(3) NOT NULL DEFAULT '0',
  `potential1` int(5) NOT NULL DEFAULT '0',
  `potential2` int(5) NOT NULL DEFAULT '0',
  `potential3` int(5) NOT NULL DEFAULT '0',
  `potential4` int(5) NOT NULL DEFAULT '0',
  `potential5` int(5) NOT NULL DEFAULT '0',
  `socket1` int(5) NOT NULL DEFAULT '-1',
  `socket2` int(5) NOT NULL DEFAULT '-1',
  `socket3` int(5) NOT NULL DEFAULT '-1',
  `incSkill` int(11) NOT NULL DEFAULT '-1',
  `charmEXP` smallint(6) NOT NULL DEFAULT '-1',
  `pvpDamage` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventoryequipmentid`),
  KEY `inventoryitemid` (`inventoryitemid`),
  CONSTRAINT `mtstransferequipment_ibfk_1` FOREIGN KEY (`inventoryitemid`) REFERENCES `mtstransfer` (`inventoryitemid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for notes
-- ----------------------------
DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to` varchar(13) NOT NULL DEFAULT '',
  `from` varchar(13) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `timestamp` bigint(20) unsigned NOT NULL,
  `gift` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `to` (`to`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for nxcode
-- ----------------------------
DROP TABLE IF EXISTS `nxcode`;
CREATE TABLE `nxcode` (
  `code` varchar(15) NOT NULL,
  `valid` int(11) NOT NULL DEFAULT '1',
  `user` varchar(13) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `item` int(11) NOT NULL DEFAULT '10000',
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pets
-- ----------------------------
DROP TABLE IF EXISTS `pets`;
CREATE TABLE `pets` (
  `petid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(13) DEFAULT NULL,
  `level` int(3) unsigned NOT NULL,
  `closeness` int(6) unsigned NOT NULL,
  `fullness` int(3) unsigned NOT NULL,
  `seconds` int(11) NOT NULL DEFAULT '0',
  `flags` smallint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`petid`),
  KEY `petid` (`petid`)
) ENGINE=InnoDB AUTO_INCREMENT=21746 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for playernpcs
-- ----------------------------
DROP TABLE IF EXISTS `playernpcs`;
CREATE TABLE `playernpcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(13) NOT NULL,
  `hair` int(11) NOT NULL,
  `face` int(11) NOT NULL,
  `skin` int(11) NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `map` int(11) NOT NULL,
  `charid` int(11) NOT NULL,
  `scriptid` int(11) NOT NULL,
  `foothold` int(11) NOT NULL,
  `dir` tinyint(1) NOT NULL DEFAULT '0',
  `gender` tinyint(1) NOT NULL DEFAULT '0',
  `pets` varchar(25) DEFAULT '0,0,0',
  PRIMARY KEY (`id`),
  KEY `scriptid` (`scriptid`),
  KEY `playernpcs_ibfk_1` (`charid`),
  CONSTRAINT `playernpcs_ibfk_1` FOREIGN KEY (`charid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for playernpcs_equip
-- ----------------------------
DROP TABLE IF EXISTS `playernpcs_equip`;
CREATE TABLE `playernpcs_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `npcid` int(11) NOT NULL,
  `equipid` int(11) NOT NULL,
  `equippos` int(11) NOT NULL,
  `charid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `playernpcs_equip_ibfk_1` (`charid`),
  KEY `playernpcs_equip_ibfk_2` (`npcid`),
  CONSTRAINT `playernpcs_equip_ibfk_1` FOREIGN KEY (`charid`) REFERENCES `characters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `playernpcs_equip_ibfk_2` FOREIGN KEY (`npcid`) REFERENCES `playernpcs` (`scriptid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pwreset
-- ----------------------------
DROP TABLE IF EXISTS `pwreset`;
CREATE TABLE `pwreset` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(14) NOT NULL,
  `email` varchar(100) NOT NULL,
  `confirmkey` varchar(100) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timestamp` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for questinfo
-- ----------------------------
DROP TABLE IF EXISTS `questinfo`;
CREATE TABLE `questinfo` (
  `questinfoid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `quest` int(6) NOT NULL DEFAULT '0',
  `customData` varchar(555) DEFAULT NULL,
  PRIMARY KEY (`questinfoid`),
  KEY `characterid` (`characterid`),
  CONSTRAINT `questsinfo_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29458 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for queststatus
-- ----------------------------
DROP TABLE IF EXISTS `queststatus`;
CREATE TABLE `queststatus` (
  `queststatusid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `quest` int(6) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  `forfeited` int(11) NOT NULL DEFAULT '0',
  `customData` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`queststatusid`),
  KEY `characterid` (`characterid`),
  KEY `queststatusid` (`queststatusid`),
  CONSTRAINT `queststatus_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3072902 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for queststatusmobs
-- ----------------------------
DROP TABLE IF EXISTS `queststatusmobs`;
CREATE TABLE `queststatusmobs` (
  `queststatusmobid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queststatusid` int(10) unsigned NOT NULL DEFAULT '0',
  `mob` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`queststatusmobid`),
  KEY `queststatusid` (`queststatusid`),
  CONSTRAINT `queststatusmobs_ibfk_1` FOREIGN KEY (`queststatusid`) REFERENCES `queststatus` (`queststatusid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27946 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for reactordrops
-- ----------------------------
DROP TABLE IF EXISTS `reactordrops`;
CREATE TABLE `reactordrops` (
  `reactordropid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reactorid` int(11) NOT NULL,
  `itemid` int(11) NOT NULL,
  `chance` int(11) NOT NULL,
  `questid` int(5) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`reactordropid`),
  KEY `reactorid` (`reactorid`)
) ENGINE=MyISAM AUTO_INCREMENT=866 DEFAULT CHARSET=utf8 PACK_KEYS=1;

-- ----------------------------
-- Table structure for regrocklocations
-- ----------------------------
DROP TABLE IF EXISTS `regrocklocations`;
CREATE TABLE `regrocklocations` (
  `trockid` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `mapid` int(11) DEFAULT NULL,
  PRIMARY KEY (`trockid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for reports
-- ----------------------------
DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
  `reportid` int(9) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(2) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`reportid`,`characterid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rings
-- ----------------------------
DROP TABLE IF EXISTS `rings`;
CREATE TABLE `rings` (
  `ringid` int(11) NOT NULL AUTO_INCREMENT,
  `partnerRingId` int(11) NOT NULL DEFAULT '0',
  `partnerChrId` int(11) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `partnername` varchar(255) NOT NULL,
  PRIMARY KEY (`ringid`),
  KEY `ringid` (`ringid`),
  KEY `partnerChrId` (`partnerChrId`),
  KEY `partnerRingId` (`partnerRingId`)
) ENGINE=InnoDB AUTO_INCREMENT=19746 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for savedlocations
-- ----------------------------
DROP TABLE IF EXISTS `savedlocations`;
CREATE TABLE `savedlocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL,
  `locationtype` int(11) NOT NULL DEFAULT '0',
  `map` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `savedlocations_ibfk_1` (`characterid`),
  CONSTRAINT `savedlocations_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2790 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for scroll_log
-- ----------------------------
DROP TABLE IF EXISTS `scroll_log`;
CREATE TABLE `scroll_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accId` int(11) NOT NULL DEFAULT '0',
  `chrId` int(11) NOT NULL DEFAULT '0',
  `scrollId` int(11) NOT NULL DEFAULT '0',
  `itemId` int(11) NOT NULL DEFAULT '0',
  `oldSlots` tinyint(4) NOT NULL DEFAULT '0',
  `newSlots` tinyint(4) NOT NULL DEFAULT '0',
  `hammer` tinyint(4) NOT NULL DEFAULT '0',
  `result` varchar(13) NOT NULL DEFAULT '',
  `whiteScroll` tinyint(1) NOT NULL DEFAULT '0',
  `legendarySpirit` tinyint(1) NOT NULL DEFAULT '0',
  `vegaId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1706 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for shopitems
-- ----------------------------
DROP TABLE IF EXISTS `shopitems`;
CREATE TABLE `shopitems` (
  `shopitemid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shopid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `reqitem` int(11) NOT NULL DEFAULT '0',
  `reqitemq` int(11) NOT NULL DEFAULT '0',
  `rank` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shopitemid`),
  KEY `shopid` (`shopid`)
) ENGINE=MyISAM AUTO_INCREMENT=6159 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shopranks
-- ----------------------------
DROP TABLE IF EXISTS `shopranks`;
CREATE TABLE `shopranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shopid` int(11) NOT NULL DEFAULT '0',
  `rank` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `itemid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for shops
-- ----------------------------
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops` (
  `shopid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `npcid` int(11) DEFAULT '0',
  PRIMARY KEY (`shopid`)
) ENGINE=MyISAM AUTO_INCREMENT=9595022 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for sidekicks
-- ----------------------------
DROP TABLE IF EXISTS `sidekicks`;
CREATE TABLE `sidekicks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `firstid` int(11) NOT NULL DEFAULT '0',
  `secondid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for skillmacros
-- ----------------------------
DROP TABLE IF EXISTS `skillmacros`;
CREATE TABLE `skillmacros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) NOT NULL DEFAULT '0',
  `position` tinyint(1) NOT NULL DEFAULT '0',
  `skill1` int(11) NOT NULL DEFAULT '0',
  `skill2` int(11) NOT NULL DEFAULT '0',
  `skill3` int(11) NOT NULL DEFAULT '0',
  `name` varchar(30) DEFAULT NULL,
  `shout` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB AUTO_INCREMENT=409 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for skills
-- ----------------------------
DROP TABLE IF EXISTS `skills`;
CREATE TABLE `skills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `skillid` int(11) NOT NULL DEFAULT '0',
  `characterid` int(11) NOT NULL DEFAULT '0',
  `skilllevel` int(11) NOT NULL DEFAULT '0',
  `masterlevel` tinyint(4) NOT NULL DEFAULT '0',
  `expiration` bigint(20) NOT NULL DEFAULT '-1',
  `victimid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `skills_ibfk_1` (`characterid`),
  CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`characterid`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1889474 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for skills_cooldowns
-- ----------------------------
DROP TABLE IF EXISTS `skills_cooldowns`;
CREATE TABLE `skills_cooldowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `SkillID` int(11) NOT NULL,
  `length` bigint(20) NOT NULL,
  `StartTime` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `charid` (`charid`)
) ENGINE=InnoDB AUTO_INCREMENT=608 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for speedruns
-- ----------------------------
DROP TABLE IF EXISTS `speedruns`;
CREATE TABLE `speedruns` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(13) NOT NULL,
  `leader` varchar(13) NOT NULL,
  `timestring` varchar(1024) NOT NULL,
  `time` bigint(20) NOT NULL DEFAULT '0',
  `members` varchar(1024) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for stolen
-- ----------------------------
DROP TABLE IF EXISTS `stolen`;
CREATE TABLE `stolen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterid` varchar(45) NOT NULL,
  `skillid` varchar(45) NOT NULL,
  `chosen` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11539 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for storages
-- ----------------------------
DROP TABLE IF EXISTS `storages`;
CREATE TABLE `storages` (
  `storageid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(11) NOT NULL DEFAULT '0',
  `slots` int(11) NOT NULL DEFAULT '0',
  `meso` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`storageid`),
  KEY `accountid` (`accountid`),
  CONSTRAINT `storages_ibfk_1` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2971 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for tournamentlog
-- ----------------------------
DROP TABLE IF EXISTS `tournamentlog`;
CREATE TABLE `tournamentlog` (
  `logid` int(11) NOT NULL AUTO_INCREMENT,
  `winnerid` int(11) NOT NULL DEFAULT '0',
  `numContestants` int(11) NOT NULL DEFAULT '0',
  `when` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`logid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for trocklocations
-- ----------------------------
DROP TABLE IF EXISTS `trocklocations`;
CREATE TABLE `trocklocations` (
  `trockid` int(11) NOT NULL AUTO_INCREMENT,
  `characterid` int(11) DEFAULT NULL,
  `mapid` int(11) DEFAULT NULL,
  PRIMARY KEY (`trockid`),
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for votingrecords
-- ----------------------------
DROP TABLE IF EXISTS `votingrecords`;
CREATE TABLE `votingrecords` (
  `ip` varchar(255) NOT NULL,
  `account` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `times` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for votingrecords2
-- ----------------------------
DROP TABLE IF EXISTS `votingrecords2`;
CREATE TABLE `votingrecords2` (
  `ip` varchar(255) NOT NULL,
  `account` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `times` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for website_events
-- ----------------------------
DROP TABLE IF EXISTS `website_events`;
CREATE TABLE `website_events` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `author` varchar(16) NOT NULL,
  `date` varchar(32) NOT NULL,
  `type` varchar(100) NOT NULL,
  `status` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `views` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for website_news
-- ----------------------------
DROP TABLE IF EXISTS `website_news`;
CREATE TABLE `website_news` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `author` varchar(16) NOT NULL,
  `date` varchar(32) NOT NULL,
  `type` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `views` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wishlist
-- ----------------------------
DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE `wishlist` (
  `characterid` int(11) NOT NULL,
  `sn` int(11) NOT NULL,
  KEY `characterid` (`characterid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for wz_customlife
-- ----------------------------
DROP TABLE IF EXISTS `wz_customlife`;
CREATE TABLE `wz_customlife` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataid` int(11) NOT NULL,
  `f` int(11) NOT NULL,
  `hide` tinyint(1) NOT NULL DEFAULT '0',
  `fh` int(11) NOT NULL,
  `type` varchar(1) NOT NULL,
  `cy` int(11) NOT NULL,
  `rx0` int(11) NOT NULL,
  `rx1` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `mobtime` int(11) DEFAULT '1000',
  `mid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=547 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wz_itemadddata
-- ----------------------------
DROP TABLE IF EXISTS `wz_itemadddata`;
CREATE TABLE `wz_itemadddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL,
  `key` varchar(30) NOT NULL,
  `subKey` varchar(30) NOT NULL,
  `value` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33852 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_itemdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_itemdata`;
CREATE TABLE `wz_itemdata` (
  `itemid` int(11) NOT NULL,
  `name` tinytext CHARACTER SET utf8,
  `msg` varchar(4096) CHARACTER SET utf8 DEFAULT NULL,
  `desc` varchar(4096) CHARACTER SET utf8 DEFAULT NULL,
  `slotMax` smallint(5) NOT NULL DEFAULT '1',
  `price` varchar(255) NOT NULL DEFAULT '-1.0',
  `wholePrice` int(11) NOT NULL DEFAULT '-1',
  `stateChange` int(11) NOT NULL DEFAULT '0',
  `flags` smallint(4) NOT NULL DEFAULT '0',
  `karma` tinyint(1) NOT NULL DEFAULT '0',
  `meso` int(11) NOT NULL DEFAULT '0',
  `monsterBook` int(11) NOT NULL DEFAULT '0',
  `itemMakeLevel` smallint(6) NOT NULL DEFAULT '0',
  `questId` int(11) NOT NULL DEFAULT '0',
  `scrollReqs` tinytext,
  `consumeItem` tinytext,
  `totalprob` int(11) NOT NULL DEFAULT '0',
  `incSkill` varchar(255) NOT NULL DEFAULT '',
  `replaceid` int(11) NOT NULL DEFAULT '0',
  `replacemsg` varchar(255) NOT NULL DEFAULT '',
  `create` int(11) NOT NULL DEFAULT '0',
  `afterImage` varchar(255) NOT NULL DEFAULT '',
  `option1` int(11) DEFAULT '0',
  `option2` int(11) DEFAULT '0',
  `option3` int(11) DEFAULT '0',
  PRIMARY KEY (`itemid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_itemequipdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_itemequipdata`;
CREATE TABLE `wz_itemequipdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL,
  `itemLevel` int(11) NOT NULL DEFAULT '-1',
  `key` varchar(30) NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3632878 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_itemrewarddata
-- ----------------------------
DROP TABLE IF EXISTS `wz_itemrewarddata`;
CREATE TABLE `wz_itemrewarddata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `prob` int(11) NOT NULL DEFAULT '0',
  `quantity` smallint(5) NOT NULL DEFAULT '0',
  `period` int(11) NOT NULL DEFAULT '-1',
  `worldMsg` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `effect` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=284919 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_mobskilldata
-- ----------------------------
DROP TABLE IF EXISTS `wz_mobskilldata`;
CREATE TABLE `wz_mobskilldata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `skillid` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `hp` int(11) NOT NULL DEFAULT '100',
  `mpcon` int(11) NOT NULL DEFAULT '0',
  `x` int(11) NOT NULL DEFAULT '1',
  `y` int(11) NOT NULL DEFAULT '1',
  `time` int(11) NOT NULL DEFAULT '0',
  `prop` int(11) NOT NULL DEFAULT '100',
  `limit` int(11) NOT NULL DEFAULT '0',
  `spawneffect` int(11) NOT NULL DEFAULT '0',
  `interval` int(11) NOT NULL DEFAULT '0',
  `summons` varchar(1024) NOT NULL DEFAULT '',
  `ltx` int(11) NOT NULL DEFAULT '0',
  `lty` int(11) NOT NULL DEFAULT '0',
  `rbx` int(11) NOT NULL DEFAULT '0',
  `rby` int(11) NOT NULL DEFAULT '0',
  `once` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4704 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wz_oxdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_oxdata`;
CREATE TABLE `wz_oxdata` (
  `questionset` smallint(6) NOT NULL DEFAULT '0',
  `questionid` smallint(6) NOT NULL DEFAULT '0',
  `question` varchar(200) NOT NULL DEFAULT '',
  `display` varchar(200) NOT NULL DEFAULT '',
  `answer` enum('o','x') NOT NULL,
  PRIMARY KEY (`questionset`,`questionid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for wz_questactdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questactdata`;
CREATE TABLE `wz_questactdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questid` int(11) NOT NULL DEFAULT '0',
  `name` varchar(127) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `intStore` int(11) NOT NULL DEFAULT '0',
  `applicableJobs` varchar(1024) NOT NULL DEFAULT '',
  `uniqueid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `quests_ibfk_2` (`questid`)
) ENGINE=MyISAM AUTO_INCREMENT=29516 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_questactitemdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questactitemdata`;
CREATE TABLE `wz_questactitemdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `count` smallint(5) NOT NULL DEFAULT '0',
  `period` int(11) NOT NULL DEFAULT '0',
  `gender` tinyint(1) NOT NULL DEFAULT '2',
  `job` int(11) NOT NULL DEFAULT '-1',
  `jobEx` int(11) NOT NULL DEFAULT '-1',
  `prop` int(11) NOT NULL DEFAULT '-1',
  `uniqueid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=39859 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for wz_questactquestdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questactquestdata`;
CREATE TABLE `wz_questactquestdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quest` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(1) NOT NULL DEFAULT '2',
  `uniqueid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for wz_questactskilldata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questactskilldata`;
CREATE TABLE `wz_questactskilldata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `skillid` int(11) NOT NULL DEFAULT '0',
  `skillLevel` int(11) NOT NULL DEFAULT '-1',
  `masterLevel` int(11) NOT NULL DEFAULT '-1',
  `uniqueid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=537 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Table structure for wz_questdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questdata`;
CREATE TABLE `wz_questdata` (
  `questid` int(11) NOT NULL,
  `name` varchar(1024) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `autoStart` tinyint(1) NOT NULL DEFAULT '0',
  `autoPreComplete` tinyint(1) NOT NULL DEFAULT '0',
  `viewMedalItem` int(11) NOT NULL DEFAULT '0',
  `selectedSkillID` int(11) NOT NULL DEFAULT '0',
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  `autoAccept` tinyint(1) NOT NULL DEFAULT '0',
  `autoComplete` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`questid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_questpartydata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questpartydata`;
CREATE TABLE `wz_questpartydata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questid` int(11) NOT NULL DEFAULT '0',
  `rank` varchar(1) NOT NULL DEFAULT '',
  `mode` varchar(13) NOT NULL DEFAULT '',
  `property` varchar(255) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `quests_ibfk_7` (`questid`)
) ENGINE=MyISAM AUTO_INCREMENT=161 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for wz_questreqdata
-- ----------------------------
DROP TABLE IF EXISTS `wz_questreqdata`;
CREATE TABLE `wz_questreqdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questid` int(11) NOT NULL DEFAULT '0',
  `name` varchar(127) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `stringStore` varchar(1024) NOT NULL DEFAULT '',
  `intStoresFirst` varchar(1024) NOT NULL DEFAULT '',
  `intStoresSecond` varchar(1024) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `quests_ibfk_1` (`questid`)
) ENGINE=MyISAM AUTO_INCREMENT=132353 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- View structure for readable_cheatlog
-- ----------------------------
DROP VIEW IF EXISTS `readable_cheatlog`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `readable_cheatlog` AS select `a`.`name` AS `accountname`,`a`.`id` AS `accountid`,`c`.`name` AS `name`,`c`.`id` AS `characterid`,`cl`.`offense` AS `offense`,`cl`.`count` AS `count`,`cl`.`lastoffensetime` AS `lastoffensetime`,`cl`.`param` AS `param` from ((`cheatlog` `cl` join `characters` `c`) join `accounts` `a`) where ((`cl`.`id` = `c`.`id`) and (`a`.`id` = `c`.`accountid`) and (`a`.`banned` = 0));

-- ----------------------------
-- View structure for readable_last_hour_cheatlog
-- ----------------------------
DROP VIEW IF EXISTS `readable_last_hour_cheatlog`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `readable_last_hour_cheatlog` AS select `a`.`name` AS `accountname`,`a`.`id` AS `accountid`,`c`.`name` AS `name`,`c`.`id` AS `characterid`,sum(`cl`.`count`) AS `numrepos` from ((`cheatlog` `cl` join `characters` `c`) join `accounts` `a`) where ((`cl`.`id` = `c`.`id`) and (`a`.`id` = `c`.`accountid`) and (timestampdiff(HOUR,`cl`.`lastoffensetime`,now()) < 1) and (`a`.`banned` = 0)) group by `cl`.`id` order by sum(`cl`.`count`) desc;

-- ----------------------------
-- Procedure structure for doWipe
-- ----------------------------
DROP PROCEDURE IF EXISTS `doWipe`;
DELIMITER ;;
CREATE DEFINER=`Emy77182x3`@`%` PROCEDURE `doWipe`(iid INT, lower INT, upper INT, leave_amount INT)
BEGIN

  DECLARE done INT DEFAULT 0;

  DECLARE CharID INT;

  DECLARE NumWipe INT;

  DECLARE curs1 CURSOR FOR

    SELECT characterid, c FROM (

      SELECT characterid, COUNT(*) c

      FROM inventoryitems

      WHERE itemid = iid

      GROUP BY characterid

      ORDER BY c DESC

    ) t WHERE c >= lower && c <= upper;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;



  OPEN curs1;



  character_loop: LOOP

    IF done THEN

      LEAVE character_loop;

    END IF;



    Fetch curs1 INTO CharID, NumWipe;

    IF leave_amount < NumWipe THEN

      PREPARE STMT FROM

        "DELETE FROM `inventoryitems` WHERE characterid = ? && itemid = ? LIMIT ?";

      SET @CharID = CharID;

      SET @iid = iid;

      SET @NumWipe = NumWipe - leave_amount;

      EXECUTE STMT USING @CharID, @iid, @NumWipe;

    END IF;

  END LOOP;



  CLOSE curs1;

END;;
DELIMITER ;
