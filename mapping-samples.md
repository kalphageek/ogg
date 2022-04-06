## Where



## Filter
```sql
Filter (ON UPDATE, ON DELETE, @Compute
    (PRODUCT_PRICE * PRODUCT_AMOUNT) > 10000);
```

## Map
```sql
...
Map HR.CONTACT, Target HR.PHONE,
    ColMap (USEDEFAULTS,
        NAME = CUST_NAME,
        PHONE_NUMBER = @StrCat( '(', AREA_CODE, ')', 
        PH_PREFIX, '-', PH_NUMBER )
    );
InsertAllRecords
Map SALES.ACCOUNT, Target REPORT.ACCTHISTORY,
    ColMap (USEDEFAULTS,
        TRAN_TIME = @GetEnv('GGHEADER', 'COMMITTIMESTAMP'),
        OP_TYPE = @GetEnv('GGHEADER', 'OPTYPE'),
        BEFORE_AFTER_IND = 
        @GetEnv('GGHEADER', 'BEFOREAFTERINDICATOR'),
    );
:wq
```

## Function Detail
```sql
AMOUNT_COL = @IF (AMT > 0, AMT, 0)
-- state가 CA/AZ/NV 이면 WEST를, 아니며 EAST를 할당하라
REGION = @IF (@VALONEOF (STATE, 'CA', 'AZ', 
    'NV'), 'WEST', 'EAST')
-- yy, mm, dd 컬럼을 1개의 컬럼으로 포맷을 적용해서 병홥
date_col = @Date ('YYYY-MM-DD', 'YY', 
    date1_yy, 'MM', date1_mm, 'DD', date1_dd)
NAME = @StrCat (LASTNAME, ';' ,FIRSTNAME)
-- Concat
INTL_PHONE = @StrCat (COUNTRY_CODE, '-', 
    AREA_CODE, '-', LOCAL_PHONE)
-- Instr
AREA_CODE = @StrExt (PHONE, 1, 3),
PREFIX = @StrExt (PHONE, 4, 6),
PHONE_NO = @StrExt (PHONE, 7, 10)
```