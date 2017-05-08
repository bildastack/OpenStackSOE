#!/bin/bash
if [ -z "$1" ]
  then
    echo
    echo " No compute host provided , "
    echo " Usage : add-compute.sh \"IP.IP.IP.IP\" "
    exit
fi
export NEW_COMPUTE_HOST=$1
echo $NEW_COMPUTE_HOST 
export CURRENT_COMPUTE_HOSTS=`grep CONFIG_COMPUTE_HOSTS /root/packstack*`
echo $CURRENT_COMPUTE_HOSTS
# Check if the new compute host already been added to list of compute hosts 
if [ -z `grep $NEW_COMPUTE_HOST /root/packstack*` ]; then
               echo "HOST entry doesnt exist already , so adding ..."
	       sed -i s/$CURRENT_COMPUTE_HOSTS/$CURRENT_COMPUTE_HOSTS,$NEW_COMPUTE_HOST/g /root/packstack*
            else
               echo "Host already added to COMPUTE hosts, cant add again  .."
            fi

#sed -i s/$CURRENT_COMPUTE_HOSTS/$CURRENT_COMPUTE_HOSTS,$1/g /root/packstack*
