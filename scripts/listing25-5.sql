col blocks_skipped_in_cell head 'Cell Skip'
col cell_rman_eff head 'RMAN Eff%' format 999.99
select file#, blocks, blocks_read, datafile_blocks, blocks_skipped_in_cell, 100* blocks_skipped_in_cell/blocks_read cell_rman_eff
from v$backup_datafile
/
select completion_time, blocks, blocks_read, datafile_blocks 
used_change_tracking
from v$backup_datafile
where file# = 5;
