------------------------------------------------------------------------
-- DISCLAIMER:
--    This script is provided for educational purposes only. It is NOT
--	supported by Oracle World Wide Technical Support.
--    The script has been tested and appears to work as intended.
--	You should always run new scripts on a test instance initially.
--
------------------------------------------------------------------------
create table country
(
  country_id        integer      not null,
  country_name      varchar2(128) not null,
  continent         varchar2(20)
) 
tablespace ogg_data
pctused    0
pctfree    10
initrans   1
maxtrans   255
storage    (
            initial          256k
            next             256k
            minextents       1
            maxextents       unlimited
            pctincrease      0
            buffer_pool      default
           )
logging 
nocompress 
nocache
noparallel
monitoring;

ALTER TABLE country ADD 
  CONSTRAINT country_pk
  PRIMARY KEY
  (country_id) INITIALLY DEFERRED DEFERRABLE;
