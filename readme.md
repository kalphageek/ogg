## 강의 개요
* 실습환경 : https://ouconnect.oracle.com/
* 99401768.user04 / StSRLjcHY5
* oracle / 

## 참조
* Trail file : https://docs.oracle.com/goldengate/c1221/gg-winux/GWUAD/oracle-goldengate-trail.htm#GWUAD741
* GGSCI CMD : https://docs.oracle.com/goldengate/c1221/gg-winux/GWURF/summary-oracle-goldengate-commands.htm#GWURF884
* LogDump Utility : https://docs.oracle.com/goldengate/1212/gg-winux/GLOGD/wu_logdump.htm#GLOGD107
* Integrated Replicat View : https://docs.oracle.com/goldengate/1212/gg-winux/GLOGD/wu_logdump.htm#GLOGD107
* Parameter File Option : https://docs.oracle.com/goldengate/c1221/gg-winux/GWURF/summary-oracle-goldengate-parameters.htm#GWURF1004
* OGG 지원 DB : https://www.oracle.com/middleware/technologies/fusion-certification.html
* Manager 설정 : https://docs.oracle.com/goldengate/c1221/gg-winux/GWUAD/configuring-manager-and-network-communications.htm#GWUAD152
* Hearbeat
    - https://docs.oracle.com/en/middleware/goldengate/core/19.1/gclir/add-heartbeattable.html#GUID-126E30A2-DC7A-4C93-93EC-0EB8BA7C13CB
    - https://fatdba.com/2021/06/23/golden-gate-heartbeat-table-and-its-improvements-in-gg-19-1/
    - https://xanpires.wordpress.com/2016/08/01/goldengate-12-2-heartbeat-table/


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

## Lag
* Lag은 send / lag 명령어를 통해 보는 것이 정확하다.

## Macro
* 반복작업을 쉽게 구현할 수 있으며, 재사용 가능
* 매크로는 다른 매크로를 호출할 수 있다. 
* 파라미터 파일 외부에 만들어서 Include할 수 있다.

## Token
* 사용자 정의 변수. Replicat에서 사용하기 위해 넘겨줄 수 있다

## Compression
* zlib로 압축. Pump에서 압축 설정

## Event Action
> Table 또는 Map과 연동해서 Report/Log 생성 등 특정 Action을 수행하게 할 수 있다

## Microservices Architecture
* 개요
    * Classic 아키텍처와 병행해서 사용할 수 없다. 별도로 구성이 필요하다. 
    * 소스/타겟DB 또는 Downstream DB에서 설치한다.
    * OGG User를 별도로 생성한다. admin
    * 소스나 타겟 한쪽만 MSA로 구성이 가능하다
* 서비스
    * Deployment
        > 보통 하나의 소스DB 단위로 구성한다.
    * Service Manager
        > 전체 Deployment 환경과 프로세스를 관리
    * Administration Server
        > 하나의 Deployment를 관리
    * Distribution Server
        > Pump
    * Receiver Server
        > Collector
    * Performance Metrics Server
        > metrics service
* 기타
    * API : adminclinet (like ggsci )

## Administration Server
* Extract/Replicat 생성 및 Register
* REST API, WEB UI 통해 운영
* 자체 Web UI를 가지고 있음

## Distribution Server
* Pump와 동일한 역할
* N:M 프로세싱이 가능하다
* Data의 Transform은 못한다
* 빠른 속도가 필요하면 UDP를 사용할 수 있다.
* Classic방식의 Collector도 받을 수 있다.
* Distribution Server -> Receiver Server간 Path를 생성 한다.

## Receiver Server
* Collecter와 동일한 역할
* Distribution Server와 연동
* 자체 Web UI를 가지고 있음

## Performance Metrics Server
* 자체 Web UI를 가지고 있음
* 별도의 Server로 구성 가능
* Multi Thread 방식
* 처리하는 작업에 대한 상태/통계 정보를 제공한다.
* 별도의 Repository DB를 사용할 수 있다 
* 실시간 reource utilization 데이터를 제공한다.
* 서드파티 metrics 툴이 있다
* Active 프로세스 상태 정보를 제공한다.

## adminclient
* ggsci로 유사한 역할을 한다.
* 독립적으로 실행 된다.
* REST API 사용.

## Lag 분석 지원
* Hearbeat 테이블을 사용해서 분석하도록 지원한다
* ggsci에서 설정 가능
    * add heartbeattable
* MSA 환경에서도 지원 (WEB UI)
* heartbeat view 제공
    * gg_lag
    * gg_lag_history
