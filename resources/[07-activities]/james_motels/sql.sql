CREATE TABLE IF NOT EXISTS `world_motels` (
`userIdentifier` varchar(50) NOT NULL,
`motelData` longtext NOT NULL,
`motelCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

            
CREATE TABLE IF NOT EXISTS `world_storages` (
`storageId` varchar(255) NOT NULL,
`storageData` longtext NOT NULL,
PRIMARY KEY (`storageId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 


CREATE TABLE IF NOT EXISTS `world_furnishings` (
`motelId` bigint(20) NOT NULL DEFAULT '0',
`furnishingData` longtext,
`ownedFurnishingData` longtext,
PRIMARY KEY (`motelId`)
) ENGINE=InnoDB DEFAULT CHARSET=LATIN1;


CREATE TABLE IF NOT EXISTS `world_keys` (
`uuid` bigint(20) NOT NULL DEFAULT '0',
`owner` varchar(50) NOT NULL,
`keyData` longtext NOT NULL,
PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;