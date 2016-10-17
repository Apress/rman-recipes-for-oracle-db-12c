SET SERVEROUTPUT ON
DECLARE
  finished     BOOLEAN;
  v_dev_name   VARCHAR2(10);
  TYPE v_filestable IS TABLE OF varchar2(500) INDEX BY BINARY_INTEGER;
BEGIN
  -- Allocate channel, when disk then type = null, if tape then type = sbt_tape.
  v_dev_name := dbms_backup_restore.deviceAllocate(type=>null, ident=> 'd1');
  -- Set beginning of restore operation (does not restore anything yet).
  dbms_backup_restore.restoreSetDatafile;
  -- Define datafiles and locations for this backup piece.
  dbms_backup_restore.restoreDatafileTo(dfnumber=>1,
    toname=>'/u01/dbfile/o12c/system01.dbf');
  dbms_backup_restore.restoreDatafileTo(dfnumber=>4,
    toname=>'/u01/dbfile/o12c/users01.dbf');
  dbms_backup_restore.restoreDatafileTo(dfnumber=>5,
    toname=>'/u01/dbfile/o12c/tools01.dbf');
  -- Restore the datafiles in this backup piece.
  dbms_backup_restore.restoreBackupPiece(done => finished,
  handle=>'/u01/app/oracle/product/12.1.0.1/db_1/dbs/38nhakpe_1_1',
           params=>null);
  IF finished THEN
    dbms_output.put_line('Datafiles restored');
  ELSE
    dbms_output.put_line('Problem');
  END IF;
  --
  dbms_backup_restore.deviceDeallocate('d1');
END;
/
