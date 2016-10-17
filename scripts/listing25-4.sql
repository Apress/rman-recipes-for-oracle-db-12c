select set_count, sid, type, substr(filename,1,30) filename,
       buffer_size, buffer_count bc, elapsed_time et, bytes
from v$backup_async_io a
where set_stamp = 793415558;