Direct Initial Load
## Extract
```sql
> Edit param eini
Extract eini
UserIdAlias oggadmin_root
RMTHOST easthost, MGRPORT 7909 
-- rini을 자동으로 실행한다.
RMTTASK replicat, GROUP rini
TABLE AMER.WEST.ACCOUNT;
TABLE AMER.WEST.ACCOUNT_TRANS;
TABLE AMER.WEST.BRANCH;
TABLE AMER.WEST.TELLER;
TABLE AMER.WEST.TELLER_TRANS;
TABLE AMER.WEST.BRANCH_ATM;
:wq

> DBLogin UserIDAlias oggadmin_amer
> Add Extract eini, SourceIsTable
-- Add Replicat rini, SpecialRun을 먼저 실행
> start extract eini
> into extract eini
```

## Replicat
```sql
> Edit param rini
REPLICAT rini
USERIDALIAS oggadmin_euro
BULKLOAD
MAP AMER.WEST.*, TARGET EURO.EAST.*;
:wq

Add Replicat rini, SpecialRun

```