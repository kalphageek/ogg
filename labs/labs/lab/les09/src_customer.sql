------------------------------------------------------------------------
-- DISCLAIMER:
--    This script is provided for educational purposes only. It is NOT
--	supported by Oracle World Wide Technical Support.
--    The script has been tested and appears to work as intended.
--	You should always run new scripts on a test instance initially.
--
------------------------------------------------------------------------

CREATE TABLE CUSTOMER
(
  C_CUST_ID      NUMBER(12)                     NOT NULL,
  C_NAME         VARCHAR2(50 BYTE)              NOT NULL,
  C_MIDDLE_NAME  VARCHAR2(50 BYTE),
  C_FAMILY_NAME  VARCHAR2(50 BYTE)              NOT NULL,
  C_FULL_NAME    VARCHAR2(255 BYTE)             NOT NULL,
  C_DOB          DATE                           NOT NULL,
  C_NATIONALITY  VARCHAR2(50 BYTE)              NOT NULL,
  C_EMAIL        VARCHAR2(255 BYTE)
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

CREATE UNIQUE INDEX CUST_PK ON CUSTOMER
(C_CUST_ID)
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


ALTER TABLE CUSTOMER ADD (
  CONSTRAINT CUST_PK
  PRIMARY KEY
  (C_CUST_ID)
  USING INDEX CUST_PK);
