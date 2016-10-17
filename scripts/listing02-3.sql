SELECT
 dest_name
,destination
FROM v$archive_dest
WHERE destination is not null;
