#!/bin/bash

set -euxo pipefail

yum -y install jq matrix-synapse
yum clean all

groupmod -g 48448 synapse
usermod -u 48448 synapse
chown -R synapse: /var/lib/synapse
