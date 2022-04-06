Trail file을 이용한 Initial Load
## Extract
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
## Replicat
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
## Run Extract/Replicat on OS
```sql
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
