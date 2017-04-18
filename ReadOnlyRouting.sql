-------------------------------------------------------------------------------
-- Configure read-only routing

USE [master]

ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls01' WITH 
(PRIMARY_ROLE (ALLOW_CONNECTIONS = READ_WRITE));
ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls01' WITH 
(SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL));
ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls01' WITH 
(SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://dlbsqls01.yosemite.local:1433'));

ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls02' WITH 
(PRIMARY_ROLE (ALLOW_CONNECTIONS = READ_WRITE));
ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls02' WITH 
(SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL));
ALTER AVAILABILITY GROUP [dlbsql-s01]
 MODIFY REPLICA ON
N'dlbsqls02' WITH 
(SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://dlbsqls02.yosemite.local:1433'));

ALTER AVAILABILITY GROUP [dlbsql-s01] 
MODIFY REPLICA ON
N'dlbsqls01' WITH 
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('dlbsqls02','dlbsqls01')));

ALTER AVAILABILITY GROUP [dlbsql-s01] 
MODIFY REPLICA ON
N'dlbsqls02' WITH 
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('dlbsqls01','dlbsqls02')));
GO