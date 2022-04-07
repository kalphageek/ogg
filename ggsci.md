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

## Stats
```sql
-- view the oldest open tansaction
send extract ext_2a, showtrans
send recicat rep_6c, status
-- info extrac command to show checkpoints
info extract ext_2a, showch
-- info all command to view all OGG processes
info all, allprocesses
-- 1초당 처리하는 size
stats replicat rep_tb, reportrate sec
-- 전체 처리 size
stats exwest, total
```

## 파라미터의 Start POS 변경
```sql
> alter rep_6a, extseqno 0, extrba 1437
> alter replicat rep_6d, extseqno <seq_#>, extrba 0
> alter extract ext_6d, etrollover
> alter rextract ext_6d, begin 2020-11-08 12:30:40
> add extract ext_tb2, tranlog, extqeqno <recovery_seq#>, extrba <recovery_checkpoint>
```