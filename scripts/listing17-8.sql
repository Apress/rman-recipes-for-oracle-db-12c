select
 sid
,recid
,output
from v$rman_output
order by recid;
--
select
 a.sid
,a.recid
,b.operation
,b.status
,a.output
from v$rman_output a
    ,v$rman_status b
where a.rman_status_recid = b.recid
and   a.rman_status_stamp = b.stamp
order by a.recid;
--
select
 a.sid
,a.recid
,b.operation
,b.status
,a.output
from v$rman_output a
    ,v$rman_status b
where a.rman_status_recid = b.recid
and   a.rman_status_stamp = b.stamp
and   b.status = 'RUNNING'
order by a.recid;
