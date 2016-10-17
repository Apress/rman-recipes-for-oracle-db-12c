SELECT
 a.username
,a.sid
,a.serial#
,b.spid AS OS_ID
,a.client_info
FROM v$session a
    ,v$process b
WHERE a.program like '%rman%'
AND  a.paddr = b.addr;
--
SELECT sid, serial#, sofar, totalwork, opname,
round(sofar/totalwork*100,2) AS pct_complete
FROM   v$session_longops
WHERE  opname LIKE 'RMAN%'
AND    opname NOT LIKE '%aggregate%'
AND    totalwork != 0
AND    sofar <> totalwork;
