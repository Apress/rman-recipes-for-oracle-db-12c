DECLARE
  finished BOOLEAN;
  v_dev_name VARCHAR2(75);
BEGIN
  -- Allocate a channel, when disk then type = null
  -- If tape then type = sbt_tape.
  v_dev_name := dbms_backup_restore.deviceAllocate(type=>null, ident=>'d1');
  --
  dbms_backup_restore.restoreSetDatafile;
  -- Destination and name for restored control file.
  dbms_backup_restore.restoreControlFileTo(cfname=>'/tmp/control01.ctl');
   --
   -- Backup piece location and name.
  dbms_backup_restore.restoreBackupPiece(
    '/u01/rman/c-3412777350-20120722-00', finished);
  --
  if finished then
    dbms_output.put_line('Control file restored.');
  else
    dbms_output.put_line('Problem');
  end if;
  --
  dbms_backup_restore.deviceDeallocate('d1');
END;
/
