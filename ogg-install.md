## Requirement
1. S/W Volume
    * Classic : 1.2 GB, MSA : 1.5 GB 필요
    * SWAP space 필요
2. Trail Volume
    * Trail file size : Pick time때의 redolog size에 맞춰서 할당
3. 환경
    * OGG_HOME 필요

## Alias
```sh
[ogg@hostname]$ alias
alias ggsci='rlwrap ./ggsci'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias oggsrc='export OGG_HOME=/u01/ogg/oggsrc; cd 
/u01/ogg/oggsrc'
alias oggtrg='export OGG_HOME=/u01/ogg/oggtrg; cd 
/u01/ogg/oggtrg'
alias rman='rlwrap rman'
alias sqlplus='rlwrap sqlplus'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --
show-dot --show-tilde'
```

## Verify
```sh
[ogghostname oggsrc]$ lsnrctl status
$ ps -ef | grep pmon
$ printenv
```

## Install
```sh
[ogg$hostname oggsrc]$ mkdir /u01/ogg/oggsrc # port 7809
$ unzip 123010_fbo_ggs_Linux_x64_shiphome.zip
$ cd fbo_ggs_Linux_x64_shiphome/Disk1
$ ls
install response runInstaller stage
$ ./runInstaller
Software Location : /u01/ogg/oggsrc
Database Location : $ORACLE_HOME
Manager Home : 7809
$ oggsrc
$ ggsci
> view param mgr
```
