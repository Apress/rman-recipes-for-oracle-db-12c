SELECT sid, serial, filename, type, elapsed_time,
       effective_bytes_per_second
FROM v$backup_async_io
WHERE close_time > sysdate – 7;
--
SELECT filename, sid, serial, close_time, long_waits/io_count as ratio
FROM   v$backup_async_io
WHERE  type != 'AGGREGATE'
AND    SID = &SID
AND    SERIAL = &SERIAL
ORDER BY ratio desc;
