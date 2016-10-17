# Beginning of Script
# Start of Configurable Section
export ORACLE_HOME=/opt/oracle/10.2/db_1
export ORACLE_SID=PRODB1
export TOOLHOME=/opt/oracle/tools
export BACKUP_MEDIA=DISK
export BACKUP_TYPE=FULL_DB_BKUP
export MAXPIECESIZE=16G
# End of Configurable Section
# Start of site specific parameters
export BACKUP_MOUNTPOINT=/oraback
export DBAEMAIL="dbas@proligence.com"
export DBAPAGER="dba.ops@proligence.com"
export LOG_SERVER=prolin2
export LOG_USER=oracle
export LOG_DIR=/dbalogs
export CATALOG_CONN=${ORACLE_SID}/${ORACLE_SID}@catalog
# End of site specific parameters
export LOC_PREFIX=$BACKUP_MOUNTPOINT/loc
export TMPDIR=/tmp
export NLS_DATE_FORMAT="MM/DD/YY HH24:MI:SS"
export TIMESTAMP=`date +%T-%m-%d-%Y`
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib:/lib
export LIBPATH=$ORACLE_HOME/lib:/usr/lib:/lib
export SHLIB_PATH=$ORACLE_HOME/lib:/usr/lib:/lib
export LOG=${TOOLHOME}/log
LOG=${LOG}/log/${ORACLE_SID}_${BACKUP_TYPE}_${BACKUP_MEDIA}_${TIMESTAMP}.log
export TMPLOG=$TOOLHOME/log/tmplog.$$
echo `date` "Starting $BACKUP_TYPE Backup of $ORACLE_SID \
 to $BACKUP_MEDIA" > $LOG
export LOCKFILE=$TOOLHOME/${ORACLE_SID}_${BACKUP_TYPE}_${BACKUP_MEDIA}.lock
if [ -f $LOCKFILE ]; then
 echo `date` "Script running. Exiting ..." >> $LOG
 else
 echo "Do NOT delete this file. Used for RMAN locking" > $LOCKFILE
 $ORACLE_HOME/bin/rman log=$TMPLOG <<EOF
 connect target /
 connect catalog $CATALOG_CONN
 CONFIGURE SNAPSHOT CONTROLFILE NAME TO '${ORACLE_HOME}/dbs/SNAPSHOT_${ORACLE_SID}_${TIMESTAMP}_CTL';
 run
 {
  allocate channel c1 type disk
   format '${LOC_PREFIX}1/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c2 type disk
   format '${LOC_PREFIX}2/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c3 type disk
   format '${LOC_PREFIX}3/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c4 type disk
   format '${LOC_PREFIX}4/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c5 type disk
   format '${LOC_PREFIX}5/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c6 type disk
   format '${LOC_PREFIX}6/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c7 type disk
   format '${LOC_PREFIX}7/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  allocate channel c8 type disk
   format '${LOC_PREFIX}8/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman'
   maxpiecesize ${MAXPIECESIZE};
  backup
   incremental level 0
   tag = 'LVL0_DB_BKP'
   database
   include current controlfile;
  release channel c1;
  release channel c2;
  release channel c3;
  release channel c4;
  release channel c5;
  release channel c6;
  release channel c7;
  release channel c8;
  allocate channel d2 type disk format '${LOC_PREFIX}8/CTLBKP_${ORACLE_SID}_${TIMESTAMP}.CTL';
  backup current controlfile;
  release channel d2;
 }
 exit
EOF
 RC=$?
 cat $TMPLOG >> $LOG
 rm $LOCKFILE
 echo `date` "Script lock file removed" >> $LOG
 if [ $RC -ne "0" ]; then
  mailx -s "RMAN $BACKUP_TYPE $ORACLE_SID $BACKUP_MEDIA Failed" \
   $DBAEMAIL,$DBAPAGER < $LOG
 else
  cp $LOG ${LOC_PREFIX}1
  mailx -s "RMAN $BACKUP_TYPE $ORACLE_SID $BACKUP_MEDIA Successful" \
   $DBAEMAIL < $LOG
 fi
 scp $LOG ${LOG_USER}@${LOG_SERVER}:${LOG_DIR}/${ORACLE_SID}/.
 rm $TMPLOG
fi
