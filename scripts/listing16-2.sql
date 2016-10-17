COL sid FORM 99999
COL serial# FORM 99999
COL opname FORM A35
COL sofar FORM 999999999
COL pct_complete FORM 99.99 HEAD "% Comp."
--
SELECT sid, serial#, sofar, totalwork, opname,
round(sofar/totalwork*100,2) AS pct_complete
FROM   v$session_longops
WHERE  opname LIKE 'RMAN%'
AND    opname NOT LIKE '%aggregate%'
AND    totalwork != 0
AND    sofar <> totalwork;
--
SELECT s.client_info,
       sl.opname,
       sl.message,
       sl.sid, sl.serial#, p.spid,
       sl.sofar, sl.totalwork,
       round(sl.sofar/sl.totalwork*100,2) "% Complete"
FROM   v$session_longops sl, v$session s, v$process p
WHERE  p.addr = s.paddr
AND    sl.sid=s.sid
AND    sl.serial#=s.serial#
AND    opname LIKE 'RMAN%'
AND    opname NOT LIKE '%aggregate%'
AND    totalwork != 0
AND    sofar <> totalwork;
--
select sid, serial#, sofar, totalwork,opname,
round(sofar/totalwork*100,2) "% Complete"
from   v$session_longops
where  opname LIKE 'RMAN%aggregate%'
and    totalwork != 0
and    sofar <> totalwork;
--
SET LINES 200
COL opname FORM A35
COL pct_complete FORM 99.99 HEAD "% Comp."
COL start_time FORM A15 HEAD "Start|Time"
COL hours_running FORM 9999.99 HEAD "Hours|Running"
COL minutes_left FORM 999999 HEAD "Minutes|Left"
COL est_comp_time FORM A15 HEAD "Est. Comp.|Time"
--
SELECT sid, serial#, opname,
ROUND(sofar/totalwork*100,2) AS pct_complete,
TO_CHAR(start_time,'dd-mon-yy hh24:mi') start_time,
(sysdate-start_time)*24 hours_running,
((sysdate-start_time)*24*60)/(sofar/totalwork)-(sysdate-start_time)
  *24*60 minutes_left,
TO_CHAR((sysdate-start_time)/(sofar/totalwork)+start_time,'dd-mon-yy hh24:mi')
  est_comp_time
FROM  v$session_longops
WHERE opname LIKE 'RMAN%'
AND   opname NOT LIKE '%aggregate%'
AND   totalwork != 0
AND   sofar <> totalwork;
