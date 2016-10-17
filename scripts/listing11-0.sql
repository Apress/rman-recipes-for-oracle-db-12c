SELECT 
  a.thread#, b.open_mode, a.status,
  CASE
  WHEN ((b.open_mode='MOUNTED') AND (a.status='OPEN')) THEN
   'Crash Recovery req.'
  WHEN ((b.open_mode='MOUNTED') AND (a.status='CLOSED')) THEN
    'No Crash Rec. req.'
  WHEN ((b.open_mode='READ WRITE') AND (a.status='OPEN')) THEN
    'Inst. already open'
  WHEN ((b.open_mode='READ ONLY') AND (a.status='CLOSED')) THEN
    'Inst. open read only'
  ELSE 'huh?'
  END STATUS
FROM v$thread    a
    ,gv$database b
WHERE a.thread# = b.inst_id;
