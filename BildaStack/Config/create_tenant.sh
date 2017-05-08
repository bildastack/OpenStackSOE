# Now we are managing the users on a project by using groups. So everything
# is about creating users and add they to the groups.
# A special user is created always with the same name of the project,
# just to reserve the name and avoid confusion and have an email.


############## Define those variables for the tenant (this is just an example)
TENANT=poc1
PASSWORD=poc1
TENANT_DESC="POC-Tenant-1"
TENANT_EMAIL="poc-tenant-1@gmail.com"
TENANT_NET_CIDR="10.0.0.0/24"
TENANT_NET_GW="10.0.0.1"
############### 

# Create a new project and get the id
openstack project create $TENANT --description $TENANT_DESC 
TENANT_ID=$(openstack project list | awk "/\ $TENANT\ / { print \$2 }")

# Create a new user 
openstack user create --project $TENANT --password $PASSWORD --email $TENANT_EMAIL $TENANT

# Create a new group for the project
openstack group create --description "$TENANT users" $TENANT-users

# Create the global user role if it does not exists
openstack role create --or-show user

# Add the new user to the users of the project
openstack group add user $TENANT-users $TENANT

# Add the user role to the project and group
openstack role add --project $TENANT --group $TENANT-users user
# otherwise we would have to add the user directly:
#openstack role add --project demo --user demo user

# Create the network with VLAN
neutron net-create --tenant-id $TENANT_ID --provider:network_type vlan  "$TENANT-net"
# The field provider:segmentation_id is the VLAN ID for the tenant

# Create the subnet and get the ID
neutron subnet-create --name "$TENANT-subnet" --tenant-id $TENANT_ID --gateway $TENANT_NET_GW "$TENANT-net" $TENANT_NET_CIDR
TENANT_SUBNET_ID=$(neutron subnet-list -f csv -F id -F cidr | grep "$TENANT_NET_CIDR" | cut -f1 -d',' | tr -d '"')
  
# Create an HA Router and get the ID
neutron router-create --ha True --tenant-id $TENANT_ID "$TENANT-net-to-online_live-extnet"
ROUTER_ID=$(neutron router-list  -f csv -F id -F name | grep "$TENANT-net-to-online_live-extnet" | cut -f1 -d',' | tr -d '"')
 
# Set the gw for the new router
neutron router-gateway-set "$TENANT-net-to-online_live-extnet" online_dev
   
# Add a new interface in the main router
neutron router-interface-add $ROUTER_ID $TENANT_SUBNET_ID
