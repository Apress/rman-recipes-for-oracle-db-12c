create directory rman as '+DG1/RMAN';
create directory rmanbackup as '+DG1/RMANBACKUP';
begin
   dbms_file_transfer.copy_file (
           SOURCE_DIRECTORY_OBJECT         => 'RMAN',
           SOURCE_FILE_NAME                => '0oniv1g8_1_1.rmb',
           DESTINATION_DIRECTORY_OBJECT    => 'RMANBACKUP',
           DESTINATION_FILE_NAME           => '0oniv1g8_1_1.new.rmb'
   );
end;