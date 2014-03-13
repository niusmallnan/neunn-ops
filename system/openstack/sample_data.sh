#!/usr/bin/env bash

# Copyright 2013 OpenStack Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Sample initial data for Keystone using python-keystoneclient
#
# This script is based on the original DevStack keystone_data.sh script.
#
# It demonstrates how to bootstrap Keystone with an administrative user
# using the SERVICE_TOKEN and SERVICE_ENDPOINT environment variables
# and the administrative API.  It will get the admin_token (SERVICE_TOKEN)
# and admin_port from keystone.conf if available.
#
# Disable creation of endpoints by setting DISABLE_ENDPOINTS environment variable.
# Use this with the Catalog Templated backend.
#
# A EC2-compatible credential is created for the admin user and
# placed in etc/ec2rc.
#
# Tenant               User      Roles
# -------------------------------------------------------
# demo                 admin     admin
# service              glance    admin
# service              nova      admin
# service              swift     admin

# By default, passwords used are those in the OpenStack Install and Deploy Manual.
# One can override these (publicly known, and hence, insecure) passwords by setting the appropriate
# environment variables. A common default password for all the services can be used by
# setting the "SERVICE_PASSWORD" environment variable.

read -p "admin user password (default:Neunn@123): " ADMIN_PASSWORD
ADMIN_PASSWORD=${ADMIN_PASSWORD:-Neunn@123}

NOVA_PASSWORD=${NOVA_PASSWORD:-${SERVICE_PASSWORD:-nova}}
GLANCE_PASSWORD=${GLANCE_PASSWORD:-${SERVICE_PASSWORD:-glance}}
CINDER_PASSWORD=${CINDER_PASSWORD:-${SERVICE_PASSWORD:-cinder}}
NEUTRON_PASSWORD=${NEUTRON_PASSWORD:-${SERVICE_PASSWORD:-neutron}}
SWIFT_PASSWORD=${SWIFT_PASSWORD:-${SERVICE_PASSWORD:-swift}}
HEAT_PASSWORD=${HEAT_PASSWORD:-${SERVICE_PASSWORD:-heat}}
CEILOMETER_PASSWORD=${HEAT_PASSWORD:-${SERVICE_PASSWORD:-ceilometer}}


read -p "controller address or hostname (default:localhost): " CONTROLLER_ADDRESS

CONTROLLER_PUBLIC_ADDRESS=${CONTROLLER_ADDRESS:-localhost}
CONTROLLER_ADMIN_ADDRESS=${CONTROLLER_ADDRESS:-localhost}
CONTROLLER_INTERNAL_ADDRESS=${CONTROLLER_ADDRESS:-localhost}

read -p "keystone.conf path (default:/etc/keystone/keystone.conf): " KEYSTONE_CONF
KEYSTONE_CONF=${KEYSTONE_CONF:-/etc/keystone/keystone.conf}

# Extract some info from Keystone's configuration file
if [[ -r "$KEYSTONE_CONF" ]]; then
    CONFIG_SERVICE_TOKEN=$(sed 's/[[:space:]]//g' $KEYSTONE_CONF | grep ^admin_token= | cut -d'=' -f2)
    CONFIG_ADMIN_PORT=$(sed 's/[[:space:]]//g' $KEYSTONE_CONF | grep ^admin_port= | cut -d'=' -f2)
fi

export SERVICE_TOKEN=${SERVICE_TOKEN:-$CONFIG_SERVICE_TOKEN}
if [[ -z "$SERVICE_TOKEN" ]]; then
    echo "No service token found."
    echo "Set SERVICE_TOKEN manually from keystone.conf admin_token."
    exit 1
fi

export SERVICE_ENDPOINT=${SERVICE_ENDPOINT:-http://$CONTROLLER_PUBLIC_ADDRESS:${CONFIG_ADMIN_PORT:-35357}/v2.0}

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

#
# Default tenant
#
DEMO_TENANT=$(get_id keystone tenant-create --name=demo \
                                            --description "Default Tenant")

ADMIN_USER=$(get_id keystone user-create --name=admin \
                                         --pass="${ADMIN_PASSWORD}" \
                                         --tenant-id $DEMO_TENANT)

ADMIN_ROLE=$(get_id keystone role-create --name=admin)

keystone user-role-add --user-id $ADMIN_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $DEMO_TENANT

#
# Service tenant
#
SERVICE_TENANT=$(get_id keystone tenant-create --name=service \
                                               --description "Service Tenant")

GLANCE_USER=$(get_id keystone user-create --name=glance \
                                          --pass="${GLANCE_PASSWORD}" \
                                          --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $GLANCE_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT

NOVA_USER=$(get_id keystone user-create --name=nova \
                                        --pass="${NOVA_PASSWORD}" \
                                        --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $NOVA_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT


CINDER_USER=$(get_id keystone user-create --name=cinder \
                                        --pass="${CINDER_PASSWORD}" \
                                        --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $CINDER_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT



NEUTRON_USER=$(get_id keystone user-create --name=neutron \
                                        --pass="${NEUTRON_PASSWORD}" \
                                        --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $NEUTRON_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT



HEAT_USER=$(get_id keystone user-create --name=heat \
                                        --pass="${HEAT_PASSWORD}" \
                                        --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $HEAT_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT


CEILOMETER_USER=$(get_id keystone user-create --name=ceilometer \
                                        --pass="${CEILOMETER_PASSWORD}" \
                                        --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $CEILOMETER_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT


SWIFT_USER=$(get_id keystone user-create --name=swift \
                                         --pass="${SWIFT_PASSWORD}" \
                                         --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $SWIFT_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT



#
# Keystone service
#
KEYSTONE_SERVICE=$(get_id \
keystone service-create --name=keystone \
                        --type=identity \
                        --description="Keystone Identity Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $KEYSTONE_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:\$(public_port)s/v2.0" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:\$(admin_port)s/v2.0" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:\$(public_port)s/v2.0"
fi

#
# Nova service
#
NOVA_SERVICE=$(get_id \
keystone service-create --name=nova \
                        --type=compute \
                        --description="Nova Compute Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $NOVA_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:\$(compute_port)s/v1.1/\$(tenant_id)s" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:\$(compute_port)s/v1.1/\$(tenant_id)s" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:\$(compute_port)s/v1.1/\$(tenant_id)s"
fi

#
# Cinder service
#
CINDER_SERVICE=$(get_id \
keystone service-create --name=volume \
                        --type=volume \
                        --description="Cinder Volume Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $CINDER_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:8776/v1/\$(tenant_id)s" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:8776/v1/\$(tenant_id)s" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:8776/v1/\$(tenant_id)s"
fi

#
# Image service
#
GLANCE_SERVICE=$(get_id \
keystone service-create --name=glance \
                        --type=image \
                        --description="Glance Image Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $GLANCE_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:9292" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:9292" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:9292"
fi


#
# Neutron service
#
NEUTRON_SERVICE=$(get_id \
keystone service-create --name=neutron \
                        --type=network \
                        --description="Networking Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $NEUTRON_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:9696" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:9696" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:9696"
fi


#
# Heat service
#
HEAT_SERVICE=$(get_id \
keystone service-create --name=heat \
                        --type=orchestration \
                        --description="Orchestration")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $HEAT_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:8004/v1/\$(tenant_id)s" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:8004/v1/\$(tenant_id)s" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:8004/v1/\$(tenant_id)s"
fi
HEAT_CFN_SERVICE=$(get_id \
keystone service-create --name=heat-cfn \
                        --type=cloudformation \
                        --description="Orchestration CloudFormation")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $HEAT_CFN_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:8000/v1" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:8000/v1" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:8000/v1"
fi


#
# Ceilometer Service
#
CEILOMETER_SERVICE=$(get_id \
keystone service-create --name=ceilometer \
                        --type=metering \
                        --description="Metering Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $CEILOMETER_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:8777" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:8777" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:8777"
fi




#
# Swift service
#
SWIFT_SERVICE=$(get_id \
keystone service-create --name=swift \
                        --type="object-store" \
                        --description="Swift Service")
if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --service-id $SWIFT_SERVICE \
        --publicurl   "http://$CONTROLLER_PUBLIC_ADDRESS:8888/v1/AUTH_\$(tenant_id)s" \
        --adminurl    "http://$CONTROLLER_ADMIN_ADDRESS:8888/v1" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:8888/v1/AUTH_\$(tenant_id)s"
fi

