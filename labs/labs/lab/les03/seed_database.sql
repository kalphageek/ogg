/*
--------------------------------------------------------------------------
-- DISCLAIMER:                                                          --
--    This script is provided for educational purposes only. It is NOT  --
--    supported by Oracle World Wide Technical Support.                 --
--    The script has been tested and appears to work as intended.       --
--    You should always run new scripts on a test instance initially.   --
--    Copyright (c) Oracle Corp. 2013. All Rights Reserved.             --
--------------------------------------------------------------------------

   Seed the branch and teller lookup tables with these values:
       Number of accounts: 1000
       Starting account balance: Random up to $10000
       Number of branches: 40
       Tellers per branch: 20
*/

TRUNCATE TABLE ACCOUNT;
TRUNCATE TABLE ACCOUNT_TRANS;
TRUNCATE TABLE BRANCH;
TRUNCATE TABLE TELLER;
TRUNCATE TABLE TELLER_TRANS;
TRUNCATE TABLE BRANCH_ATM;
COMMIT;

DECLARE
  v_LowBal      NUMBER(3,2) DEFAULT 1.00;
  v_HiBal       NUMBER(7,2) DEFAULT 10000.00;
  v_RetBal      NUMBER(7,2);
  v_Zip         NUMBER(5,0);
  v_LastTell    NUMBER(10,0) DEFAULT 1;   
  v_Counter     NUMBER;
  v_CounterT    NUMBER;

BEGIN

  FOR v_Counter IN 1 .. 1000 LOOP
   SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
   
   IF v_RetBal < 0 THEN
     v_RetBal := v_RetBal * -1;
   END IF;
      
   INSERT INTO ACCOUNT values (v_Counter, v_RetBal);
   COMMIT;
  END LOOP;
   
  FOR v_Counter IN 1 .. 40 LOOP
    SELECT dbms_random.value(80000, 89999) INTO v_Zip FROM dual;
    INSERT INTO BRANCH values (v_Counter, v_Zip);
    COMMIT;
    FOR v_CounterT IN 1 .. 20 LOOP
      INSERT INTO TELLER values (v_LastTell, v_Counter);
      COMMIT;
      v_LastTell := v_LastTell + 1;
    END LOOP;
  END LOOP;  
END;
/
EXIT;
  
