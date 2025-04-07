#!/bin/bash

# Use the directory where is save it as references
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify correct folder
cd "$SCRIPT_DIR" || exit 1

terraform init
terraform plan 
terraform apply -auto-approve
terraform output > output_ip.txt
./allocatesIP.sh
