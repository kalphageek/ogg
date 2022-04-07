DROP SEQUENCE "WEST"."TRANS_SEQ" ;
CREATE SEQUENCE  "WEST"."TRANS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 200 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
set define off;

CREATE OR REPLACE PROCEDURE "WEST"."DB_ACTIVITY" 
IS
  v_LowBal      NUMBER(3,2) DEFAULT 1.00;
  v_HiBal       NUMBER(7,2) DEFAULT 10000.00;
  v_RetBal      NUMBER(7,2);
  v_acct_num    NUMBER;
  v_max_acct    NUMBER;
  v_Zip         NUMBER(5,0);
  v_tell_num    NUMBER;
  v_max_teller  NUMBER;
  v_Counter     NUMBER;
  v_CounterT    NUMBER;
  v_max_branch  NUMBER;
  v_branch_zip  VARCHAR(30);
  v_branch_num  NUMBER;
  v_trans_num   NUMBER;
  v_loop_cnt    NUMBER;

BEGIN
FOR v_loop_cnt IN 1 .. 10 LOOP
  FOR v_Counter IN 1 .. 5000 LOOP
   SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;

   IF v_RetBal < 0 THEN
     v_RetBal := v_RetBal * -1;
   END IF;
   SELECT max(account_number) + 1 into v_acct_num from account;
   INSERT INTO ACCOUNT values (v_acct_num, v_RetBal);
   COMMIT;

   SELECT max(account_number) into v_max_acct from account;
   FOR v_counterT IN 1 .. 100 LOOP
    SELECT dbms_random.value(1,v_max_acct) into v_acct_num from dual;
    SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
    IF v_RetBal < 0 THEN
      v_RetBal := v_RetBal * -1;
    END IF;
    UPDATE account set account_balance = v_RetBal where account_number = v_acct_num;
    COMMIT;

   END LOOP;
   dbms_lock.sleep(1);
   select  max(teller_number) into v_max_teller from teller;
   SELECT dbms_random.value(1,v_max_teller) into v_tell_num from dual;
   SELECT max(branch_number) into v_max_branch from branch;
   SELECT dbms_random.value(1,v_max_branch) into v_branch_num from dual;
   SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
   IF v_RetBal < 0 THEN
     v_RetBal := v_RetBal * -1;
   END IF;
   SELECT max(account_number) into v_max_acct from account;
   SELECT dbms_random.value(1,v_max_acct) into v_acct_num from dual;
   select TRANS_SEQ.nextval into v_trans_num from dual;
   insert into  ACCOUNT_TRANS
      (
        ACCOUNT_TRANS_TS ,
        ACCOUNT_TRANS_AMT ,
        ACCOUNT_TRANS_TYPE ,
        TRANS_NUMBER ,
        ACCOUNT_NUMBER ,
        ACCOUNT_TRANS_LOC
      )
      VALUES
      (systimestamp,v_RetBal,'C',v_trans_num,v_acct_num,to_char(v_branch_num,'99999'));
      commit;
   insert into TELLER_TRANS
      (
        TELLER_TRANS_TS ,
        TELLER_TRANS_AMT ,
        TRANS_NUMBER ,
        TELLER_TRANS_TYPE ,
        TELLER_NUMBER ,
        ACCOUNT_NUMBER
      )
      VALUES
      (systimestamp,v_RetBal,v_trans_num,'T',v_tell_num,v_acct_num);
      commit;
  END LOOP;
  dbms_lock.sleep(1);
  select max(trans_number) into v_trans_num from account_trans;
  SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
  IF v_RetBal < 0 THEN
    v_RetBal := v_RetBal * -1;
  END IF;
  update account_trans set account_trans_amt = v_RetBal where trans_number = v_trans_num;
  commit;
  select max(trans_number) into v_trans_num from teller_trans;
  SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
  IF v_RetBal < 0 THEN
    v_RetBal := v_RetBal * -1;
  END IF;
  update teller_trans set teller_trans_amt = v_RetBal where trans_number = v_trans_num;
  commit;

  SELECT dbms_random.value(1.00, 10000.00) INTO v_RetBal FROM dual;
  IF v_RetBal < 0 THEN
    v_RetBal := v_RetBal * -1;
  END IF;
  SELECT max(account_number) + 1 into v_acct_num from account;
  INSERT INTO ACCOUNT values (v_acct_num, v_RetBal);
  commit;
  delete from ACCOUNT where account_number = v_acct_num;
  commit;
  dbms_lock.sleep(2);
END LOOP;
END;

/

