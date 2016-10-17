col type format a5
col original_name format a15
col object_name format a15
select original_name, object_name, type, can_undrop
from user_recyclebin;