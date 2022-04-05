## 강의 개요
* https://ouconnect.oracle.com/
* 99401768.user04 / StSRLjcHY5
* oracle / 

## Classic 아키텍처
* 

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
* 별도의 메모리 공간을 사용한다. Redolog 정보를 해당 메모리 공간에 올린다.
* 메모리가 크면 버퍼링이 용이해서 성능에 유리하다.
1. Integrated (Oracle만 가능)
    * Multithreaded
    * 내부적으로 Log Minor 프로그램 사용. Logical Change Records(LCR)로 capture.
    * Oracle의 internal log parsing 가능
    * Exadata/Compression/IOT,XML,LOB 지원
    * Downstream 방식적용 
    * SGA 메모리 사용
2. Classic
    * LOB 데이터 못 읽음
    * 다양한 DB Platform / Version 지원 가능
    * Multitenant 지원 안됨

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

## Pump
* Local Trail file을 reaad
* 압축 또는 암호화 전달 가능

## Replicat
* 타겟 Oracle and Non-Oracle DB
* 배치처리 가능
* Data 변환 과 병합 작업 가능

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