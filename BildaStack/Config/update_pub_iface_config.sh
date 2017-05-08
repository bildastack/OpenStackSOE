#!/bin/bash 

#Copyright [2015-2017] [BildaStack Base 7.1.3292017]
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
#Modification , redistribution and derivation requires providing a notice
#to the original authors at license@bildastack.com
# BildaStack CopyRight 2015-2017
#
#
# File Version : 2.0
# Author : BildaStack
 
# Purpose: 
# Create or update the OVS bridge based on arg variables provided
# ./update-pub-iface-config.sh $PUB_IFACE_NAME $PUB_IFACE_MAC
# Where PUB_IFACE_x = iface conencted to the public or external network. 
if [ -z "$1" ]
  then
 echo "Syntax: update-pub-iface-config [iface name] [iface mac address] "
 exit 0
fi
# $1 = publicly connected iface name, $2 = MAC Hardware address 

export iface_cfg_file=/etc/sysconfig/network-scripts/ifcfg-$1

if grep -q "DEVICE=$1" "$iface_cfg_file"; then
   echo "Device Setting Already exists , skipping .."
else
        echo "DEVICE=$1" >> $iface_cfg_file
fi

if grep -q "HWADDR=$2" "$iface_cfg_file"; then
   echo "IPADDR Setting Already exists , skipping .."
else
        echo "HWADDR=$2" >> $iface_cfg_file
fi

if grep -q "TYPE=OVSPort" "$iface_cfg_file"; then
   echo "OVSBridge type Setting Already exists , skipping .."
else
        echo "TYPE=OVSPort" >> $iface_cfg_file
fi

if grep -q "DEVICETYPE=ovs" "$iface_cfg_file"; then
   echo "Device type Setting Already exists , skipping .."
else
        echo "DEVICETYPE=ovs" >> $iface_cfg_file
fi

if grep -q "OVS_BRIDGE=br-ex" "$iface_cfg_file"; then
   echo "Device type Setting Already exists , skipping .."
else
        echo "OVS_BRIDGE=br-ex" >> $iface_cfg_file
fi

if grep -q "ONBOOT=yes" "$iface_cfg_file"; then
   echo "ONBOOT Already set , skipping .."
else
  echo "ONBOOT=yes" >> $iface_cfg_file
fi

if grep -q "DEFROUTE=no" "$iface_cfg_file"; then
   echo "DEFROUTE  Already correct value set to 'no' i.e. hopefully  DEFROUTE should be on BR-EX skipping .."
else
  echo "DEFROUTE=no" >> $iface_cfg_file
fi

echo
echo
