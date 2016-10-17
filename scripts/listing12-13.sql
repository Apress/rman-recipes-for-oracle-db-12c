SELECT
 file#
,fuzzy
,status
,checkpoint_change#
,to_char(checkpoint_time,'dd-mon-rrrr hh24:mi:ss')
,error
FROM v$datafile_header;
