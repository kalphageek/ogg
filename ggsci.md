## History
```sh
$ alias
$ oggsrc
$ ggsci
> history
> !
> !2
```
## 정보 보기
```sql
GGSCI>
-- lacct 통계정보 보기
> stats lacct
-- lacct 상태정보 보기
> status lacct
-- extwest lag 보기
> lag extwest
-- lacct lag 보기
> lag lacct
-- Manager 상세정보 보기
> view GGSEvt 
-- Temporary 파타미터 적용
> Send {Manager | Extract | Replicat}
-- 처리 메시지 보기
> view report lacct. 
-- extwest의 redolog 처리 위치와 csn, checkpoint 정보 등 을 보여준다. Recovery echekpoint : 읽기는 했지만 처리가 안된것. Current checkpoint : trail file을 생성한 마지막 위치
> info extwest showch
> info ER *
```
## 삭제
```sql
> DBLogin UserIDAlias oggadmin_root
> stop ER *
-- not interactive
> delete ER * !
> info all
> unregister extract extwest database
```
