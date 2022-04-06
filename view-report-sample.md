1. pwconf 
```sql
> view report pwconf
***********************************************************************
** Running with the following parameters **
***********************************************************************
2017-04-10 12:58:48 INFO OGG-03035 Operating system character set identified as UTF-8. 
Locale: en_US, LC_ALL:.
-- WEST
Extract pwconf
RmtHost easthost, MgrPort 15001, Compress
-- Pump를 의미
RmtTrail ./dirdat/pf
-- Update시 Trail file에는 Before/After image를 1개의 Record로 병합
Passthru
Table west.*;
-- GetBeforeCols : 설정되면 Before image의 컬럼메타정보를 가져오지 않는다 
-- cannot use GetBeforeCols on the data pump above with Passthru...
2017-04-10 12:58:53 INFO OGG-01226 Socket buffer size set to 27985 (flush size 27985).
***********************************************************************
** Run Time Messages **
***********************************************************************
Opened trail file ./dirdat/wf000000 at 2017-04-10 12:58:53
Wildcard TABLE resolved (entry west.*):
Table "WEST"."PRODUCTS";
PASSTHRU mapping resolved for source table WEST.PRODUCT
```