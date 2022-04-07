## GLOBALS
```sql
$ oggsrc
$ ggsci
-- $OGG_HOME/GLOBALS. 전체 공통 파라미터 설정
-- 개별 파라미터에서 GLOBALS의 파라미터에 대한 override 가능하다
> edit param ./GLOBALS
```

## Manager
```sql
> edit params mgr
-- Manager Port
Port 7809
DynamicPortList 8001, 8002, 9500–9520
-- 타겟에 전달이 완료된 Trail file은 삭제 and 5일 보관 유지
PurgeOldExtracts /ggs/dirdat/bb*, UseCheckpoints, & 
MinKeepDays 5
-- Manager가 시작될때 Extract/Replicat이 함께 시작된다
Autostart ER *
-- Extract가 비정상 종료하는 경우 2분 단위 5회 재실행
AutoRestart Extract *, WaitMinutes 2, Retries 5
-- 1시간 마다 Lag Report 생성 (Report 파일)
LagReportHours 1
-- 3분동안 Lag이 발생하면 Info로 알람. ggserr.log에 기복된다
LagInfoMinutes 3
-- 5분동안 Lag이 발생하면 Critical 알람. ggserr.log에 기복된다
LagCriticalMinutes 5
```

## Credential
1. 소스DB (Downstream DB)
```sql
> Create Wallet
> Add CredentialStore
-- 소스DB 접속
> Alter CredentialStore Add User c##OGG_Admin@amer Password oracle_4U Alias oggadmin_amer
-- 타겟DB 접속
> Alter CredentialStore Add User c##OGG_Admin@euro Password oracle_4U Alias oggadmin_euro
--- Container DB 접속
> Alter CredentialStore Add User c##OGG_Admin Password oracle_4U Alias oggadmin_root
> Info CredentialStore
> DBLogin UserIDAlias oggadmin_amer
> exit
-- Walet 과 Credential store를 타겟DB에 
$ cp -fr ./dirwlt ../oggtrg/
$ cp -fr ./dircrd ../oggtrg/
```

## Extract
```sql
> edit params extwest
Extract extwest
UserIdAlias oggadmin_root
-- max_sga_size 256MB
TranlogOptions IntegratedParams (max_sga_size 256)
-- Local Trail
ExtTrail ./dirdat/ew
-- Supplemental Log 걸린 모든 컬럼을 가져오겠다.
LOGALLSUPCOLS
-- Update시 old value / new value 를 1개의 Record로 생성한다. 사이즈 줄이는 목적. 
UPDATERECORDFORMAT COMPACT
-- 리포트를 자정 1분 부터 시작 한다
Report At 00:01
-- rpt파일을 매일 새로 만들어라
ReportRollover At 00:01
-- 1분 단위로 Rate을 만들어라
ReportCount Every 60 Seconds, Rate
-- Record 1000개 단위로 리포트 하라
ReportCount Every 1000 Records

Table AMER.WEST.ACCOUNT;
Table AMER.WEST.ACCOUNT_TRANS;
Table AMER.WEST.BRANCH;
Table AMER.WEST.BRANCH_ATM;
Table AMER.WEST.TELLER;
Table AMER.WEST.TELLER_TRANS;
:wq

> DBLogin UserIDAlias oggadmin_root
> Register Extract extwest database container (amer)
> DBLogin UserIDAlias oggadmin_amer
> add extract extwest, integrated tranlog, begin now
> add exttrail ./dirdat/ew, extract extwest, megabytes 10
> Start extwest
> Info extwest
```

## Pump
```sql
> edit params pwest
Extract pwest
UserIdAlias oggadmin_root
-- Transform 안하고 그대로 전달한다. Pump에서만 사용
-- Passthru
rmthost easthost, mgrport 7909
-- Remote Trail 위치
rmttrail ./dirdat/pe
Table AMER.WEST.*;
:wq

> Add Extract pwest, ExtTrailSource ./dirdat/ew
> Add RmtTrail ./dirdat/pe, Extract pwest, megabytes 10
> Start pwest
> Info pwest
```

## Integrated Replicat
```sql
> edit param reast
Replicat reast
UserIdAlias oggadmin_euro
-- Integrated Mode, Applier를 6개를 사용하겠다.
DBOPTIONS Integratedparams(parallelism 6)
-- 테이블의 구조가 동일한 경우 사용
AssumeTargetDefs
-- Replicat가 시작될때 DiscardFile을 지운다.
-- Purge -> Append 하면 지우지 않고 append한다.
DiscardFile ./dirrpt/rpdw.dsc, Purge
Map amer.west.*, target euro.east.*;
:wq

> DBLogin UserIDAlias oggadmin_euro
> Add Replicat reast Integrated exttrail ./dirdat/pe
> start reast
```

## Replicat Map Sample
1. salesrpt
```sql
> edit param salesrpt
-- Created by Joe Admin on 10/11/2017.
Replicat salesrpt
-- 멀티 Instance인 경우 Service명 설정
SetEnv (ORACLE_SID = 'orcl')
UserID ggsuser@myorcl, Password ggspass
-- UserIDAlias oggalias
DiscardFile ./dirrpt/SALESRPT.dsc, Append
-- where 조건 설정. 산술연산이 들어갈 수 없다(필요하면 Filter 사용). 바로위의 테이블에만 적용 된다
Map HR.STUDENT, Target HR.STUDENT 
    Where (STUDENT_NUMBER < 400000);
Map HR.CODES, Target HR.CODES;
-- where 조건 설정. 산술연산이 들어갈 수 없다(필요하면 Filter 사용). 바로위의 테이블에만 적용 된다
Map SALES.PRODUCTS, Target SALES.PRODUCTS,
    Where (STATE = 'CA' AND OFFICE = 'LA');
-- AMOUNT 컬럼에 값이 있고, Null이 아니면
Map SALES.ORDERS, Target SALES.ORDERS,
    Where (AMOUNT = @PRESENT AND AMOUNT <> @NULL);
```

## Macro
1. Macro sample
```sql
$ vi ./dirprm/make_date.mac 
Macro #make_date
Params (#year, #month, #day)
BEGIN
@DATE("YYYY-MM-DD", "CC", @IF(#year < 50, 20, 19), 
"YY", #year, "MM", #month, "DD", #day)
End;
```
2. Use sample
```sql
Include /ggs/dirprm/make_date.mac
...
Map SALES.ACCT, Target REPORT.ACCOUNT,
ColMap
( TargetCol1 = SourceCol1,
Order_Date = #make_date(Order_YR,Order_MO,Order_DAY),
Ship_Date = #make_date(Ship_YR,Ship_MO,Ship_DAY)
);
```

## Token
1. Set Sample
```sql
Extract extdemo
Table SALES.PRODUCT, TOKENS (
    (Token name) TKN-OSUSER = @GETENV ('GGENVIRONMENT', 
    'OSUSERNAME'), 
    TKN-DOMAIN = @GETENV ('GGENVIRONMENT', 'DOMAINNAME'), 
    TKN-COMMIT-TS = @GETENV ('GGHEADER', 'COMMITTIMESTAMP'), 
    TKN-BA-IND = @GETENV ('GGHEADER', 
    'BEFOREAFTERINDICATOR'), 
    TKN-TABLE = @GETENV ('GGHEADER', 'TABLENAME'), 
    TKN-OP-TYPE = @GETENV ('GGHEADER', 'OPTYPE'), 
    TKN-LENGTH = @GETENV ('GGHEADER', 'RECORDLENGTH'), 
    TKN-DB-VER = @GETENV ('DBENVIRONMENT', 'DBVERSION')
); 
```
2. Use Sample
```sql
Map SALES.ORDER, Target REPORT.ORDER_HISTORY,
    ColMap (USEDEFAULTS,
        TKN_NUMRECS = @TOKEN ('TKN-NUMRECS');
Map SALES.CUSTOMER, Target REPORT.CUSTOMER_HISTORY,
    ColMap (USEDEFAULTS,
        TRAN_TIME = @TOKEN ('TKN-COMMIT-TS'),
OP_TYPE = @TOKEN ('TKN-OP-TYPE'), 
    BEFORE_AFTER_IND = @TOKEN ('TKN-BA-IND'),
        TKN_ROWID = @TOKEN ('TKN-ROWID'));
```
## Compression
1. Set Sample
```sql
--750 byte가 넘을 때만 압축하도록 한다
RmtHost newyork, MgrPort 7809, Compress, CompressThreshold 750
```