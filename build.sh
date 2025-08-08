#!/bin/bash

set -euxo pipefail

groupadd -g 48448 synapse
useradd -u 48448 -g 48448 -d /run/synapse -s /sbin/nologin synapse

yum -y install jq matrix-synapse python3-jinja2
yum clean all

chown -R synapse: /var/lib/synapse
