spool postcmd;
set echo on;
-- Look for STATISTICS SECTION below for relevant statistics that will help
-- analyse RMAN backup performance problems
set line 2000
alter session set nls_date_format = 'DD-MON-YYYY HH:MI:SS';
drop table cmd_end_time;
create table cmd_end_time as select sysdate end_time from dual;
drop table post_cmd_wait_time;
drop table backup_async_io;
drop table backup_sync_io;
create table backup_async_io
as (select * from v$backup_async_io
where (sid, serial) not in (select sid, serial from pre_backup_async_io));
--
create table backup_sync_io
as (select * from v$backup_sync_io
where (sid, serial) not in (select sid, serial from pre_backup_sync_io));
--
create table post_cmd_wait_time
as select sum (time_waited_micro/1000000) time_waited_secs from v$system_event
where event like '%sbt%';
--
variable sbttime_in_secs number;
begin
  select post.time_waited_secs  - nvl(pre.time_waited_secs, 0)
  into :sbttime_in_secs from pre_cmd_wait_time pre, post_cmd_wait_time post;
end;
/
variable cmdtime_in_secs number;
begin
  select (end_time - start_time)*24*60*60 into :cmdtime_in_secs
  from cmd_start_time, cmd_end_time;
end;
/
variable total_input_bytes number;
begin
  select sum(bytes) into :total_input_bytes
  from (select sum(bytes) bytes
        from backup_async_io where type='INPUT'
        union
        select sum(bytes) bytes
        from backup_sync_io where type='INPUT');
end;
/
variable total_output_bytes number;
begin
  select sum(bytes)
  into :total_output_bytes
  from (select sum(bytes) bytes
        from backup_async_io where type='OUTPUT'
        union
        select sum(bytes) bytes
        from backup_sync_io where type='OUTPUT');
end;
/
variable non_sbttime_in_secs number;
begin
  :non_sbttime_in_secs := :cmdtime_in_secs - :sbttime_in_secs;
end;
/
-- STATISTICS SECTION
-- Relevant statistics that are useful to identify
-- RMAN performance problems are displayed below.
-- SBTTIME_IN_SECS is amount of time that was spent in SBT library
print sbttime_in_secs;
--  CMDTIME_IN_SECS is total command execution time
print cmdtime_in_secs;
-- NON_SBTTIME_IN_SECS is time spent in non-SBT code
print non_sbttime_in_secs;
-- TOTAL INPUT BYTES read
print total_input_bytes;
-- TOTAL OUTPUT BYTES written
print total_output_bytes;
-- Effective output bytes per second
select :total_output_bytes/:cmdtime_in_secs effective_output_bytes_per_sec
  from dual;
-- Effective input bytes per second
select :total_input_bytes/:cmdtime_in_secs effective_input_bytes_per_sec
  from dual;
-- Input file that is bottleneck for the backup operation
select long_waits, io_count, filename input_bottleneck_filename
from backup_async_io
where type='INPUT'
and long_waits/io_count = (select max(long_waits/io_count)
                           from backup_async_io where type='INPUT' );
-- Critical I/O event information
select
  pre.event, (post.total_waits-pre.total_waits) total_waits,
 (post.total_timeouts-pre.total_timeouts) total_timeouts,
 (post.time_waited-pre.time_waited) time_waited,
 (post.time_waited_micro - pre.time_waited_micro) time_waited_micro,
 (post.time_waited_micro-pre.time_waited_micro)/
   (post.total_waits-pre.total_waits) average_wait_micro
from pre_cmd_ksfq_events pre, v$system_event post
where pre.event=post.event;
-- IO_SLAVES parameter settings for the instance
show parameter io_slaves;
set line 2000
-- Contents of V$BACKUP_ASYNC_IO generated for the RMAN command executed
select * from backup_async_io;
-- Contents of V$BACKUP_SYNC_IO generated for the RMAN command executed
select * from backup_sync_io;
-- Pre and Post command statistics for important KSFQ events
select * from v$system_event where event in ('i/o slave wait', 'io done');
exit;
