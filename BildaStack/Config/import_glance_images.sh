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

source /root/keystonerc_admin
for file in /root/OS_Images/*
do
    if [[ -f $file ]]; then
	export img_name=`echo $file | sed 's/.*\///' | head -c 20`
	glance image-create --name "$img_name" --disk-format qcow2 --container-format bare --visibility public --file $file
    fi
done
