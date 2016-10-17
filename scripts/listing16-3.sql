SET PAGESIZE 50
COL time_taken_display FORM A10 HEAD "Time|Taken|HH:MM:SS"
COL rman_end_time      FORM A17
COL i_size_gig         FORM 999.99 HEAD "Input|Gig"
COL o_size_gig         FORM 999.99 HEAD "Output|Gig"
COL compression_ratio  FORM 99.99 HEAD "Comp.|Ratio"
COL status             FORM A12
COL input_type         FORM A14
--
SELECT
 time_taken_display
,TO_CHAR(end_time,'dd-mon-rrrr hh24:mi') AS rman_end_time
,input_bytes/1024/1024/1024 i_size_gig
,output_bytes/1024/1024/1024 o_size_gig
,compression_ratio
,status
,input_type
FROM v$rman_backup_job_details
ORDER BY end_time; 
--
SELECT
 ROUND((end_time - start_time)*24*60,2) AS minutes
,end_time
,RANK() OVER (ORDER BY end_time - start_time DESC) rank_row
,ROUND(
   AVG((end_time - start_time)*24*60) OVER ()
    ,2) average_all
,ROUND(
   AVG((end_time - start_time)*24*60)
     OVER (ORDER BY rownum
           ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING)
 ,2) average_prev_3
FROM v$rman_backup_job_details
ORDER BY end_time;
