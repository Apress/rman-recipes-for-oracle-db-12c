SELECT
 sequence#
,first_change#
,first_time
FROM v$log_history
ORDER BY first_time;
--
SELECT
 sequence#
,first_change#
,first_time
FROM v$archived_log
ORDER BY first_time;
