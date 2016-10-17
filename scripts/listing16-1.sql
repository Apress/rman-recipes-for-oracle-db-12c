COL username    FORM a10
COL kill_string FORM A12
COL os_id       FORM A6
COL client_info FORM A24
COL action      FORM A21
--
SELECT
 a.username
,a.sid || ',' || a.serial# AS kill_string
, b.spid AS OS_ID
,(CASE WHEN a.client_info IS NULL AND a.action IS NOT NULL THEN 'First Default'
       WHEN a.client_info IS NULL AND a.action IS NULL     THEN 'Polling'
  ELSE a.client_info
  END) client_info
,a.action
FROM v$session a
    ,v$process b
WHERE a.program like '%rman%'
AND  a.paddr = b.addr;
