Trail file을 분석하는데 사용한다
```sh
$ oggsrc
$ ./logdump
> open dirdat/rt000000000
# To view the trail file header:
> fileheader on
# To view the record header with data
> ghdr on
# 컬럼정보 추가
> detail on
# To add hex and ASCII data values to the column list:
> detail data
# 280개씩 보겠다
> reclen 280
> fileheader detail
> pos 0
> n(ext)
# 특정 RBA로 이동
> pos <RBA>
# 데이터에 에러가 있는 경우(예:RBA가 누라된 등) Record는 skip한다
> scanforheader
# open된 파일에 있는 operation 건수
> count 
# filter 조건 설정
> filter <option>
# 데이터로 검색
> string <data>
# 지금부터 실행하는 내용을 log로 남기겠다
> log to mysession.log

# Token 정보 보기
> UserToken On
> UserToken Detail
> n
```
* IO Time : 소스DB의 commit 시간
* IOType : DML 종류
