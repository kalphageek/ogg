------------------------------------------------------------------------
-- DISCLAIMER:
--    This script is provided for educational purposes only. It is NOT
--	supported by Oracle World Wide Technical Support.
--    The script has been tested and appears to work as intended.
--	You should always run new scripts on a test instance initially.
--
------------------------------------------------------------------------
create or replace PROCEDURE constraints_disable IS
begin
for cur in (select owner,constraint_name, table_name from user_constraints where constraint_type = 'P' and table_name = 'COUNTRY') loop
        execute immediate 'ALTER TABLE '||cur.owner||'.'||cur.table_name||' MODIFY CONSTRAINT '||cur.constraint_name||' DISABLE';
end loop;
end;
/
