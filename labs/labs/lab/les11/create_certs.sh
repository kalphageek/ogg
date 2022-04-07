#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "Script expects MA password as the first parameter."
    exit 1
fi
if [ -z "$1" ]
  then
    echo "Script expects MA password as the first parameter."
    exit 1
fi
honame=`hostname -f`
node=${honame%%.*}

mkdir ~/wallet_dir

orapki wallet create -wallet ~/wallet_dir/root_ca -auto_login -pwd $1

orapki wallet add -wallet ~/wallet_dir/root_ca -dn "CN=RootCA" -keysize 2048 -self_signed -validity 7300 -pwd $1

orapki wallet export -wallet ~/wallet_dir/root_ca -dn "CN=RootCA" -cert ~/wallet_dir/rootCA_Cert.pem -pwd $1


orapki wallet create -wallet ~/wallet_dir/${node} -auto_login -pwd $1

orapki wallet add -wallet ~/wallet_dir/${node} -dn "CN=${honame}" -keysize 2048 -pwd $1

orapki wallet export -wallet ~/wallet_dir/${node} -dn "CN=${honame}" -request  ~/wallet_dir/${node}_req.pem -pwd $1

orapki cert create -wallet ~/wallet_dir/root_ca -request ~/wallet_dir/${node}_req.pem  -cert  ~/wallet_dir/${node}_Cert.pem -serial_num 20 -validity 365 -pwd $1

orapki wallet add -wallet ~/wallet_dir/${node} -trusted_cert -cert ~/wallet_dir/rootCA_Cert.pem -pwd $1

orapki wallet add -wallet ~/wallet_dir/${node} -user_cert -cert ~/wallet_dir/${node}_Cert.pem -pwd $1

orapki wallet create -wallet ~/wallet_dir/dist_client -auto_login -pwd $1

orapki wallet add -wallet ~/wallet_dir/dist_client -dn "CN=${honame}" -keysize 2048 -pwd $1

orapki wallet export -wallet ~/wallet_dir/dist_client -dn "CN=${honame}" -request ~/wallet_dir/dist_client_req.pem -pwd $1

orapki cert create -wallet ~/wallet_dir/root_ca -request ~/wallet_dir/dist_client_req.pem  -cert  ~/wallet_dir/dist_client_Cert.pem -serial_num 30 -validity 365 -pwd $1

orapki wallet add -wallet ~/wallet_dir/dist_client -trusted_cert -cert ~/wallet_dir/rootCA_Cert.pem -pwd $1

orapki wallet add -wallet ~/wallet_dir/dist_client -user_cert -cert ~/wallet_dir/dist_client_Cert.pem -pwd $1

