spool precmd;
set line 2000
set echo on;
alter session set nls_date_format = 'DD-MON-YYYY HH:MI:SS';
drop table pre_cmd_wait_time;
drop table cmd_start_time;
drop table pre_backup_sync_io;
drop table pre_backup_async_io;
drop table pre_cmd_ksfq_events;
create table pre_cmd_wait_time
as select sum (time_waited_micro/1000000) time_waited_secs
from v$system_event where event like '%sbt%';
create table pre_backup_async_io
as select * from v$backup_async_io;
create table pre_backup_sync_io
as select * from v$backup_sync_io;
create table cmd_start_time
as select sysdate start_time from dual;
create table pre_cmd_ksfq_events
as select * from v$system_event
where event in ('i/o slave wait', 'io done');
exit;
