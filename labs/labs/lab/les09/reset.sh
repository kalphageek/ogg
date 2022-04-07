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
#       Executes the steps necessary to clean up the environment after lab 8
cd /u01/ogg/oggsrc
./ggsci <<EOF
dblogin useridalias oggadmin_root
stop er * !
sh sleep 9
delete er * !
sh sleep 9
unregister extract extwest database
sh sleep 2
unregister extract emap database
sh sleep 2
unregister extract estrm database
sh sleep 2
unregister extract ecoun database
sh sleep 3
exit
EOF
cd /u01/ogg/oggtrg
./ggsci <<EOF
dblogin useridalias oggadmin_euro
stop er * !
sh sleep 9
delete er * !
sh sleep 9
exit
EOF
cd /home/oracle/labs/lab/les09
echo "####### reset.sh for lab practice 9 script completed ######"

