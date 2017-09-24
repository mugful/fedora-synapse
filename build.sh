#!/bin/bash

set -euxo pipefail

yum -y install jq matrix-synapse
yum clean all

groupmod -g 408448 synapse
usermod -u 408448 synapse
chown -R synapse: /var/lib/synapse
