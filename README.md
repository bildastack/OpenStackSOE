# OpenStack
# Standard Operating Environment 
____  _ _     _         ____   ___  _____
| __ )(_) | __| | __ _  / ___| / _ \| ____|
|  _ \| | |/ _` |/ _` | \___ \| | | |  _|
| |_) | | | (_| | (_| |  ___) | |_| | |___
|____/|_|_|\__,_|\__,_| |____/ \___/|_____|

Paid support available by providing your machine id 
(from /root/licenseinfo.txt) to support@bildastack.com

Quick Start: 
1. Login root/xse345
2. bilda.sh openstack-poc

Overview:
Bilda Standard Operating Environment (Bilda SOE in short) 
provides a baseline of the system that has all the 
required settings and packages installed required for optimal and 
efficient functioning of applications or stacks to be built on top. 

Hence SOE's provide the crucial foundation for a stable and 
high performance overall environment that will reduce your troubleshooting 
times and improve operations.

Bilda provides Standard Operating Environments for Hybrid Cloud 
technologies for:
OpenStack :  Openstack+AWS+Azure called Bilda OpenStack SOE
Containers:  Kubernetes+AWS+Azure called Bilda Container SOE

Bilda OpenStack SOE:
Standard Operating Environment for OpenStack has been carefully
architected to make deployment & operation of OpenStack as easy as 
possible without compromising performance. It has following features:

1. Standardized hostname configuraiton
2. Pre-requisite configurations for installing openstack
   a. Setting SELInux to be permissive as it hinders installation
   b. Setting up an NTP time server link to avoid timing issues
   c. Automatic sizing of /root partition to occupy max available
      disk. Default packstack installation can only use /root shared
      between all tenants.If not configured proactively will reduce
      amount of diskspace available. Bilda SOE takes care of that.
   d. Setting up proper language etc locales.
   e. Disabling NetworkManager & Firewalld and enabling network &
      iptables packages instead.
3. Installation of commonly used packages like zip, rsync, git etc
   that will aid in openstack operations
4. Installation of no-fuss openstack automation scripts that will
   help you install and operate openstack in a dev-test or POC setting.
5. Download and import initial operating system images for the VM's
6. Configures and provisions different Tenants and users for you to 
   be able to use OpenStack out of the box
7. Configures and provisions external network, router and private 
   network out of the box


OpenStack Proof-Of-Concept Deployment Notes:
By default openstack-poc argument to bilda.sh will provision an all-in-one
openstack node that will get you up and running for a Proof-Of-Concept setting. 

Currently Bilda OpenStack SOE supports following OpenStack releases:
Mitaka, Newton, Ocata

By default bilda.sh will install OpenStack 'mitaka' release. If you'd 
rather want to choose a different release please edit: 

/root/BildaStack/Install/poc_osp.sh

FROM: export OSP_RELEASE_NAME="mitaka"
TO:  export OSP_RELEASE_NAME="<release name : ocata or newton>"


