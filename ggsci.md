## History
```sh
$ oggsrc
$ ggsci
> history
> !
> !2
```

* Add Extract
```sh
# Redolog를 현재 redolog가 만들어지는 지점부터 capture하겠다는 의미
> Add Extract myext, Integrated TranLog, Begin Now
# Local Trail을 lt라는 이름으로 만든다. default 500MB
> Add ExtTrail /ggs/dirdat/lt, Extract myext
# Extract 실행
> start Extract myext
# 일련의 명령을 스크립트로 실행
> obey myscript.oby
```

* OS 에서 Extract/Pump/Replicat 실행
```sh
$ ./extract paramfile ...
$ ./extract pumpfile ...
$ ./replicat paramfile ...
```