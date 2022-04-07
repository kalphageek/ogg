1. 환경 설정
```sh
$ echo $OGG_HOME
$ export OGG_HOME=/u01/app/ogg/oggma
$ echo $PATH
$ export PATH=${PATH}:${OGG_HOME}/bin
$ cd /home/oracle/Software/fbo_ggs_Linux_x64_services_shiphome/Disk1
```
2. 설치
```sh
$ ./runInstaller
```

3. root ca 생성
```sh
$ mkdir /home/oracle/wallet_dir
$ orapki wallet remove -wallet ~/wallet_dir/root_ca -trusted_cert_all -pwd root_ca1
$ orapki wallet create -wallet ~/wallet_dir/root_ca -auto_login -pwd root_ca1
$ orapki wallet add -wallet ~/wallet_dir/root_ca -dn "CN=RootCA" -keysize 2048 -self_signed -validity 7300 -pwd root_ca1
$ orapki wallet export -wallet ~/wallet_dir/root_ca -dn "CN=RootCA" -cert ~/wallet_dir/rootCA_Cert.pem -pwd root_ca1
```
4. hostname 확인
```sh
$ hostname -f
edvmr1p0.us.oracle.com
```
5. user ca 생성
```sh
$ orapki wallet remove -wallet ~/wallet_dir/edvmr1p0 -trusted_cert_all -pwd edvmr1p0
$ orapki wallet create -wallet ~/wallet_dir/edvmr1p0 -auto_login -pwd  edvmr1p0
$ orapki wallet add -wallet ~/wallet_dir/edvmr1p0 -dn "CN=edvmr1p0.us.oracle.com" -keysize 2048 -pwd edvmr1p0
$ orapki wallet export -wallet ~/wallet_dir/edvmr1p0 -dn "CN=edvmr1p0.us.oracle.com" -request ~/wallet_dir/edvmr1p0_req.pem -pwd edvmr1p0
```
6. Add the root/user certificate into the client’s or server’s wallet
```sh
$ orapki cert create -wallet ~/wallet_dir/root_ca -request ~/wallet_dir/edvmr1p0_req.pem -cert ~/wallet_dir/edvmr1p0_Cert.pem -serial_num 20 -validity 365 -pwd root_ca1
$ orapki wallet add -wallet ~/wallet_dir/edvmr1p0 -trusted_cert -cert ~/wallet_dir/rootCA_Cert.pem -pwd edvmr1p0
$ orapki wallet add -wallet ~/wallet_dir/edvmr1p0 -user_cert -cert ~/wallet_dir/edvmr1p0_Cert.pem -pwd edvmr1p0
```
7. dist_client ca 생성
```sh
$ orapki wallet remove -wallet ~/wallet_dir/dist_client -trusted_cert_all -pwd dist_client
$ orapki wallet create -wallet ~/wallet_dir/dist_client -auto_login -pwd dist_client
$ orapki wallet add -wallet ~/wallet_dir/dist_client -dn "CN=edvmr1p0.us.oracle.com" -keysize 2048 -pwd dist_client
$ orapki wallet export -wallet ~/wallet_dir/dist_client -dn "CN=edvmr1p0.us.oracle.com" -request ~/wallet_dir/dist_client_req.pem -pwd dist_client
```
8. Add client's and server's wallet
```sh
$ orapki cert create -wallet ~/wallet_dir/root_ca -request ~/wallet_dir/dist_client_req.pem -cert ~/wallet_dir/dist_client_Cert.pem -serial_num 30 -validity 365 -pwd root_ca1
$ orapki wallet add -wallet ~/wallet_dir/dist_client -trusted_cert -cert ~/wallet_dir/rootCA_Cert.pem -pwd dist_client
$ orapki wallet add -wallet ~/wallet_dir/dist_client -user_cert -cert ~/wallet_dir/dist_client_Cert.pem -pwd dist_client
```
9. 검증
```sh
$ ls ./wallet_dir
root_ca dist_client edvmr1p0
$ orapki wallet display -wallet wallet_dir/dist_client -pwd dist_client
```

10. oggca 설치
```sh
$ oggca.sh &
```