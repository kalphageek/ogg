/*
--------------------------------------------------------------------------
-- DISCLAIMER:                                                          --
--    This script is provided for educational purposes only. It is NOT  --
--    supported by Oracle World Wide Technical Support.                 --
--    The script has been tested and appears to work as intended.       --
--    You should always run new scripts on a test instance initially.   --
--    Copyright (c) Oracle Corp. 2013. All Rights Reserved.             --
--------------------------------------------------------------------------

  Script to create the target database tables
  This will simulate a banking database used with an OLTP application
  
*/

DROP TABLE account;
CREATE TABLE account (
  account_number    	NUMBER(10,0),
  account_balance	DECIMAL(38,2),
  primary key (account_number)
  USING INDEX
);

DROP TABLE account_trans;
CREATE TABLE account_trans (
  account_number	NUMBER(10,0),
  trans_number		NUMBER(18,0),
  account_trans_ts	TIMESTAMP(6),
  account_trans_type	VARCHAR2(3),
  account_trans_loc	VARCHAR2(50),
  account_trans_amt	DECIMAL(18,2),
  primary key (account_number, trans_number, account_trans_ts)
  USING INDEX
);
  
DROP TABLE branch;
CREATE TABLE branch (
  branch_number   	NUMBER(10,0),
  branch_zip      	NUMBER(5),
  primary key ( branch_number )
  USING INDEX
);  

DROP TABLE teller;   
CREATE TABLE teller (
  teller_number		NUMBER(10,0),
  teller_branch		NUMBER(10,0),
  primary key (teller_number)
  USING INDEX
);

DROP TABLE teller_trans;
CREATE TABLE teller_trans (
  teller_number		NUMBER(10,0),
  trans_number		NUMBER(18,0),
  account_number	NUMBER(10,0),
  teller_trans_ts	TIMESTAMP(6),
  teller_trans_type	CHAR(2),
  teller_trans_amt	DECIMAL(18,2),
  primary key (teller_number, trans_number, teller_trans_ts)
  USING INDEX
);

DROP TABLE branch_atm;
CREATE TABLE branch_atm (
  branch_number		DECIMAL(10,0),
  atm_number		SMALLINT,
  trans_number		NUMBER(18,0),
  account_number	NUMBER(10,0),
  atm_trans_ts		TIMESTAMP(6),
  atm_trans_type	CHAR(2),
  atm_trans_amt		DECIMAL(18,2),
  primary key (branch_number, atm_number, trans_number, atm_trans_ts)
  USING INDEX
);

EXIT;
