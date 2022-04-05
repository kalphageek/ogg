## Manager
```sh
> edit params mgr
# Manager Port
Port 7809
DynamicPortList 8001, 8002, 9500–9520
# 타겟에 전달이 완료된 Trail file은 삭제 and 5일 보관 유지
PurgeOldExtracts /ggs/dirdat/bb*, UseCheckpoints, & 
MinKeepDays 5
# Manager가 시작될때 Extract/Replicat이 함께 시작된다
Autostart ER *
# Extract가 비정상 종료하는 경우 2분 단위 5회 재실행
AutoRestart Extract *, WaitMinutes 2, Retries 5
# 1시간 마다 Lag Report 생성 (Report 파일)
LagReportHours 1
LagInfoMinutes 3
## 5분동안 Lag이 발생하면 Critical 알람
LagCriticalMinutes 5
```

## Credential
1. 소스DB (Downstream DB)
```sh
> Create Wallet
> Add CredentialStore
# 소스DB 접속
> Alter CredentialStore Add User c##OGG_Admin@amer Password oracle_4U Alias oggadmin_amer
# 타겟DB 접속
> Alter CredentialStore Add User c##OGG_Admin@euro Password oracle_4U Alias oggadmin_euro
# Container DB 접속
> Alter CredentialStore Add User c##OGG_Admin Password oracle_4U Alias oggadmin_root
> Info CredentialStore
> DBLogin UserIDAlias oggadmin_amer
> exit
# Walet 과 Credential store를 타겟DB에 
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
-- Transform 안하고 그대로 전달한다. 
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

## Initial Load (Extract file)
1. Extract
> 성능을 위해 Extract file을 2개로 생성
```sql
> dblogin useridalias oggadmin_root
> edit param eftor
ourceIsTable
UserIdAlias oggadmin_amer
RMTHOST easthost, MGRPORT 7909
-- Extract file 생성. Local에는 만들지 않는다
RMTFILE ./dirdat/account.dat, purge
table amer.west.account;
RMTFILE ./dirdat/branch.dat, purge
-- User 변경 매핑
table amer.west.branch;
```
2. Replicat
> 2개의 Extract file에 각각 Replicat 생성
```sql
> dblogin useridalias oggadmin_euro
> edit param lacct
SpecialRun
End Runtime
UserIdAlias oggadmin_euro
ExtFile ./dirdat/account.dat
-- User 변경 매핑
Map amer.west.account, target euro.east.account;
:wq

> edit param lbranch
SpecialRun
End Runtime
UserIdAlias oggadmin_euro
ExtFile ./dirdat/branch.dat
-- User 변경 매핑
Map amer.west.branch, target euro.east.branch;
```
3. Run Extract/Replicat
```sh
$ oggsrc
$ ./extract paramfile dirprm/eftor.prm reportfile dirrpt/eftor.rpt
$ more dirrpt/eftor.rpt
$ oggtrg
$ strings ./dirdat/account.dat | more
$ ./replicat paramfile dirprm/lacct.prm reportfile dirrpt/lacct.rpt
$ ./replicat paramfile dirprm/lbranch.prm reportfile dirrpt/lbranch.rpt
$ sqlplus east/oracle_4U@euro
> select count(*) from account;
> select count(*) from branch;
```
