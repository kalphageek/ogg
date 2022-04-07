#!/bin/bash
#----------------------------------------------------------------------
# DISCLAIMER:
#    This script is provided for educational purposes only. It is NOT
#       supported by Oracle World Wide Technical Support.
#    The script has been tested and appears to work as intended.
#       You should always run new scripts on a test instance initially.
#
#----------------------------------------------------------------------
# SHELL clean-up.sh
#       Executes the steps necessary to clean up the environment after lab 10
cd /u01/ogg/oggsrc
./ggsci <<EOF
dblogin useridalias oggadmin_root
stop er * !
sh sleep 9
delete er * !
sh sleep 9
unregister extract euevt database
sh sleep 3
stop manager !
exit
EOF
cd /u01/ogg/oggtrg
./ggsci <<EOF
dblogin useridalias oggadmin_euro
stop er * !
sh sleep 9
delete er * !
sh sleep 9
stop manager !
sh sleep 2
exit
EOF
cd /home/oracle/labs/lab/les11
echo "######## Reset script for practice 11 finished ######"

