
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


# Source OpenStack Installation Defaults . Change according to your setup
source /root/BildaStack/Install/poc_vars

echo "                  Summary of your Node CONFIGURATION : "
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = "
echo " Node Hostname :                       $PUBLIC_NET_THIS_HOSTNAME "
echo " Inteface connected to public network: $PUBLIC_IFACE_NAME "
echo " IP of Public Interface:               $PUBLIC_IFACE_IP   "
echo " Netmask of Public IP:                 $PUBLIC_IFACE_NMASK"
echo " MAC Address of Public Interface:      $PUBLIC_IFACE_MAC  "
echo " Public Network Gateway:               $PUBLIC_NET_GATEWAY"

echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo
echo
echo "                  Summary of OpenStack-POC Install Defaults : "
echo " Please read Readme.txt for more details on how to configure these defaults"
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = = "

echo " OpenStack Release Installed :  $OSP_RELEASE_NAME"
echo " BildaStack Core OS Version  :  $BILDASTACK_CORE_OS_VER"

echo " Public Network Name         :  $PUBLIC_NET_NAME"
echo " Public Network IP Pool Start:  $PUBLIC_NET_POOL_START"
echo " Public Network IP Pool End  :  $PUBLIC_NET_POOL_END"
echo " Public Network CIDR         :  $PUBLIC_NET_CIDR"
echo " Public Network Router Name  :  $PUBLIC_NET_ROUTER_NAME"
echo " External Network Name       :  $EXTERNAL_NET_NAME"
echo " Private Network Name        :  $PRIVATE_NET_NAME"
echo " Private Network CIDR        :  $PRIVATE_NET_CIDR"
echo " Private Network Subnet Name :  $PRIVATE_NET_SUBNET_NAME"

echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo
echo " This automated installer will install an all-in-one openstack node without"
echo " any fuss. This can be extended later . If its first time accept defaults "
echo " current assumptions : Externally connected network is on 10.10.10.X network "
echo " while VM network will be on 192.168.100.X "
echo " Please change to suite your needs if your current lan is on differnt subnet"
echo

read -p "Continue with these parameters or abort? Yes / No [yn]" answer
if [[ $answer = y ]] ; then
# run the command
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " Starting automated install"
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo
# Set Locales
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " Setting Locales .. "
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo
  echo "LANG=en_US.utf-8" >> /etc/environment
  echo "LC_ALL=en_US.utf-8" >> /etc/environment
echo;echo
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " Performing openstack required baseline configs .. "
echo " Disabling NetworkManager and firewalld"
echo " Enabling iptables and network services and configuring NTP "
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo
NTP_SRVR="/usr/sbin/chronyd"
IPTABLES="/usr/sbin/iptables"
NETMANAGER="/usr/sbin/NetworkManager"
#Disable NetworkManager and enable the network service
if [ -f $NETMANAGER ]; then
   echo "NetworkManager Service '$NETMANAGER' Exists, need to disable it"
   service NetworkManager stop
   service network start
   chkconfig NetworkManager off
   chkconfig network on
else
   echo "NetworkManager Service does not exist , we're good to go .. "
   echo
fi

# Disable firewalld and enable iptables
systemctl stop firewalld
chkconfig firewalld off
if [ -f $IPTABLES ]; then
   echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
   echo "IPtables Service '$IPTABLES' Exists, Skipping .. "
   echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
   echo
else
   echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
   echo "IPTABLES Does Not Exist, attempting to install & then start service"
   echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
   echo
   yum -y install iptables
   systemctl start iptables
   chkconfig iptables on
fi

if [ -f $NTP_SRVR ]; then
   echo "NTP Service '$NTP_SRVR' Exists"
else
   echo "NTP_SRVR Does Not Exist, attempting to install & then start service"
   yum -y install chrony
   systemctl start chronyd
fi


echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " Installing OpenStack Release : $OSP_RELEASE_NAME "
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo

yum install -y centos-release-openstack-$OSP_RELEASE_NAME
yum update -y
yum install -y openstack-packstack

#exit

packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mappings=$EXTERNAL_NET_NAME:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:$PUBLIC_IFACE_NAME --os-neutron-ml2-type-drivers=vxlan,flat,vlan --cinder-volumes-size=40G --novasched-ram-allocation-ratio=2.0 --nagios-install=n --os-heat-install=y
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " ## OpenStack Installation Stage 3 Starting ... ###"
echo " We will configure Operational Aspects including VM images, flavors ,"
echo " Public Cloud Compatibility etc"
echo "#Download and install the VM images , first do the Cirros "
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo

/root/BildaStack/Config/download_vm_images.sh
/root/BildaStack/Config/import_glance_images.sh
/root/BildaStack/Config/prov_tenants.sh

echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo " ## OpenStack Installation Stage 4 Starting ... ###"
echo " We will configure Networks, Routers, Subnets etc"
echo " = = = = = = = = = = = = = = = = = = = = = == = = = = = = = = = = = = = = ="
echo

# Check if /etc/sysconfig/network-scripts/ifcfg-br-ex already exist , if it does remove it
# Create a new ifcfg-br-ex with PRE_OSP_IP & PRE_OSP_NMASK etc parameters --> script
# Create a new ifcfg-enp0sX with PRE_OSP_MAC & OVSBridge etc parameters --> script
# Cofnigure Openstack to use OVS bridge w/ ethernet interface as a port

# Before this make a copy of the original files if/when rolling back
mkdir -p /root/orig_config_files
cp /etc/sysconfig/network-scripts/ifcfg-$PUBLIC_IFACE_NAME  /root/orig_config_files/
cp /etc/resolv.conf /root/orig_config_files/
cp /etc/hosts /root/orig_config_files

echo " ****** PERFORMING EXTERNAL NETWORK CONFIGURATION ********"

/root/BildaStack/Config/config_ovs_br.sh $PUBLIC_IFACE_IP $PUBLIC_IFACE_NMASK $PUBLIC_NET_GATEWAY $PUBLIC_NET_DNS
/root/BildaStack/Config/update_pub_iface_config.sh $PUBLIC_IFACE_NAME $PUBLIC_IFACE_MAC

echo " Restarting network services , you might lose connectivity if you're remotely logged in .. "
echo " Please re-login if you get disconnected .."
echo
# Restart the network service
service network restart
service neutron-openvswitch-agent restart
service neutron-server restart
echo
echo " Creating & Configuring Public (Floating IP ) network .. "
echo

source ~/keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared

neutron subnet-create --name $PUBLIC_NET_NAME --enable_dhcp=False --allocation-pool=start=$PUBLIC_NET_POOL_START,end=$PUBLIC_NET_POOL_END \
                        --gateway=$PUBLIC_NET_GATEWAY external_network $PUBLIC_NET_CIDR
neutron router-create $PUBLIC_NET_ROUTER_NAME
neutron router-gateway-set $PUBLIC_NET_ROUTER_NAME external_network

echo
echo " Creating & Configuring Private (VM) network .. "
echo

neutron net-create $PRIVATE_NET_NAME
neutron subnet-create --name $PRIVATE_NET_SUBNET_NAME $PRIVATE_NET_NAME $PRIVATE_NET_CIDR
# connect this private network to the public network via the router,
# which will provide the floating IP addresses.
neutron router-interface-add $PUBLIC_NET_ROUTER_NAME $PRIVATE_NET_SUBNET_NAME
source /root/keystonerc_admin
echo
echo "Installation complete !"
echo
echo "Access your openstack dashboard from http://$PUBLIC_IFACE_IP/dashboard"
echo " Using username: 'admin' , password = $OS_PASSWORD"


# End of if CONDITIONS from install question
fi
echo "Aborting automated install"
exit
