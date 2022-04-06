## 강의 개요
* 실습환경 : https://ouconnect.oracle.com/
* 99401768.user04 / StSRLjcHY5
* oracle / 

## Classic 아키텍처
* cli 환경

## Microservice 아키텍처
* Cloud 환경에서 주로 사용하나 Onpremies환경에서도 사용 가능
* REST API
* SSL
* 샤딩 환경 지원
* Browser기반 Client 지원

## Logical 어키텍처
1. 초기적재도 Extract -> Replicat으로 가능
2. 소스
    * Manager 1개
    * Extract는 여러개 가능
3. 타겟
    * Manager 1개
    * Collector 여러개
    * Replicat 여러개

## Downstream
* 12c(소스) -> 19c(Downstream) 가능
* Downstream DB의 버전에 맞는 OGG 버전 사용 필요.

## Extract
> Redolog/Archivelog를 추출해서 Local Trail file 생성 (Optional)
* Categories
    * Custom Processing : User Exit(외부프로그램) 연동
    * Reporting : 1분마다 통계정보 기록 등..
    * Error Handling
    * Tuning
    * Mainenance
    * Security
* 별도의 메모리 공간을 사용한다. Redolog 정보를 해당 메모리 공간에 올린다.
* 메모리가 크면 버퍼링이 용이해서 성능에 유리하다.
* Add Extract 명령을 실행하면 Checkpoint file이 자동으로 만들어진다.
1. Integrated (Oracle만 가능)
    * Multithreaded
    * 내부적으로 Log Minor 프로그램 사용. Logical Change Records(LCR)로 capture.
    * Oracle의 internal log parsing 가능
    * Exadata/Compression/IOT,XML,LOB 지원
    * Downstream 방식적용 
    * SGA 메모리 사용
    * Dependency관계를 보고 commit순서를 바꾸는 경우도 있다.
    * 반드시 Register를 함께 해야 한다.
    * Dictionary View 사용가능
    ```
    dba_apply
    v$gg_apply_server
    v$gg_apply_coordinator
    v$gg_apply_reader
    dba_goldengate_inbound
    ```
2. Classic
    * LOB 데이터 못 읽음
    * 다양한 DB Platform / Version 지원 가능
    * Multitenant 지원 안됨
    * Dependency관계를 반영하지 못한다.

## Manager
> 소스 / 타겟 OGG Process를 관리하는 Master Process
* 역할
    * OGG process start/stop/monitoring
    * OGG process 구성 파라미터 설정 
    * Error and lag reporting -> Report files
    * Resource management
    * Trail file management

## Collector
> Pump가 전송한 Extract 데이터 또는 Trail file을 받아서 Remote Trail file을 생성한다.
* Manager에 의해 동적으로 운영됨

## Trail File
* 케노니컬 포맷
* 번호가 Circular하게 생성
* 소스테이블의 구조 정보를 가지고 있다.
* first / last record의 CSN정보를 가지고 있다
* Record length
* User token area 정의 가능 : 사용자가 정의한 변수
* DML Operation type
* Local / Remote OOG 버전이 다른 경우 버전을 정의할 수 있다.
    > RmtTrail ./dirdat/ex, Format Release 12.3
* Outputformat 변경이 가능하다
    * SQL
    * Text (csv)
        |Header 컬럼 값 | 의미|
        |---|---|
        |B |The transaction begins |
        |I |A record is added |
        |V |A record is updated |
        |C |The transaction commits |
    * XML


## Pump
* Local trail file을 reaad. Remote Collector 에게 전달한다
* 압축 또는 암호화 전달 가능

## Replicat
* 타겟 Oracle and Non-Oracle DB
* 배치처리 가능
* Data 변환 과 병합 작업 가능
* Smart txn group : txn을 묶어서 처리 가능
* HandleCollisions : dup/no_data 발생시 에러가 안나도록 처리가능. 약간의 overhead가 있음.
* InsertAllRecords : txn을 특정 테이블에 log처럼 담을 수 있다.
* DBOptions DeferRefConst SuppressTriggers : constraint를 defer로 운영. trigger를 가동하지 않겠다.
### Classic
> Trail file을 replicat이 sql로 전환해서 DB에 전달한다 
### Integrated (Oracle만 가능)
> Replicat에 의해 실행됨. Replicat은 Trail file을 Receiver에게 그대로 전달. API (Package)를 통해 데이터 적재. Applier의 갯수로 성능을 조정할 수 있다. Checkpoint 정보를 내부의 Dynamic Performance View를 사용해서 가져온다. Checkpoint테이블이 별도로 필요없다.
1. Receiver
    > Trail file을 받아준다.
2. Preparer 
    > Txn에 대한 분류 작업
3. Coordinator
    > Job Master. 병렬처리 가능
4. Applier 1~N
    > Replicat의 파라미터를 통해 갯수를 조정할 수 있다. (지정 또는 min/max)
### Coordinated Replicat
> Thread를 통해 처리. 나머지는 Classic방식과 유사
### Parallel Replicat (Oracle 외에서도 가능)
> Thread를 통해 처리. Integrated방식과 유사하나 API를 타겟DB 밖(Downstream 등)에서 처리. Large txn을 지원한다. 타겟DB에 별도의 Checkpoint테이블이 필요하다 
* SPLIC_TRANS_REC : 몇개의 tXN을 하나로 묶을지
* CHUNK_SIZE : 배치 사이즈
1. Mapper
    > Trail file을 받아준다. Thread로 운영
2. Mllater
3. Scheduler
4. Appliers


## GGSCI
* CLI Interface
* 실행스크립트 파일 : *.oby
* shell command도 실행 가능

## Process Group
* 

## 초기적재
* Special run : 데이터 처리가 끝나면 프로세스 자동 stop
* 별도의 초기적재용 Extract를 생성한다
* 방식
    1. Extract -> Replicat : 속도가 빠르다
    2. Extract -> Collector -> Extract file ->(Bulk load) Replicat : 암호화 등 옵션을 사용하는 경우 사용

## Checkpoint
> Extract / Pump / Replicat 모두 가지고 있음. 
* checkpoint를 기준으로 하지만, read 위치를 변경할 수 있다.
    1. Extract : read 위치, CSN(SCN), write 위치 를 checkpoint파일에 기록한다.
    2. Pump : read 위치, write 위치를 checkpoint파일에 기록한다.
    3. Replicat : read 위치를 checkpoint파일에 기록한다. 

## SCN 확인 방법
* Log Miner (DB Utility)
* Log Dump (OGG Utility)    

## OS 에서 Extract/Pump/Replicat 실행
```sh
$ ./extract paramfile ...
$ ./extract pumpfile ...
$ ./replicat paramfile ...
```

## Wallet
> User ID와 Password를 저장해서 Alias로 사용할 수 있다. DB 접속하는 User의 password를 보호하기 위한 작업.
* 한군데서 만들고 dirwlt를 통째로 복사해서 사용 가능하다.

