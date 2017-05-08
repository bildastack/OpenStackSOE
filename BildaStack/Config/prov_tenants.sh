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

source ~root/keystonerc_admin

# create a DevTest Tenant/Project
openstack project create --description "DevTest Tenant" devtest

# Create the admin user for the DevTest Tenant
openstack user create devtest-admin --password admin123

# Create regular users for devtest tenant
openstack user create  devtest-user-1 --password abc123
openstack user create  devtest-user-2 --password abc123

# Create 'user' role
openstack role create user

# Assign the admin role to newly created devtest tenant admin user 
openstack role add --project devtest --user devtest-admin admin

# Assign the user role to newly created devtest-user-1 user to user for project devtest 
openstack role add --project devtest --user devtest-user-1 user
openstack role add --project devtest --user devtest-user-2 user
openstack user list
