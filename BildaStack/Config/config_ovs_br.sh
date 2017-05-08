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
# ./config_ovs_br.sh $PUB_IFACE_IP $PUB_IFACE_NMASK $PUB_NET_GATEWAY $PUB_NET_DNS
# Where PUB_IFACE_x = iface conencted to the public or external network. 

if [ -z "$1" ]
  then
 echo "Syntax: config_ovs_br [ip] [mask] [gateway] [dns1] "
 exit 0
fi
# $1 = ip from pub n/w connected iface , $2 = netmask , $3= gatway
# $4 = dns1
export iface_cfg_file=/etc/sysconfig/network-scripts/ifcfg-br-ex

if grep -q "DEVICE=br-ex" "$iface_cfg_file"; then
   echo "Device Setting Already exists , skipping .."
else
        echo "DEVICE=br-ex" >> $iface_cfg_file
fi

if grep -q "DEVICETYPE=ovs" "$iface_cfg_file"; then
   echo "Device type Setting Already exists , skipping .."
else
        echo "DEVICETYPE=ovs" >> $iface_cfg_file
fi

if grep -q "TYPE=OVSBridge" "$iface_cfg_file"; then
   echo "OVSBridge type Setting Already exists , skipping .."
else
        echo "TYPE=OVSBridge" >> $iface_cfg_file
fi

if grep -q "BOOTPROTO=static" "$iface_cfg_file"; then
   echo "Boot protocol static Setting Already exists , skipping .."
else
        echo "BOOTPROTO=static" >> $iface_cfg_file
fi

if grep -q "IPADDR=$1" "$iface_cfg_file"; then
   echo "IPADDR Setting Already exists , skipping .."
else
        echo "IPADDR=$1" >> $iface_cfg_file
fi

if grep -q "NETMASK=$2" "$iface_cfg_file"; then
   echo "NETMASK Setting Already exists , skipping .."
else
        echo "NETMASK=$2" >> $iface_cfg_file
fi

if grep -q "GATEWAY=$3" "$iface_cfg_file"; then
   echo "GATEWAY Setting Already exists , skipping .."
else
        echo "GATEWAY=$3" >> $iface_cfg_file
fi


if grep -q "DNS1=$4" "$iface_cfg_file"; then
   echo "DNS1 Setting Already exists , skipping .."
else
echo "DNS1=$4" >> $iface_cfg_file
fi


if grep -q "ONBOOT=yes" "$iface_cfg_file"; then
   echo "ONBOOT Already set , skipping .."
else
echo "Setting ONBOOT=YES"
echo "ONBOOT=yes" >> $iface_cfg_file
fi

if grep -q "DEFROUTE=yes" "$iface_cfg_file"; then
   echo "DEFAULT ROUTE DEFROUTE  Already set for the BR-EX , skipping .."
else
  echo "DEFROUTE=yes" >> $iface_cfg_file
fi

echo
echo
