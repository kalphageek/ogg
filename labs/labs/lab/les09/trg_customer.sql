------------------------------------------------------------------------
-- DISCLAIMER:
--    This script is provided for educational purposes only. It is NOT
--	supported by Oracle World Wide Technical Support.
--    The script has been tested and appears to work as intended.
--	You should always run new scripts on a test instance initially.
--
------------------------------------------------------------------------
CREATE TABLE CUSTMER
(
  CUST_ID        NUMBER(12)                     NOT NULL,
  NAME           VARCHAR2(50 BYTE)              NOT NULL,
  MIDDLE_NAME    VARCHAR2(50 BYTE),
  SURNAME        VARCHAR2(50 BYTE)              NOT NULL,
  FULL_NAME      VARCHAR2(255 BYTE)             NOT NULL,
  DATE_OF_BIRTH  DATE                           NOT NULL,
  NATIONALITY    VARCHAR2(50 BYTE)              NOT NULL,
  EMAIL          VARCHAR2(255 BYTE)
)
TABLESPACE OGG_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX CUST_PK ON CUSTMER
(CUST_ID)
LOGGING
TABLESPACE OGG_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE CUSTMER ADD (
  CONSTRAINT CUST_PK
  PRIMARY KEY
  (CUST_ID)
  USING INDEX CUST_PK);
