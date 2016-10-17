select
 acc_status,
 versions_starttime,
 versions_startscn,
 versions_endtime,
 versions_endscn,
 versions_xid,
 versions_operation
 from accounts
 versions between scn minvalue and maxvalue
 where accno = 3760
 order by 3
 /