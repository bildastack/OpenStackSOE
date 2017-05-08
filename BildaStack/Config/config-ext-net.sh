
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

# Define Pub/Pvt network parameters
# PUBLIC_NET_NAME=
# PUBLIC_NET_POOL_START=
# PUBLIC_NET_POOL_END=
# PUBLIC_NET_CIDR= should be same as the PUBLIC_NET_POOL network 
# PRIVATE_NET_CIDR= should be different from PUBLIC_NET_POOL network , this is the pool where VM's will get their pvt ip's 
# EXTERNAL_NET_NAME= e.g. extnet

export PUBLIC_NET_NAME="public_subnet"
export PUBLIC_NET_POOL_START="10.10.1.210"
export PUBLIC_NET_POOL_END="10.10.1.250"
export PUBLIC_NET_CIDR="10.10.1.0/24" 
export PUBLIC_ROUTER_NAME="router1"

export EXTERNAL_NET_NAME="extnet"
export PRIVATE_NET_CIDR="192.168.200.0/24"
export PRIVATE_NET_NAME="private_network"
export PRIVATE_NET_SUBNET_NAME="private_subnet"

# Get current IP , Network Mask, Gateway & DNS of the host i.e. b4 osp is installed for interface connected to public network
# Please note we're using head-1 assuming that first interface has external connectivity, 
# rest of the scripts will use that too , this means ths script will always look 
# for the 1st entry out of multiple nic cards
export PUBLIC_IFACE_NAME=`ip addr | grep -i broadcast | awk '{ print $2 }'| sed 's/:/\ /g' | head -1`
export PUBLIC_IFACE_IP=`ip add | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -1`
export PUBLIC_IFACE_NMASK=`ifconfig $IFACE_NAME | grep netmask | awk '{print $4}' | head -1`
export PUBLIC_NET_GATEWAY=`ip route | head -1 | awk '{print $3}'`
export PUBLIC_NET_DNS="10.10.10.1"
export PUBLIC_IFACE_MAC=`ip addr | grep -i ether | awk {'print $2'} | head -1`

# Check if /etc/sysconfig/network-scripts/ifcfg-br-ex already exist , if it does remove it
# Create a new ifcfg-br-ex with PRE_OSP_IP & PRE_OSP_NMASK etc parameters --> script
# Create a new ifcfg-enp0sX with PRE_OSP_MAC & OVSBridge etc parameters --> script
# Cofnigure Openstack to use OVS bridge w/ ethernet interface as a port 

# Before this make a copy of the original files if/when rolling back
mkdir -p /root/orig_config_files
cp /etc/sysconfig/network-scripts/ifcfg-$PUBLIC_IFACE_NAME  /root/orig_config_files/
cp /etc/resolv.conf /root/orig_config_files/
cp /etc/hosts /root/orig_config_files

./config_ovs_br.sh $PUBLIC_IFACE_IP $PUBLIC_IFACE_NMASK $PUBLIC_NET_GATEWAY $PUBLIC_NET_DNS
./update-pub-iface-config.sh $PUBLIC_IFACE_NAME $PUBLIC_IFACE_MAC


openstack-config --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs bridge_mappings extnet:br-ex
openstack-config --set /etc/neutron/plugin.ini ml2 type_drivers vxlan,flat,vlan

# Restart the network service 
service network restart
service neutron-openvswitch-agent restart
service neutron-server restart

source ~/keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared

# ecreate the public subnet with an allocation range outside of your external DHCP range and set the gateway to the default gateway of the external network.

neutron subnet-create --name $PUBLIC_NET_NAME --enable_dhcp=False --allocation-pool=start=$PUBLIC_NET_POOL_START,end=$PUBLIC_NET_POOL_END \
                        --gateway=$PUBLIC_NET_GATEWAY external_network $PUBLIC_NET_CIDR
neutron router-create $PUBLIC_ROUTER_NAME
neutron router-gateway-set $PUBLIC_ROUTER_NAME external_network

# Now create a private network and subnet, since that provisioning has been disabled:

neutron net-create $PRIVATE_NET_NAME
neutron subnet-create --name $PRIVATE_NET_SUBNET_NAME $PRIVATE_NET_NAME $PRIVATE_NET_CIDR
# connect this private network to the public network via the router, which will provide the floating IP addresses.
neutron router-interface-add $PUBLIC_ROUTER_NAME $PRIVATE_NET_SUBNET_NAME
