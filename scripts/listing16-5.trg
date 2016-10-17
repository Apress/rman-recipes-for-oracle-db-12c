create or replace trigger trace_rcat
after logon on database
declare
  trace_string varchar2(100);
begin
if user='RCAT' then
  dbms_monitor.session_trace_enable(null, null, true, true);  
  SELECT 'RMAN SQL TRACE FILE' INTO trace_string FROM dual;
end if;
end;
/
